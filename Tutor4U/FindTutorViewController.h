//
//  FindTutorViewController.h
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseTransport.h"
#import "AddTutorSession.h"

@interface FindTutorViewController : UITableViewController <UISearchBarDelegate> {
    NSMutableArray *availableTutors;
    BOOL outstandingSession;
}

@property (strong, atomic) IBOutlet ParseTransport *parseTransport;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addSessionButton;
@property (strong, nonatomic) IBOutlet AddTutorSession *myTutorSession;


-(void)createSession;

@end
