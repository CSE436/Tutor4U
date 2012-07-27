//
//  TutorControlViewController.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorControlViewController.h"
#import "DetailedStudentRequestViewController.h"
#import "AddTutorSession.h"
#import "NotificationQueue.h"

@interface TutorControlViewController ()

@end

@implementation TutorControlViewController

@synthesize mapView;

-(void)refreshData {
//    studentRequests = (NSMutableArray *)[parseTransport downloadTutors];
    [myTableView reloadData];
}

-(void)refreshStudentRequestsFromQueue {
    NotificationQueue *queue = [NotificationQueue sharedInstance];
    NSLog(@"refreshStudentRequestsFromQueue");
    while ( [queue count] > 0 ) {
        
        NSDictionary* message = [queue popMessage];
        for ( NSString* key in message ) {
            NSLog(@"%@:\t%@",key, [message objectForKey:key]);
        }
        [self handleNotification:message];
    }
}

-(void)handleNotification:(NSDictionary*)newNotification {
    NSString *studentUsername = [newNotification objectForKey:@"studentUser"];
    NSLog(@"handleNotification:\t%@",studentUsername);
    if ( [studentUsername length] > 0 ) {
        if ( ![studentRequests containsObject:studentUsername] ) {
            NSLog(@"studentRequests doesn't Contain %@",studentUsername);
            [studentRequests addObject:studentUsername];
            NSLog(@"%i",[studentRequests count]);
        } else {
            NSLog(@"studentRequests Contains %@",studentUsername);
        }
    }
    NSLog(@"Reloading Tableview Data");
    [myTableView reloadData];
}

-(void)refreshStudentRequests:(NSNotification*)notification {
    NSDictionary *newNotification = [notification userInfo];
    NSLog(@"Push Notification");
    [self handleNotification:newNotification];
}

-(void)viewWillAppear:(BOOL)animated {
    if ( [parseTransport downloadTutor:[PFUser currentUser].username] ) {
        activeState.selectedSegmentIndex = 1;
    } else {
        activeState.selectedSegmentIndex = 0;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStudentRequests:) name:@"refreshStudentRequests" object:nil];
    
    //if ( [defaults objectForKey:@"unrespondedToRequests"] )
    studentRequests = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"unrespondedToRequests"]];
    
    if ( [[NotificationQueue sharedInstance] count] > 0 ) {
        NSLog(@"refreshStudentRequestFroMQueue to Come");
        [self refreshStudentRequestsFromQueue];
    }
    
    if ( [studentRequests count] > 0 )
        [defaults setObject:studentRequests forKey:@"unrespondedToRequests"];
    
    [self.tabBarController.navigationItem setTitle:@"Messaging Center"];
    //Just high the join button if you are not on availableTutors screen - 
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
    parseTransport = [[ParseTransport alloc] init];
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
    NSLog(@"Student Requests: %i",[studentRequests count]);
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
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    DetailedStudentRequestViewController *nextView = [self.storyboard 
                                                      instantiateViewControllerWithIdentifier:@"DetailedStudentRequestInfo"];
//    DetailedTutorInfoViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailedTutorInfo"];
    [nextView setStudentName:cell.textLabel.text];
    [self.navigationController pushViewController:nextView animated:YES];
}

@end
