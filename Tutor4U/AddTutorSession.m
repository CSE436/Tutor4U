//
//  AddTutorSession.m
//  Tutor4U
//
//  Created by Zeddy Chirombe on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddTutorSession.h"

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
    
}



-(void)addMySession
{
    NSInteger ret = [parseTransport uploadTutor:tutor4uID.text :subject.text :hourlyRate.text :meetingPlace.text :myRating.text];
    if(ret != T4U_SUCCESS) {
        //Notify user of this problem - 
        NSLog(@"Error: addMySession() : Failed to add TutorSession to Parse....");
    } else {
        NSLog(@"Info: addMySession() : Uploaded your Tutor Session to Parse....");
    }
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

@end
