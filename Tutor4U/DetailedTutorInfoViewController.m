//
//  DetailedTutorInfoViewController.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailedTutorInfoViewController.h"

@interface DetailedTutorInfoViewController ()

@end

@implementation DetailedTutorInfoViewController

@synthesize tutorIDString, connectAcceptButtonText;


-(void)viewWillAppear:(BOOL)animated {
    [tutorID setText:tutorIDString];
    [[connectAccept titleLabel] setText:connectAcceptButtonText];
    
    //studentRequestTable.delegate = self;
    //studentRequestTable.dataSource = self;
    

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
