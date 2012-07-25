//
//  ParseLoginViewController.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParseLoginViewController.h"
#import "ProfileViewController.h"

@interface ParseLoginViewController ()

@end

@implementation ParseLoginViewController

static BOOL viewControllerInForeground = NO;

+(BOOL)viewControllerInForeground {
    return viewControllerInForeground;
}
+(void)setViewControllerInForeground:(BOOL)newVal {
    viewControllerInForeground = newVal;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"Parse Login View Controller");
    if ( [ParseLoginViewController viewControllerInForeground] == NO ) {
        logInViewController = [[LoginViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController]; 

        [self presentViewController:logInViewController animated:NO completion:NULL];
        [ParseLoginViewController setViewControllerInForeground:YES];
    }
    
}

-(void)checkEmailVerification {
    PFUser *currentUser = [PFUser currentUser];
    
    if ( currentUser ) {
        // Subscribe to my personal username
        NSLog(@"Subscribing to %@",currentUser.username);
        [PFPush subscribeToChannelInBackground:currentUser.username];
        
        if ( [currentUser objectForKey:@"emailVerified"] == nil ) {
            NSLog(@"Account Created Prior to Verification Enabled");
            UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:@"E-Mail Verification" message:@"Please Check That Your E-Mail Address is valid.  A verification E-Mail will be sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [emailAlert show];
            [self gotoTabbedView:2];
        } else if (![[currentUser objectForKey:@"emailVerified"] boolValue] ) {
            NSLog(@"Error: E-mail not verified\nYou must verify your email");
            UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:@"E-Mail Verification" message:@"You Have not Verified Your E-Mail Address Yet.  You Must do so Before Using this Application." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [emailAlert show];
            [self gotoTabbedView:2];
        } else {
            [self gotoTabbedView:0];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    PFUser *currentUser = [PFUser currentUser];
    
    if ( currentUser ) {
        [self checkEmailVerification];
    } else {
        NSLog(@"Create Parse Login");
        // Create the log in view controller
        //PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        //logInViewController = [[PFLogInViewController alloc] init];
        logInViewController = [[LoginViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController]; 

        
        // Present the log in view controller
        [ParseLoginViewController setViewControllerInForeground:YES];
        [self presentViewController:logInViewController animated:NO completion:NULL];
    }
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


//
// It works.  Sort Of
//
-(void)gotoTabbedView:(NSUInteger)tabNumber {
    // This is universal between the two methods
    [self dismissViewControllerAnimated:NO completion:NULL];
    UITabBarController* nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"myTabBarController"];
    nextView.selectedIndex = tabNumber;
    [self.navigationController pushViewController:nextView animated:NO];
}




#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    NSLog(@"should Begin Login");
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Missing Username/Password" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"did Log In - Change this so it doesn't goto profile creation");
    [self checkEmailVerification];
    //[self gotoTabbedView:2];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {    
    return;
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
    //ProfileViewController* nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [self gotoTabbedView:2];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
    //exit(0);
}


#pragma mark - Logout button handler

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
