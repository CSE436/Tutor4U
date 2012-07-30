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
#import "NotificationQueue_Conversation.h"
#import "MessageCenterCell.h"


@interface TutorControlViewController ()

@end

@implementation TutorControlViewController

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

-(void)refreshTutorResponsesFromQueue {
    NotificationQueue_Conversation *queue = [NotificationQueue_Conversation sharedInstance];
    NSLog(@"refreshTutorResponsesFromQueue");
    tutorResponses = [queue getUsernames];
    
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

-(void)refreshTutorResponses:(NSNotification*)notification {
    [self refreshTutorResponsesFromQueue];
}

-(void)rateTutor:(NSNotification*)notification {
    NSDictionary *newNotification = [notification userInfo];
    NSString* tutorName = [newNotification objectForKey:@"tutorName"];
    
    TutorRatingViewController *myRating = [self.storyboard instantiateViewControllerWithIdentifier:@"myTutorRating"];
    [myRating setUserNameString:tutorName];
    [self.navigationController popToViewController:self.tabBarController animated:NO];
    [self.navigationController pushViewController:myRating animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {

    [myTableView deselectRowAtIndexPath:myTableView.indexPathForSelectedRow animated:NO];
    
    parseTransport = [[ParseTransport alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStudentRequests:) name:@"refreshStudentRequests" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTutorResponses:) name:@"refreshTutorResponses" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rateTutor:) name:@"RateTutor" object:nil];
    
    
    studentRequests = [[NSMutableArray alloc] 
                       initWithArray:[defaults 
                                      objectForKey:[[NSString alloc] 
                                                    initWithFormat:@"unrespondedToRequests_%@",[PFUser currentUser].username]]];
    
    if ( [[NotificationQueue sharedInstance] count] > 0 ) {
        NSLog(@"refreshStudentRequestFroMQueue to Come");
        [self refreshStudentRequestsFromQueue];
    }
    
    if ( [studentRequests count] > 0 )
        [defaults setObject:studentRequests forKey:[[NSString alloc] initWithFormat:@"unrespondedToRequests_%@",[PFUser currentUser].username]];
    
    [self.tabBarController.navigationItem setTitle:@"Message Center"];
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
    return 2;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ( section == 0 ) {
        return @"Tutor Responses";
    }
    return @"Student Requests";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( section == 0 ) {
        return [tutorResponses count];
    }
    NSLog(@"Student Requests: %i",[studentRequests count]);
    return [studentRequests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"StudentRequestCell";
    MessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil ) {
        cell = [[MessageCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StudentRequestCell"];
    }
    // Configure the cell...
    if ( indexPath.section == 0 ) {
        [[cell textLabel] setText:[tutorResponses objectAtIndex:indexPath.row]];
        [cell setDisplayRate:NO];
    } else {
        [[cell textLabel] setText:[studentRequests objectAtIndex:indexPath.row]];
        [cell setDisplayRate:YES];
    }
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    DetailedStudentRequestViewController *nextView = [self.storyboard 
                                                      instantiateViewControllerWithIdentifier:@"DetailedStudentRequestInfo"];
    [nextView setStudentName:cell.textLabel.text];

    // Changes back button on next view
    NSLog(@"%@",self.navigationController.viewControllers);
    
    [self.tabBarController.navigationItem setTitle:@"Messages"];
    [self.navigationController pushViewController:nextView animated:YES];
}

@end
