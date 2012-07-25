//
//  NotificationQueue.h
//  Tutor4U
//
//  Created by Andrew Kutta on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationQueue : NSObject {
    NSMutableArray *messageArray;
}

+(NotificationQueue*)sharedInstance;
-(void)addMessage:(NSDictionary*)message;
-(NSDictionary*)popMessage;
-(NSUInteger)count;

@end
