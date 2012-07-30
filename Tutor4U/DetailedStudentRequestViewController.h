//
//  DetailedStudentRequestViewController.h
//  Tutor4U
//
//  Created by Andrew Kutta on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedStudentRequestViewController : UIViewController 
        <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate> {
    NSMutableArray          *messages;
    IBOutlet UITableView    *myTableView;
    IBOutlet UITextField    *messageField;
    IBOutlet UIButton       *sendButton;
    IBOutlet UIView         *plateView;
}

@property (retain,nonatomic) NSString* studentName;
@property (retain,nonatomic) NSString* fromType;

-(IBAction)sendMessage;

@end
