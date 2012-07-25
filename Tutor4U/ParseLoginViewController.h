//
//  ParseLoginViewController.h
//  Tutor4U
//
//  Created by Andrew Kutta on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogInViewController.h"
#import "SignUpViewController.h"
#import "ParseTransport.h"

@interface ParseLoginViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate> {
    //PFLogInViewController *logInViewController;
}


//@property (strong, nonatomic) IBOutlet UITabBarController *myTabBarController;

@end
