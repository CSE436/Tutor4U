//
//  ProfileViewController.h
//  Tutor4U
//
//  Created by Zeddy Chirombe on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailedTutorInfoViewController.h"
#import "LogInViewController.h"
#import "SignUpViewController.h"
#import "ParseTransport.h"


@interface ProfileViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate> {
    PFObject *userProfile;
    PFObject *userAddress;
    PFObject *tutorSession;
    PFObject *studentSession;
    BOOL userInfoEditable;
    BOOL userInfoLoaded;
    ParseTransport *parseTransport;    
}


@property (strong, nonatomic) IBOutlet UITextField *tutor4uID;
@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UITextField *lastName;
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet UITextField *streetAddr;
@property (strong, nonatomic) IBOutlet UITextField *appartment;
@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UITextField *state;
@property (strong, nonatomic) IBOutlet UITextField *zipCode;
@property (strong, nonatomic) IBOutlet ParseTransport *parseTransport; 


@property (strong, nonatomic) IBOutlet UIButton *updateUInfoButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelUInfoButton;
@property (strong, nonatomic) IBOutlet UITabBarController *myTabBarController;


-(IBAction)updateUserProfile;
-(IBAction)cancelUserProfile;
-(int)loadUserInfo:(NSString *)_tutor4u_id;
-(void)skipUserProfileEdits;
-(id)init;


@end
