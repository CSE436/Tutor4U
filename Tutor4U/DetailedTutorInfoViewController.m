//
//  DetailedTutorInfoViewController.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailedTutorInfoViewController.h"
#import "ParseTransport.h"

@interface DetailedTutorInfoViewController ()

@end

@implementation DetailedTutorInfoViewController

@synthesize ratingImgView1;
@synthesize ratingImgView2;
@synthesize ratingImgView3;
@synthesize ratingImgView4;
@synthesize ratingImgView5;

@synthesize connectButton;
@synthesize reviewButton;

@synthesize tutorIDString, subjectString, connectAcceptButtonText, hourlyRateString, locationString, tutorRatingString;

-(void)connectRequest
{
   // NSLog(@"-----Implement a push/point-2-point message to this Tutor------");
    PFUser* curUser = [PFUser currentUser];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Student Request", @"alert",
                          //@"Increment", @"badge",
                          subjectString, @"subject",
                          curUser.username, @"studentUser",
                          @"student",@"fromType",   // Student response to tutor (student Requests)
                          nil];
    PFPush *push = [[PFPush alloc] init];
    
    [push setChannels:[[NSArray alloc] initWithObjects:tutorIDString, nil]];
    [push setPushToAndroid:false];
    [push expireAfterTimeInterval:86400];
    [push setData:data];
    [push sendPushInBackground]; 
    NSLog(@"Pushing to channel: %@",tutorIDString);
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tutorReview
{
    TutorRatingViewController *myRating = [self.storyboard instantiateViewControllerWithIdentifier:@"myTutorRating"];
    
    [myRating setUserNameString:tutorIDString];
    [myRating setSubjectString:subjectString];
    [self.navigationController pushViewController:myRating animated:YES];
    // NSLog(@"----Rating tutor--------");
    
}

-(void)viewWillAppear:(BOOL)animated {
    tutorIDField.text = tutorIDString;
    subjectField.text = subjectString;
    
    tutorRating = [parseTransport getUserRating:tutorIDString];
    
    int stars = 0;
    if(tutorRating != nil) {
        int reviewSum = [[tutorRating objectForKey:@"SumOfReviews"] intValue];
        int reviewCnt = [[tutorRating objectForKey:@"ReviewsCount"] intValue];
        if(reviewCnt > 0) {
            stars = (int)(reviewSum / reviewCnt);
        }
    }
    CGSize box = CGSizeMake(100, 100);
    for(int i =0; i < 5; i++, stars--) {
        if(i == 0) { 
            if(stars > 0) { [self.ratingImgView1 setImage:[UIImage imageNamed:@"iTutor-4u-star.png"]]; } 
            else {
                [self.ratingImgView1 setImage:[UIImage imageNamed:@"iTutor-4u-no-star.png"]];
            }
            [self.ratingImgView1 sizeThatFits:box];
        } else if(i == 1) { 
            if(stars > 0) { [self.ratingImgView2 setImage:[UIImage imageNamed:@"iTutor-4u-star.png"]]; } 
            else {
                [self.ratingImgView2 setImage:[UIImage imageNamed:@"iTutor-4u-no-star.png"]];
            }
        } else if(i == 2) { 
            if(stars > 0) { [self.ratingImgView3 setImage:[UIImage imageNamed:@"iTutor-4u-star.png"]]; } 
            else {
                [self.ratingImgView3 setImage:[UIImage imageNamed:@"iTutor-4u-no-star.png"]];
            }
        } else if(i == 3) { 
            if(stars > 0) { [self.ratingImgView4 setImage:[UIImage imageNamed:@"iTutor-4u-star.png"]]; } 
            else {
                [self.ratingImgView4 setImage:[UIImage imageNamed:@"iTutor-4u-no-star.png"]];
            }
        } else if(i == 4) { 
            if(stars > 0) { [self.ratingImgView5 setImage:[UIImage imageNamed:@"iTutor-4u-star.png"]]; } 
            else {
                [self.ratingImgView5 setImage:[UIImage imageNamed:@"iTutor-4u-no-star.png"]];
            }
        }
    }
    
    if ( [hourlyRateString length] > 0 ) 
        hourlyRate.text = hourlyRateString;
    else {
        hourlyRate.text = @"$10.00";
    }
    if ( [locationString length] > 0 )
        location.text = locationString;
    else {
        location.text = @"Negotiable";
    }
    [[connectAccept titleLabel] setText:connectAcceptButtonText];
    
    
    [self.tabBarController.navigationItem setHidesBackButton:NO];
    [self.tabBarController.navigationItem setTitle:@"Tutor Information"];
}

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
	// Do any additional setup after loading the view.
    parseTransport = [[ParseTransport alloc] init];

    
    [connectButton addTarget:self action:@selector(connectRequest) forControlEvents:UIControlEventTouchUpInside];
    [reviewButton addTarget:self action:@selector(tutorReview) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewDidUnload
{
    subjectField = nil;
    tutorIDField = nil;
    [self setConnectButton:nil];
    [self setRatingImgView1:nil];
    [self setRatingImgView2:nil];
    [self setRatingImgView3:nil];
    [self setRatingImgView3:nil];
    [self setRatingImgView4:nil];
    [self setRatingImgView5:nil];
    [self setRatingImgView1:nil];
    [self setRatingImgView2:nil];
    [self setRatingImgView3:nil];
    [self setRatingImgView4:nil];
    [self setRatingImgView5:nil];
    [self setReviewButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
