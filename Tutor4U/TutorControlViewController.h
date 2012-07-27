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

@interface TutorControlViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate> {
    NSMutableArray *studentRequests;
    ParseTransport *parseTransport;
    IBOutlet UITableView* myTableView;
    IBOutlet UISegmentedControl* activeState;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
