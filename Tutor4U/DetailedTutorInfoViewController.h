//
//  DetailedTutorInfoViewController.h
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedTutorInfoViewController : UIViewController {
    IBOutlet UILabel* tutorID;
    IBOutlet UIButton* connectAccept;
    //IBOutlet UITableView* studentRequestTable;
    
    NSMutableArray *studentRequests;
}
@property (retain,nonatomic) IBOutlet NSString* tutorIDString;
@property (retain,nonatomic) IBOutlet NSString* connectAcceptButtonText;

@end
