//
//  TutorControlViewController.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorControlViewController.h"
#import "DetailedTutorInfoViewController.h"

@interface TutorControlViewController ()

@end

@implementation TutorControlViewController

-(void)viewWillAppear:(BOOL)animated {
    
    studentRequests = [[NSMutableArray alloc] initWithCapacity:5];
    [studentRequests addObject:@"Student Request 1"];
    [studentRequests addObject:@"Student Request 2"];
    [studentRequests addObject:@"Student Request 3"];
    [studentRequests addObject:@"Student Request 4"];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [studentRequests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"StudentRequestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StudentRequestCell"];
    }
    // Configure the cell...
    [[cell textLabel] setText:[studentRequests objectAtIndex:indexPath.row]];
    
    return cell;
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailedTutorInfoViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailedTutorInfo"];
    
    [nextView setTutorIDString:[studentRequests objectAtIndex:indexPath.row]];
    [nextView setConnectAcceptButtonText:@"Accept"];
    [self.navigationController pushViewController:nextView animated:YES];
}

@end
