//
//  DetailedTutorInfoViewController.h
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedTutorInfoViewController : UIViewController {
    IBOutlet UIButton* connectAccept;
    IBOutlet UITextField *tutorIDField;
    IBOutlet UITextField *subjectField;
    
    NSMutableArray *studentRequests;
}
@property (retain,nonatomic) IBOutlet NSString* tutorIDString;
@property (strong, nonatomic) IBOutlet NSString *subjectString;
@property (retain,nonatomic) IBOutlet NSString* connectAcceptButtonText;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;

-(void)connectRequest;


@end
