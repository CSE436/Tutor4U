//
//  LoginViewController.h
//  ParseTrans
//
//  Created by Zeddy Chirombe on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface LoginViewController : PFLogInViewController {
    UIImageView *fieldsBackground;
}


@property (nonatomic, strong) UIImageView *fieldsBackground;


@end
