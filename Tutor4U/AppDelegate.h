//
//  AppDelegate.h
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HANDSHAKE_CONNECT_STAGE,
    HANDSHAKE_RESPONSE_CONFIRM,
    HANDSHAKE_REJECT,
    HANDSHAKE_FINISHED
} handshakeProtocol;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate> {
    handshakeProtocol   currentStage;
    NSString            *studentName;
}

@property (strong, nonatomic) UIWindow *window;

@end
