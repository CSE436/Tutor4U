//
//  ProfileViewController.h
//  Tutor4U
//
//  Created by Zeddy Chirombe on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailedTutorInfoViewController.h"
#import "LoginViewController.h"
#import "ParseTransport.h"
#import "PhoneNumberFormatter.h"

@interface ProfileViewController : UIViewController <UITextFieldDelegate> {
    PFUser *currentUser;
    PFObject *userProfile, *userAddress;
    ParseTransport *parseTransport;
    PhoneNumberFormatter *phoneNumberFormatter;
}

@property (strong, nonatomic) IBOutlet UITextField *tutor4uID;
@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UITextField *lastName;
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *streetAddr;
@property (strong, nonatomic) IBOutlet UITextField *apartment;
@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UITextField *state;
@property (strong, nonatomic) IBOutlet UITextField *zipCode;

-(IBAction)updateUserProfile;

@end
