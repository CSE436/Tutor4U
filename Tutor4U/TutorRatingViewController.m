//
//  TutorRatingViewController.m
//  Tutor4U
//
//  Created by Zeddy Chirombe on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorRatingViewController.h"

@interface TutorRatingViewController ()

@end

@implementation TutorRatingViewController
@synthesize tutorUserName;
@synthesize punctualityLabel;
@synthesize knowledgeLabel;
@synthesize abilityLabel;
@synthesize subjectTextField;
@synthesize punctualitySlider;
@synthesize knowledgeSlider;
@synthesize abilitySlider;
@synthesize sendReviewButton;

@synthesize subjectString;
@synthesize userNameString;

-(IBAction) sliderValueChanged:(UISlider *)sender
{
    //NSLog(@"Rating In progress : Punctuality[ %i ], Knowledge[ %i ], ability[ %i ]", (int)punctualitySlider.value, (int)knowledgeSlider.value, (int)abilitySlider.value);
    if(sender == punctualitySlider) {
        punctualityLabel.text = [NSString stringWithFormat:@"Punctuality ( %i )", (int)punctualitySlider.value];
    } else if(sender == knowledgeSlider) {
        knowledgeLabel.text = [NSString stringWithFormat:@"Knowledge of subject ( %i )", (int)knowledgeSlider.value];
    } else if(sender == abilitySlider) {
        abilityLabel.text = [NSString stringWithFormat:@"Tutoring Ability ( %i )", (int)abilitySlider.value];
    }
}
-(void)sendReview
{     
    tutorRating = [parseTransport getTutorRating:tutorUserName.text];
    //NSLog(@"sendReview : %@ ",tutorRating);
    
    int stars = 0;
    int reviewSum = (int)(punctualitySlider.value + knowledgeSlider.value + abilitySlider.value) / 3;
    int reviewCnt = 0;

    if(tutorRating != nil) {
        reviewSum = [[tutorRating objectForKey:@"SumOfReviews"] intValue] + reviewSum;
        reviewCnt = [[tutorRating objectForKey:@"ReviewsCount"] intValue] + 1;
        reviewCnt = ( reviewCnt <= 0) ? 1 : reviewCnt;
        stars = (int)(reviewSum / reviewCnt);
    }
    int ret = [parseTransport setTutorRating:tutorUserName.text :[NSNumber numberWithFloat:reviewSum] :[NSNumber numberWithInt:reviewCnt]];
    if( ret != T4U_SUCCESS ) {
        //post ViewAlert to notify the user - 
        NSLog(@"Error : Sending Tutor Review -----");
    }
    NSLog(@"Rating In progress : Punctuality[ %i ], Knowledge[ %i ], ability[ %i ]", (int)punctualitySlider.value, (int)knowledgeSlider.value, (int)abilitySlider.value);
    NSLog(@"Rating In progress : SumOfReviews[ %i ], ReviewCount[ %i ], Stars[ %i ] ",reviewSum, reviewCnt, stars);
    
    //[self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
}


//--------------------------

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
    subjectTextField.delegate = self;
    
    parseTransport = [[ParseTransport alloc] init];
    [tutorUserName setText:userNameString];
    [sendReviewButton addTarget:self action:@selector(sendReview) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    [self setPunctualitySlider:nil];
    [self setKnowledgeSlider:nil];
    [self setAbilitySlider:nil];
    [self setPunctualityLabel:nil];
    [self setKnowledgeLabel:nil];
    [self setAbilityLabel:nil];
    [self setSendReviewButton:nil];
    [self setSubjectTextField:nil];
    [self setTutorUserName:nil];
    [self setPunctualitySlider:nil];
    [self setKnowledgeSlider:nil];
    [self setAbilitySlider:nil];
    [self setSubjectTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
