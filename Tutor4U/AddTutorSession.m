//
//  AddTutorSession.m
//  Tutor4U
//
//  Created by Zeddy Chirombe on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddTutorSession.h"
#import "ParseLoginViewController.h"

@interface AddTutorSession ()

@end

@implementation AddTutorSession

@synthesize tutor4uID;
@synthesize subject;
@synthesize hourlyRate;
@synthesize meetingPlace;
@synthesize myRating;
@synthesize parseTransport;

-(IBAction)addSession {
    NSInteger ret = [parseTransport uploadTutor:[PFUser currentUser].username :subject.text :hourlyRate.text :meetingPlace.text :myRating.text];

    NSUserDefaults *std = [NSUserDefaults standardUserDefaults];
    [std setValue:subject.text forKey:@"lastSubject"];
    [std setValue:hourlyRate.text forKey:@"hourlyRate"];
    [std setValue:meetingPlace.text forKey:@"location"];

    if(ret != T4U_SUCCESS) {
        //Notify user of this problem - 
        NSLog(@"Error: addMySession() : Failed to add TutorSession to Parse....");
    } else {
        NSLog(@"Info: addMySession() : Uploaded your Tutor Session to Parse....");
    }
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"New Tutor Available", @"alert",
                          //@"Increment", @"badge",
                          subject.text, @"subject",
                          myRating.text, @"rating",
                          hourlyRate.text, @"hourlyRate",
                          nil];
    PFPush *push = [[PFPush alloc] init];
    
    NSMutableArray *channels = [NSMutableArray arrayWithArray:[subject.text componentsSeparatedByString:@","]];
    [push setChannels:channels];
    [push setPushToAndroid:false];
    [push expireAfterTimeInterval:86400];
    [push setData:data];
    [push sendPushInBackground];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//----------

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    parseTransport = [[ParseTransport alloc] init];
}

-(void)logout {
    [PFUser logOut];
    [ParseTransport pushChannelManagement];
    
    [ParseLoginViewController setViewControllerInForeground:NO];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewWillAppear:(BOOL)animated {
    self.subject.delegate = self;
    self.hourlyRate.delegate = self;
    self.meetingPlace.delegate = self;
    self.myRating.delegate = self;
    self.myRating.enabled = NO;
    
    NSUserDefaults *std = [NSUserDefaults standardUserDefaults];
    subject.text = (NSString*)[std objectForKey:@"lastSubject"];
    hourlyRate.text = (NSString*)[std objectForKey:@"hourlyRate"];
    meetingPlace.text = (NSString*)[std objectForKey:@"location"];
    
    phoneNumberFormatter = [[PhoneNumberFormatter alloc] init];
    [self.hourlyRate addTarget:self
              action:@selector(autoFormatTextField:)
    forControlEvents:UIControlEventEditingChanged];
    
    
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" 
                                                                                               style:UIBarButtonItemStyleDone
                                                                                              target:self 
                                                                                              action:@selector(logout)];
    [self.tabBarController.navigationItem setHidesBackButton:YES];
    [self.tabBarController.navigationItem setTitle:@"Tutor Control"];
}

- (void)viewDidUnload
{
    [self setTutor4uID:nil];
    [self setSubject:nil];
    [self setHourlyRate:nil];
    [self setMeetingPlace:nil];
    [self setMyRating:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView setAnimationsEnabled:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedAnimation)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    CGFloat oldHeight = textField.frame.origin.y;
    CGRect frame = self.view.frame;
    frame.origin.y = 48-oldHeight;
    self.view.frame = frame;
    
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView setAnimationsEnabled:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView  setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedAnimation)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
    
    [UIView commitAnimations];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)autoFormatTextField:(id)sender {
    
    static BOOL myTextFieldSemaphore = NO;
    if(myTextFieldSemaphore) return;
    
    myTextFieldSemaphore = YES;
    if ( [hourlyRate.text rangeOfString:@"$"].location == NSNotFound ) {
        hourlyRate.text = [NSString stringWithFormat:@"$%@",hourlyRate.text];
    }
    //hourlyRate.text = [phoneNumberFormatter format:hourlyRate.text withLocale:@"usDollar"];
    myTextFieldSemaphore = NO;
    
}

@end
