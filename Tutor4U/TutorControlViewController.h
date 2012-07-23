//
//  TutorControlViewController.h
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TutorControlViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate> {
    NSMutableArray *studentRequests;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
