//
//  FindTutorViewController.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FindTutorViewController.h"
#import "DetailedTutorInfoViewController.h"
#import "ParseLoginViewController.h"

@interface FindTutorViewController ()

@end

@implementation FindTutorViewController


@synthesize parseTransport;
@synthesize addSessionButton;
@synthesize myTutorSession;


- (IBAction)tutorStateChanged:(id)sender {
    UISegmentedControl* control = (UISegmentedControl*)sender;
    if ( control.selectedSegmentIndex == 0 ) {
        NSLog(@"Attempting to Drop Tutor");
        [parseTransport dropTutor];
    } else {
        //        myTutorSession
        AddTutorSession *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"myTutorSession"];
//        [self.navigationController pushViewController:nextView animated:YES];
        [self.tabBarController.navigationController pushViewController:nextView animated:YES];
    }
    
    NSDictionary* objectToRemove = nil;
    for ( NSDictionary *tutor in availableTutors ) {
        //if ( [[tutor objectForKey:@"Tutor4uID"] compare:[PFUser currentUser].username options:] != NSNotFound ) {
        if ( [((NSString*)[tutor objectForKey:@"Tutor4uID"]) caseInsensitiveCompare:[PFUser currentUser].username] == NSOrderedSame ) {
            objectToRemove = tutor;
        }
    }
    
    if ( objectToRemove )
        [availableTutors removeObject:objectToRemove];
    [myTableView reloadData];
}


-(void)refreshData {
    availableTutors = (NSMutableArray *)[parseTransport downloadTutors];
    if ( [subjectFilter.text length] > 0 ) {
        for ( PFObject* tutor in [[availableTutors copy] reverseObjectEnumerator] ) {
            NSString *_subject = [tutor objectForKey:@"Subject"];
            if ( [[_subject lowercaseString] rangeOfString:filterSubject].location == NSNotFound ) {
                NSLog(@"Removing Tutor:  %@\t%@",_subject,filterSubject);
                [availableTutors removeObjectIdenticalTo:tutor];
            }
        }
    }
    [myTableView reloadData];
}

-(void)subscribeOnlyTo:(NSString*)newChannel {

    newChannel = [newChannel lowercaseString];
    NSLog(@"subscribeOnlyTo");
    if ( ![newChannel compare:currentChannel] && currentChannel != nil ) {
        NSLog(@"Already Subscribed");
        return;
    } else {
        if ( currentChannel != nil ) {
            NSLog(@"Unsubcribing from %@",currentChannel);
            currentChannel = @"";
            [PFPush unsubscribeFromChannelInBackground:currentChannel];
        }
        if ( [newChannel length] > 0 ) {
            currentChannel = newChannel;
            NSLog(@"Subscribing to %@",newChannel);
            [PFPush subscribeToChannelInBackground:newChannel];
        }
    }
}

-(void)doneSearching {
    filterSubject = subjectFilter.text;
    [self subscribeOnlyTo:filterSubject];
    [subjectFilter resignFirstResponder];
}

-(void)logout {
    [PFUser logOut];
    [ParseTransport pushChannelManagement];
    
    [ParseLoginViewController setViewControllerInForeground:NO];
//    [self.navigationController popViewControllerAnimated:NO];
    [self.tabBarController.navigationController popViewControllerAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    subjectFilter.delegate = self;
    availableTutors = (NSMutableArray *)[parseTransport downloadTutors];
    [myTableView reloadData];    // Allows all table view items to be updated to current items
    NSLog(@"FindTutorTabBar : Found [ %i ] Active Tutors", availableTutors.count);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshData" object:nil];
    
    
    // Used to Hide Keyboard
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doneSearching)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [myTableView addGestureRecognizer:gestureRecognizer];
    //[self.tableView addGestureRecognizer:gestureRecognizer];
    
    // Add Logout Button
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" 
                                                                                               style:UIBarButtonItemStyleDone
                                                                                              target:self 
                                                                                              action:@selector(logout)];
    // Hide Back Button
    [self.tabBarController.navigationItem setHidesBackButton:YES];
    [self.tabBarController.navigationItem setTitle:@"Find Tutor"];
    
    
    if ( [parseTransport downloadTutor:[PFUser currentUser].username] ) {
        activeState.selectedSegmentIndex = 1;
    } else {
        activeState.selectedSegmentIndex = 0;
    }
}

-(void)createSession
{
    [self.tabBarController.navigationController pushViewController:myTutorSession animated:YES];
//    [self.navigationController pushViewController:myTutorSession animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self refreshData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                           target:self
                                                                                           action:@selector(doneSearching)];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [subjectFilter resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    parseTransport = [[ParseTransport alloc] init];
    myTutorSession = [self.storyboard instantiateViewControllerWithIdentifier:@"myTutorSession"];
    
//    addSessionButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Sesson" style:UIBarButtonItemStylePlain target:self action:@selector(createSession)];  
//    self.navigationController.topViewController.navigationItem.rightBarButtonItem = addSessionButton;
//    [self.navigationController.topViewController setTitle:@"ActiveTutors"]; 
}

- (void)viewDidUnload
{
    subjectFilter = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [availableTutors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TutorInformationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TutorInformationCell"];
    }
    
    // Configure the cell...
    NSDictionary* tutor = [availableTutors objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[tutor objectForKey:@"Tutor4uID"]];
    [[cell detailTextLabel] setText:[tutor objectForKey:@"Subject"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailedTutorInfoViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailedTutorInfo"];
    if(availableTutors.count > 0) {
//        NSLog(@"FindTutorTable : row [ %i ] of [ %i ] - %@",indexPath.row, availableTutors.count, [availableTutors objectAtIndex:indexPath.row]);
    }
    //[nextView setTutorIDString:[availableTutors objectAtIndex:indexPath.row]];
    PFObject *myPfObject = [availableTutors objectAtIndex:indexPath.row];
    NSString *_tutor_id = [myPfObject objectForKey:@"Tutor4uID"];
    NSString *_subject = [myPfObject objectForKey:@"Subject"];
    [nextView setTutorIDString:_tutor_id];
    [nextView setSubjectString:_subject];
    if ( [myPfObject objectForKey:@"HourlyRate"] != [NSNull null] )
        [nextView setHourlyRateString:[myPfObject objectForKey:@"HourlyRate"]];
    
    if ( [myPfObject objectForKey:@"Location"] != [NSNull null] ) 
        [nextView setLocationString:[myPfObject objectForKey:@"Location"]];
    
//    NSLog(@" Tutor4uID [ %@ ] - Subject[ %@ ]",_tutor_id,_subject);
    [nextView setConnectAcceptButtonText:@"Connect"];
//    [self.navigationController pushViewController:nextView animated:YES];
    [self.tabBarController.navigationController pushViewController:nextView animated:YES];
    
//    NSLog(@"FindTutorTable : row [ %i ] of [ %i ] - %@",indexPath.row, availableTutors.count, [[availableTutors objectAtIndex:indexPath.row] objectForKey:@"Tutor4uID"]);
    
}

@end
