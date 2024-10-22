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

@interface FindTutorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    NSMutableArray *availableTutors;
    BOOL outstandingSession;
    IBOutlet UITableView* myTableView;
    IBOutlet UISearchBar *subjectFilter;
    
    IBOutlet UISegmentedControl* activeState;
    
    NSString *filterSubject;
    NSString *currentChannel;
}

@property (strong, atomic) ParseTransport *parseTransport;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addSessionButton;
@property (strong, nonatomic) IBOutlet AddTutorSession *myTutorSession;


-(void)createSession;

@end
