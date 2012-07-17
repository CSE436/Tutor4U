/*
//
//  ViewController.h
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@end

*/

//
//  ViewController.h
//  ParseTrans
//
//  Created by Zeddy Chirombe on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogInViewController.h"
#import "SignUpViewController.h"


@interface ViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate> {
    UILabel *welcomeLabel;
}


@property (nonatomic, strong) IBOutlet UILabel *welcomeLabel;

- (IBAction)logOutButtonTapAction:(id)sender;


@end