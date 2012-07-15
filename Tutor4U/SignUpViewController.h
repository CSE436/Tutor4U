//
//  SignUpViewController.h
//  ParseTrans
//
//  Created by Zeddy Chirombe on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface SignUpViewController : PFSignUpViewController {
    UIImageView *fieldsBackground;
}


@property (nonatomic, strong) UIImageView *fieldsBackground;


@end
