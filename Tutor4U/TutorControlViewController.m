//
//  TutorControlViewController.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorControlViewController.h"
#import "DetailedTutorInfoViewController.h"
#import "AddTutorSession.h"

@interface TutorControlViewController ()

@end

@implementation TutorControlViewController

@synthesize mapView;

-(void)refreshData {
//    studentRequests = (NSMutableArray *)[parseTransport downloadTutors];
    [myTableView reloadData];
}


-(void)viewWillAppear:(BOOL)animated {
    parseTransport = [[ParseTransport alloc] init];
    
    if ( [parseTransport downloadTutor:[PFUser currentUser].username] ) {
        activeState.selectedSegmentIndex = 1;
    } else {
        activeState.selectedSegmentIndex = 0;
    }
    
    studentRequests = [[NSMutableArray alloc] initWithCapacity:5];
    [studentRequests addObject:@"Student Request 1"];
    [studentRequests addObject:@"Student Request 2"];
    [studentRequests addObject:@"Student Request 3"];
    [studentRequests addObject:@"Student Request 4"];
}

- (IBAction)tutorStateChanged:(id)sender {
    UISegmentedControl* control = (UISegmentedControl*)sender;
    if ( control.selectedSegmentIndex == 0 ) {
        NSLog(@"Attempting to Drop Tutor");
        [parseTransport dropTutor];
    } else {
//        myTutorSession
        AddTutorSession *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"myTutorSession"];
        [self.navigationController pushViewController:nextView animated:YES];
    }
    //NSLog(@"state Changed: %@", control.selectedSegmentIndex);
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
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

-(IBAction)updateTutorProfile:(id)sender {
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DetailedTutorInfoViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailedTutorInfo"];
//    [nextView setTutorIDString:[studentRequests objectAtIndex:indexPath.row]];
//    [nextView setConnectAcceptButtonText:@"Accept"];
//    [self.navigationController pushViewController:nextView animated:YES];
}

@end
