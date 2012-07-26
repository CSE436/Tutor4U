//
//  DetailedStudentRequestViewController.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailedStudentRequestViewController.h"
#import "ChatBubbleCell.h"
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

-(void)viewWillAppear:(BOOL)animated {
    if ( messages == nil ) {
        messages = [[NSMutableArray alloc] init];
    }
    
    // Make tableview all one color
    myTableView.separatorColor = [UIColor colorWithRed:0.859 green:0.886 blue:0.929 alpha:1.0];
    myTableView.backgroundColor = [UIColor colorWithRed:0.859 green:0.886 blue:0.929 alpha:1.0];
    
    // recognize touch on tableview to hide 
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [myTableView addGestureRecognizer:gestureRecognizer];

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

-(IBAction)sendMessage {
    messageField.text = @"";
    [self hideKeyboard];
}

#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatBubbleCell *cell = (ChatBubbleCell*)[tableView dequeueReusableCellWithIdentifier:@"ChatBubbleCell"];
    if ( cell == nil ) {
        cell = [[ChatBubbleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatBubbleCell"];
        NSDictionary *message = [messages objectAtIndex:indexPath.row];
        [cell setMessage:[message objectForKey:@"message"] msgType:(MessageType)[message objectForKey:@"messageType"]];
        
    }
    return nil;
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
