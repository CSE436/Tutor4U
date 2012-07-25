//
//  DetailedTutorInfoViewController.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailedTutorInfoViewController.h"
#import "ParseTransport.h"

@interface DetailedTutorInfoViewController ()

@end

@implementation DetailedTutorInfoViewController

@synthesize connectButton;
@synthesize tutorIDString, subjectString, connectAcceptButtonText, hourlyRateString, locationString;

-(void)connectRequest
{
   // NSLog(@"-----Implement a push/point-2-point message to this Tutor------");
    PFUser* curUser = [PFUser currentUser];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Student Request", @"alert",
                          //@"Increment", @"badge",
                          subjectString, @"subject",
                          curUser.username, @"studentUser",
                          nil];
    PFPush *push = [[PFPush alloc] init];
    
    //NSMutableArray *channels = [NSMutableArray arrayWithArray:[subject.text componentsSeparatedByString:@","]];
    [push setChannels:[[NSArray alloc] initWithObjects:tutorIDString, nil]];
    [push setPushToAndroid:false];
    [push expireAfterTimeInterval:86400];
    [push setData:data];
    [push sendPushInBackground]; 
    NSLog(@"Pushing to channel: %@",tutorIDString);
}


-(void)viewWillAppear:(BOOL)animated {
    tutorIDField.text = tutorIDString;
    subjectField.text = subjectString;
    
    if ( hourlyRateString != nil ) 
        hourlyRate.text = hourlyRateString;
    else {
        hourlyRate.text = @"$10.00";
    }
    if ( locationString != nil )
        location.text = locationString;
    else {
        location.text = @"Negotiable";
    }
    [[connectAccept titleLabel] setText:connectAcceptButtonText];
}

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
    
    [connectButton addTarget:self action:@selector(connectRequest) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    subjectField = nil;
    tutorIDField = nil;
    [self setConnectButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
