//
//  AddTutorSession.h
//  Tutor4U
//
//  Created by Zeddy Chirombe on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseTransport.h"

@interface AddTutorSession : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *tutor4uID;
@property (strong, nonatomic) IBOutlet UITextField *subject;
@property (strong, nonatomic) IBOutlet UITextField *hourlyRate;
@property (strong, nonatomic) IBOutlet UITextField *meetingPlace;
@property (strong, nonatomic) IBOutlet UITextField *myRating;

@property (strong, nonatomic) IBOutlet UIButton *addSessionButton;
@property (strong, nonatomic) IBOutlet ParseTransport *parseTransport;


-(IBAction)addSession;
//-(void)showTutorSession:(PFObject *)session;

@end
