//
//  TutorControlViewController.h
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ParseTransport.h"

@interface TutorControlViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *studentRequests;
    ParseTransport *parseTransport;
    IBOutlet UITableView* myTableView;
}
@end
