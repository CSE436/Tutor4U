//
//  DetailedTutorInfoViewController.h
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseTransport.h"
#import "TutorRatingViewController.h"

@interface DetailedTutorInfoViewController : UIViewController {
    IBOutlet UIButton* connectAccept;
    IBOutlet UILabel *tutorIDField;
    IBOutlet UILabel *subjectField;
    IBOutlet UILabel *hourlyRate;
    IBOutlet UILabel *location;
    
    IBOutlet UIImageView *ratingImgView1;
    IBOutlet UIImageView *ratingImgView2;
    IBOutlet UIImageView *ratingImgView3;
    IBOutlet UIImageView *ratingImgView4;
    IBOutlet UIImageView *ratingImgView5;
    
    
    NSMutableArray *studentRequests;
    
    ParseTransport *parseTransport;
    PFObject *tutorRating;
    
}
@property (retain,nonatomic) NSString* tutorIDString;
@property (strong, nonatomic) NSString *subjectString;
@property (retain, nonatomic) NSString* hourlyRateString;
@property (retain, nonatomic) NSString* locationString;
@property (strong, nonatomic) NSString* tutorRatingString;
@property (retain,nonatomic) NSString* connectAcceptButtonText;


@property (strong, nonatomic) IBOutlet UIButton *connectButton;
@property (strong, nonatomic) IBOutlet UIButton *reviewButton;


//rating info - 
@property (strong, nonatomic) IBOutlet UIImageView *ratingImgView1;
@property (strong, nonatomic) IBOutlet UIImageView *ratingImgView2;
@property (strong, nonatomic) IBOutlet UIImageView *ratingImgView3;
@property (strong, nonatomic) IBOutlet UIImageView *ratingImgView4;
@property (strong, nonatomic) IBOutlet UIImageView *ratingImgView5;

-(void)connectRequest;
-(void)tutorReview;


@end
