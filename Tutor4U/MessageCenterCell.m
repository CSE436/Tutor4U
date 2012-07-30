//
//  MessageCenterCell.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MessageCenterCell.h"

@implementation MessageCenterCell

@synthesize displayRate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)rateTutor {
    NSLog(@"Rate %@",self.textLabel.text);
    NSDictionary *tutorInfo = [[NSDictionary alloc] initWithObjectsAndKeys:self.textLabel.text, @"tutorName", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RateTutor" 
                                                        object:self
                                                      userInfo:tutorInfo];
    
    //TutorRatingViewController *myRating = [self.storyboard instantiateViewControllerWithIdentifier:@"myTutorRating"];
    //[(TutorRatingViewController*)nextView setUserNameString:self.textLabel.text];
    //[self.navigationController pushViewController:myRating animated:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIButton *buttonRate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonRate.backgroundColor = [UIColor clearColor];
    buttonRate.titleLabel.font = [UIFont systemFontOfSize:17];
    [buttonRate setTitle:@"Rate" forState:UIControlStateNormal];
    [buttonRate addTarget:self action:@selector(rateTutor) forControlEvents:UIControlEventTouchUpInside];
    
    buttonRate.hidden = !displayRate;
    
    CGSize fontSize = [buttonRate.titleLabel.text sizeWithFont:buttonRate.titleLabel.font];      
    CGRect buttonFrame = CGRectMake(5, 8, fontSize.width + 20.0, 30);
    [buttonRate setFrame:buttonFrame];
    [self addSubview:buttonRate];
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x = buttonFrame.origin.x + buttonFrame.size.width + 5;
    frame.size.width -= frame.origin.x;
    self.textLabel.frame = frame;
}


@end
