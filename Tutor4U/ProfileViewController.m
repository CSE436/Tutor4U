//
//  ProfileViewController.m
//  Tutor4U
//
//  Created by Zeddy Chirombe on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize updateUInfoButton;
@synthesize cancelUInfoButton;


@synthesize tutor4uID;
@synthesize firstName;
@synthesize lastName;
@synthesize phone;
@synthesize streetAddr;
@synthesize appartment;
@synthesize city;
@synthesize state;
@synthesize zipCode;

@synthesize parseTransport;
@synthesize myTabBarController;



-(IBAction)updateUserProfile
{
    NSLog(@"-------updateUserProfile-------");
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) { // No user logged in
        //Create UserInfo entry on Parse - 
        if(userProfile) {
            NSLog(@"     updating user [ %@'s ]  profile..........", lastName.text);
        } else {
            NSLog(@"     Creating user [ %@ 's]  profile..........", lastName.text);
            userProfile = [PFObject objectWithClassName:@"userProfile"];
            userAddress = [PFObject objectWithClassName:@"userAddress"];
        }
        //update profile
        NSInteger ret = [parseTransport setUserProfile:currentUser.email :firstName.text :lastName.text :phone.text];
        if(ret != T4U_SUCCESS) {
            //throw error and act accordingly - 
            return;
        }
        
        //update user address
        ret = [parseTransport setUserAddress:currentUser.email :streetAddr.text :appartment.text :city.text :state.text :zipCode.text];
        if(ret != T4U_SUCCESS) {
            //throw error and act accordingly - 
            return;
        }
        
        // revert back to the main screen - 
        [self endUserProfileEdits];
        return;
    }
    NSLog(@"UpdateUserProfile: Error - User not authorized to change this profile - ");
}

-(IBAction)cancelUserProfile
{
    // revert back to the main screen - 
    [self endUserProfileEdits];
}

-(int)loadUserInfo:(NSString *)_tutor4u_id
{
    if(userProfile != nil) return T4U_SUCCESS;
    userProfile = [parseTransport getUserProfile:_tutor4u_id];
    if(userProfile == nil) {
        //Finalize the userProfile Information - 
        NSLog(@"No Profile for User [ %@ ]",_tutor4u_id);
        return 1001;
    }
    userAddress = [parseTransport getUserAddress:_tutor4u_id];
    if(userAddress == nil) {
        NSLog(@"No Address for User [ %@ ]",_tutor4u_id);
        return 1002;
    }
    return 0;
}

-(void)endUserProfileEdits
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController pushViewController:myTabBarController animated:YES];
    self.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"MyProfile"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setTitle:@"My User Profile"];
    userInfoEditable = NO;
}

//---------------




-(id)init 
{
    [self superclass];
    userInfoEditable = NO;
    userInfoLoaded = NO;
    userProfile = nil;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.tutor4uID setEnabled:NO]; // make sure user does not change the assigned ID - 
    [self.tutor4uID setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    
    myTabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"myTabBarController"];
    
    parseTransport = [[ParseTransport alloc] init];
    
    [updateUInfoButton addTarget:self action:@selector(updateUserProfile) forControlEvents:UIControlEventTouchUpInside];
    [cancelUInfoButton addTarget:self action:@selector(cancelUserProfile) forControlEvents:UIControlEventTouchUpInside];

    //[PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) { // No user logged in
        if(!userInfoEditable && userProfile) {
            NSLog(@"vdl - Current User [ %@ ] -  UProfile Not editable - skipping Profile Edits....!!!", currentUser.username);
            [self endUserProfileEdits];
            return;
        } 
        NSLog(@"Current User [ %@ ] -  skipping Authentication....!!!", currentUser.username);
        //Load User profile data - create the profile if its not already set - 
        // this is the place to acquire the rest of the userProfile data - potentially from UserDefaults - 
        if(!userInfoLoaded) {
            int uinfo = [self loadUserInfo:currentUser.email];
            if(uinfo == T4U_SUCCESS) {
                //Create UserInfo entry on Parse - 
                NSLog(@"  vdl   Profile for user [ %@ ] is allready created, bypassing UserInfoView..........", currentUser.email);
                [self endUserProfileEdits];
                userInfoLoaded = YES;
            }
        }
        return;
    } 
    // Create the log in view controller
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Create the sign up view controller
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController]; 
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
    
}

- (void)viewDidUnload
{
    [self setTutor4uID:nil];
    [self setFirstName:nil];
    [self setLastName:nil];
    [self setPhone:nil];
    [self setStreetAddr:nil];
    [self setCity:nil];
    [self setState:nil];
    [self setZipCode:nil];
    [self setTutor4uID:nil];
    [self setUpdateUInfoButton:nil];
    [self setCancelUInfoButton:nil];
    [self setAppartment:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    NSLog(@"ViewController - Loging Out");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) { // No user logged in
        if(!userInfoEditable && userProfile) {
            NSLog(@"Current User [ %@ ] -  UProfile Not editable - skipping Profile Edits....!!!", currentUser.username);
            return;
        } 
        NSLog(@"Current User [ %@ ] -  skipping Authentication....!!!", currentUser.username);
        //Load User profile data - create the profile if its not already set - 
        // this is the place to acquire the rest of the userProfile data - potentially from UserDefaults - 
        if(!userInfoLoaded) {
            int uinfo = [self loadUserInfo:currentUser.email];
            if(uinfo == T4U_SUCCESS) {
                //Create UserInfo entry on Parse - 
                NSLog(@" vwa    Profile for user [ %@ ] is allready created, closing UserInfoView..........", currentUser.email);
                userInfoLoaded = YES;
            }
        }
        return;
    } 
}


#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Make sure you fill out all of the information!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Make sure you fill out all of the information!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


#pragma mark - Logout button handler

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
