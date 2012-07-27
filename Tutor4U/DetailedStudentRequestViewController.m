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

@synthesize studentName;

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
    NSLog(@"refreshData");
    messages = [[NSMutableArray alloc] initWithArray:[[NotificationQueue_Conversation sharedInstance] getMessages:studentName]];
    [myTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    if ( messages == nil ) {
        messages = [[NSMutableArray alloc] init];
    }
    
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
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

        NSLog(@"Add Message");
        [[NotificationQueue_Conversation sharedInstance] addMessage:newMessage
                                                               user:studentName 
                                                           fromUser:username];
        
//        [messages addObject:newMessage];
        [self refreshData];
    }
    messageField.text = @"";
    [self hideKeyboard];
}

#pragma mark UITableViewDataSource

//
// Called Prior to cellForRow
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"heightForRow");
    NSDictionary *message = [messages objectAtIndex:indexPath.row];
    CGFloat ret = [ChatBubbleCell calcCellHeight:message diff:0];
    
    
//    CGRect rect = [((NSValue*)[message objectForKey:@"bubbleRect"]) CGRectValue];
//    NSLog(@"(%f,%f) -> (%f,%f)",rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    [messages removeObjectAtIndex:indexPath.row];
    [messages insertObject:message atIndex:indexPath.row];
    
    return ret;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRows:  %i",[messages count]);
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
    
    CGFloat oldHeight = plateView.frame.origin.y;
    CGRect frame = self.view.frame;
    frame.origin.y = 150-oldHeight;
    self.view.frame = frame;
    
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
    
    [UIView commitAnimations];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendMessage];
    return YES;
}

@end
