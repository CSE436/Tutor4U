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
    IBOutlet UILabel *tutorIDField;
    IBOutlet UILabel *subjectField;
    IBOutlet UILabel *hourlyRate;
    IBOutlet UILabel *location;
    
    NSMutableArray *studentRequests;
}
@property (retain,nonatomic) NSString* tutorIDString;
@property (strong, nonatomic) NSString *subjectString;
@property (retain, nonatomic) NSString* hourlyRateString;
@property (retain, nonatomic) NSString* locationString;
@property (retain,nonatomic) NSString* connectAcceptButtonText;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;

-(void)connectRequest;


@end
