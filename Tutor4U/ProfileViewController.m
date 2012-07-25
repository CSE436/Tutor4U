//
//  ProfileViewController.m
//  Tutor4U
//
//  Created by Zeddy Chirombe on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "ParseLoginViewController.h"


@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize tutor4uID;
@synthesize firstName;
@synthesize lastName;
@synthesize phone;
@synthesize streetAddr;
@synthesize apartment;
@synthesize city;
@synthesize state;
@synthesize zipCode, email;

-(void)skipUserProfileEdits {
    
}

-(IBAction)updateUserProfile
{
    NSLog(@"-------updateUserProfile-------");
    //PFUser *currentUser = [PFUser currentUser];
    if (currentUser) { // No user logged in
        [currentUser refresh];
        currentUser.email = email.text;
        [currentUser save];
        
        //Create UserInfo entry on Parse - 
        if(userProfile) {
            NSLog(@"     updating user [ %@'s ]  profile..........", lastName.text);
        } else {
            NSLog(@"     Creating user [ %@ 's]  profile..........", lastName.text);
        }
        //update profile
        NSInteger ret = [parseTransport setUserProfile:currentUser.username :firstName.text :lastName.text :phone.text];
        if(ret != T4U_SUCCESS) {
            //throw error and act accordingly - 
            return;
        }
        
        //update user address
        ret = [parseTransport setUserAddress:currentUser.username :streetAddr.text :apartment.text :city.text :state.text :zipCode.text];
        if(ret != T4U_SUCCESS) {
            //throw error and act accordingly - 
            return;
        }
        [self checkEnableTabBar];
        return;
    }
    NSLog(@"UpdateUserProfile: Error - User not authorized to change this profile - ");
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
    [self setApartment:nil];
    [super viewDidUnload];
    
    
    // Release any retained subviews of the main view.
    NSLog(@"ViewController - Logging Out");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)checkEnableTabBar {
    id result = [[PFUser currentUser] objectForKey:@"emailVerified"];
    if ( result == nil || [result boolValue] == false ) {
        self.tabBarController.tabBar.userInteractionEnabled = NO;
    } else {
        self.tabBarController.tabBar.userInteractionEnabled = YES;
    }
}

-(void)logout {
    [PFUser logOut];
    currentUser = nil;
    [ParseTransport pushChannelManagement];
    
    [ParseLoginViewController setViewControllerInForeground:NO];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    tutor4uID.delegate = self;
    firstName.delegate = self;
    lastName.delegate = self;
    phone.delegate = self;
    streetAddr.delegate = self;
    apartment.delegate = self;
    city.delegate = self;
    state.delegate = self;
    zipCode.delegate = self;
    email.delegate = self;
    
    [self.tabBarController.navigationItem setHidesBackButton:YES];
    
    phoneNumberFormatter = [[PhoneNumberFormatter alloc] init];
    
    [self checkEnableTabBar];
    
    [phone addTarget:self
              action:@selector(autoFormatTextField:)
    forControlEvents:UIControlEventEditingChanged];

    parseTransport = [[ParseTransport alloc] init];
    currentUser = [PFUser currentUser];
    
    // make sure user does not change the assigned ID - 
    [self.tutor4uID setEnabled:NO]; 
    [self.tutor4uID setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    
    if ( currentUser )  {
        [self.tutor4uID setText:currentUser.username];
        if ( currentUser.isNew ) {
            self.tabBarController.navigationItem.title = @"Create Your Profile";
        } else {
            self.tabBarController.navigationItem.title = @"Update Your Profile";
        }
//    
        self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" 
                                                                                                   style:UIBarButtonItemStyleDone
                                                                                                  target:self 
                                                                                                  action:@selector(logout)];
        self.email.text = currentUser.email;
        
        userProfile = [parseTransport getUserProfile:currentUser.username];
        if(userProfile) {
            self.firstName.text = [userProfile objectForKey:@"FirstName"];
            self.lastName.text = [userProfile objectForKey:@"LastName"];
            self.phone.text = [userProfile objectForKey:@"PhoneNumber"];
        } else {
            NSLog(@"No User Profile");
        }
        userAddress = [parseTransport getUserAddress:currentUser.username];
        if ( userAddress ) {
            self.streetAddr.text = [userAddress objectForKey:@"StreetAddress"];
            self.apartment.text = [userAddress objectForKey:@"Apartment"];
            self.city.text = [userAddress objectForKey:@"City"];
            self.state.text = [userAddress objectForKey:@"State"];
            self.zipCode.text = [userAddress objectForKey:@"ZipCode"];
        } else {
            NSLog(@"No User Address");
        }
    } else {
        NSLog(@"Error");
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self updateUserProfile];
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


- (void)autoFormatTextField:(id)sender {
    
    static BOOL myTextFieldSemaphore = NO;
    if(myTextFieldSemaphore) return;
    
    myTextFieldSemaphore = YES;
    phone.text = [phoneNumberFormatter format:phone.text withLocale:@"us"];
    myTextFieldSemaphore = NO;
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
