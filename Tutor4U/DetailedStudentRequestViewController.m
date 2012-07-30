//
//  DetailedStudentRequestViewController.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParseTransport.h"
#import "ChatBubbleCell.h"
#import "DetailedStudentRequestViewController.h"
#import "NotificationQueue_Conversation.h"
#import <QuartzCore/QuartzCore.h>

@interface DetailedStudentRequestViewController ()

@end

@implementation DetailedStudentRequestViewController

@synthesize studentName,fromType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)hideKeyboard {
    [messageField endEditing:YES];
    [messageField resignFirstResponder];
}

-(UIImage*)imageFromColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(void)refreshData {
    messages = [[NSMutableArray alloc] initWithArray:[[NotificationQueue_Conversation sharedInstance] getMessages:studentName]];
    [myTableView reloadData];
    if ( [messages count] > 0 ) {
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:[messages count]-1 inSection:0];
        [myTableView scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}

-(void)connectWithTutor {
    NSLog(@"Create Alertview to connect or reject");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Accept / Reject" message:@"Do you wish to meet with this student?" delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept", nil];
    [alert show];
}

-(void)viewWillAppear:(BOOL)animated {
    if ( messages == nil ) {
        messages = [[NSMutableArray alloc] init];
    }
    
    
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
    [self refreshData];
    
    // Make tableview all one color
    myTableView.separatorColor = [UIColor colorWithRed:0.859 green:0.886 blue:0.929 alpha:1.0];
    myTableView.backgroundColor = [UIColor colorWithRed:0.859 green:0.886 blue:0.929 alpha:1.0];
    
    // recognize touch on tableview to hide 
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [myTableView addGestureRecognizer:gestureRecognizer];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshConversation" object:nil];
    
    // Add Border
    [messageField.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    messageField.layer.borderWidth = 1;
    
    [sendButton.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    sendButton.layer.borderWidth = 2;
    [sendButton.layer setCornerRadius:15];
    
    [plateView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [plateView.layer setBorderWidth:3];
    
    messageField.delegate = self;
    
    [self.navigationItem setTitle:studentName];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Accept/Reject" 
                                                                                               style:UIBarButtonItemStyleDone  
                                                                                              target:self 
                                                                                              action:@selector(connectWithTutor)];
//    [connectReject setTitle:@"Accept/Reject"];
//    self.navigationItem.rightBarButtonItem = connectReject;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)sendMessage {
    if ( [messageField.text length] > 0 ) {
    
        NSString *username = [PFUser currentUser].username;
    
        NSLog(@"%@ -> %@:\n\t%@",username,studentName,messageField.text);
//    
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSString stringWithFormat:@"New Message From %@",username], @"alert",
                              username, @"userName",
                              messageField.text, @"message",
                              fromType, @"fromType",
                              [[NSNumber alloc] initWithInt:MESSAGE_RECIEVE], @"messageType",
                          nil];
        PFPush *push = [[PFPush alloc] init];
    
        //NSMutableArray *channels = [NSMutableArray arrayWithArray:[subject.text componentsSeparatedByString:@","]];
        [push setChannels:[[NSArray alloc] initWithObjects:studentName, nil]];
        [push setPushToAndroid:false];
        [push expireAfterTimeInterval:86400];
        [push setData:data];
        [push sendPushInBackground];
                
        NSMutableDictionary *newMessage = [[NSMutableDictionary alloc] initWithDictionary:data];
        [newMessage removeObjectForKey:@"messageType"];
        [newMessage setObject:[[NSNumber alloc] initWithInt:MESSAGE_SEND] forKey:@"messageType"];

        [[NotificationQueue_Conversation sharedInstance] addMessage:newMessage
                                                               user:studentName 
                                                           fromUser:username];
        
//        [[NotificationQueue_Conversation sharedInstance] saveToDisk];
        
//        [messages addObject:newMessage];
        [self refreshData];
    }
    messageField.text = @"";
    [self hideKeyboard];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"Selected %@",[alertView buttonTitleAtIndex:buttonIndex]);
}

#pragma mark UITableViewDataSource

//
// Called Prior to cellForRow
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *message = [messages objectAtIndex:indexPath.row];
    CGFloat ret = [ChatBubbleCell calcCellHeight:message diff:0];
    
    [messages removeObjectAtIndex:indexPath.row];
    [messages insertObject:message atIndex:indexPath.row];
    
    return ret;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [messages count];
}

//
//  Called after heightForRowAtIndexPath
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatBubbleCell *cell = (ChatBubbleCell*)[tableView dequeueReusableCellWithIdentifier:@"ChatBubbleCell"];
    
    if ( cell == nil ) {
        cell = [[ChatBubbleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatBubbleCell"];
    }
    
    NSDictionary *message = [messages objectAtIndex:indexPath.row];
    [cell setMessage:message];
    return cell;
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [UIView setAnimationsEnabled:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedAnimation)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    CGRect frame = self.view.frame;
    frame.origin.y = -216;//150-oldHeight;
    self.view.frame = frame;
    
    frame = myTableView.frame;
    frame.origin.y = 216;
    frame.size.height = plateView.frame.origin.y - frame.origin.y;
    myTableView.frame = frame;
    
    [UIView commitAnimations];

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView setAnimationsEnabled:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedAnimation)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
    
    
    frame = myTableView.frame;
    frame.origin.y = 0;
    frame.size.height = plateView.frame.origin.y - frame.origin.y;
    myTableView.frame = frame;
    
    [UIView commitAnimations];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendMessage];
    return YES;
}

@end
