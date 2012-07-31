//
//  TutorRatingViewController.h
//  Tutor4U
//
//  Created by Zeddy Chirombe on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseTransport.h"

@interface TutorRatingViewController : UIViewController <UITextFieldDelegate> {
    
    ParseTransport *parseTransport;
    PFObject *tutorRating;
    
}
@property (strong, nonatomic) IBOutlet UILabel *tutorUserName;
@property (strong, nonatomic) IBOutlet UILabel *punctualityLabel;
@property (strong, nonatomic) IBOutlet UILabel *knowledgeLabel;
@property (strong, nonatomic) IBOutlet UILabel *abilityLabel;
@property (strong, nonatomic) IBOutlet UITextField *subjectTextField;


@property (strong, nonatomic) NSString *userNameString;
@property (strong, nonatomic) NSString *subjectString;

@property (strong, nonatomic) IBOutlet UISlider *punctualitySlider;
@property (strong, nonatomic) IBOutlet UISlider *knowledgeSlider;
@property (strong, nonatomic) IBOutlet UISlider *abilitySlider;


@property (strong, nonatomic) IBOutlet UIButton *sendReviewButton;

-(IBAction) sliderValueChanged:(UISlider *)sender;
-(void)sendReview;

@end
