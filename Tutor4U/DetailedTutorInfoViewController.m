//
//  DetailedTutorInfoViewController.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailedTutorInfoViewController.h"

@interface DetailedTutorInfoViewController ()

@end

@implementation DetailedTutorInfoViewController


@synthesize connectButton;


@synthesize tutorIDString, subjectString, connectAcceptButtonText, hourlyRateString, locationString;



-(void)connectRequest
{
    NSLog(@"-----Implement a push/point-2-point message to this Tutor------");
    
}


-(void)viewWillAppear:(BOOL)animated {
    tutorIDField.text = tutorIDString;
    subjectField.text = subjectString;
    hourlyRate.text = hourlyRateString;
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
