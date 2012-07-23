//
//  FindTutorViewController.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FindTutorViewController.h"
#import "DetailedTutorInfoViewController.h"

@interface FindTutorViewController ()

@end

@implementation FindTutorViewController


@synthesize parseTransport;
@synthesize addSessionButton;
@synthesize myTutorSession;




- (void)viewWillAppear:(BOOL)animated {
    availableTutors = [[NSMutableArray alloc] init];
    [availableTutors addObject:@"Tutor 1"];
    [availableTutors addObject:@"Tutor 2"];
    [availableTutors addObject:@"Tutor 3"];
    [availableTutors addObject:@"Tutor 4"];
    
    //---
    [availableTutors removeAllObjects];
    //PFObject *currentTutors = [parseTransport downloadTutor:@"zeddy.chirombe@gmail.com"];
    //NSLog(@"Showing Tutor[ %@ ] ",[currentTutors objectForKey:@"Tutor4uID"]);
    availableTutors = (NSMutableArray *)[parseTransport downloadTutors];
    
    /*
    for(int i=0; i < availableTutors.count; i++) {
        PFObject *pfObj = [availableTutors objectAtIndex:i];
        NSString *my_tutor_id = [pfObj objectForKey:@"Tutor4uID"];
        NSLog(@"Showing Tutor[ %i ] %@ ",i,my_tutor_id);
    }
    */
    NSLog(@"FindTutorTabBar : Found [ %i ] Active Tutors", availableTutors.count);
}
-(void)createSession
{
    NSLog(@"Add Session ");
    [self.navigationController pushViewController:myTutorSession animated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    parseTransport = [[ParseTransport alloc] init];
    myTutorSession = [self.storyboard instantiateViewControllerWithIdentifier:@"myTutorSession"];
    
    addSessionButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Sesson" style:UIBarButtonItemStylePlain target:self action:@selector(createSession)];  
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = addSessionButton;
    [self.navigationController.topViewController setTitle:@"ActiveTutors"]; 

     
    NSLog(@"FindTutorViewController - viewDidLoad() ---");
    
}

- (void)viewDidUnload
{
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TutorInformationCell"];
    }
    // Configure the cell...
    [[cell textLabel] setText:[[availableTutors objectAtIndex:indexPath.row] objectForKey:@"Tutor4uID"]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    DetailedTutorInfoViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailedTutorInfo"];
    if(availableTutors.count > 0) {
        NSLog(@"FindTutorTable : row [ %i ] of [ %i ] - %@",indexPath.row, availableTutors.count, [availableTutors objectAtIndex:indexPath.row]);
    }
    //[nextView setTutorIDString:[availableTutors objectAtIndex:indexPath.row]];
    PFObject *myPfObject = [availableTutors objectAtIndex:indexPath.row];
    NSString *_tutor_id = [myPfObject objectForKey:@"Tutor4uID"];
    NSString *_subject = [myPfObject objectForKey:@"Subject"];
    [nextView setTutorIDString:_tutor_id];
    [nextView setSubjectString:_subject];
    
    NSLog(@" Tutor4uID [ %@ ] - Subject[ %@ ]",_tutor_id,_subject);
    [nextView setConnectAcceptButtonText:@"Connect"];
    [self.navigationController pushViewController:nextView animated:YES];
    
    NSLog(@"FindTutorTable : row [ %i ] of [ %i ] - %@",indexPath.row, availableTutors.count, [[availableTutors objectAtIndex:indexPath.row] objectForKey:@"Tutor4uID"]);
    
}

@end
