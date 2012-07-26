//
//  NotificationQueue_Conversation.h
//  Tutor4U
//
//  Created by Andrew Kutta on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationQueue_Conversation : NSObject {
    NSMutableDictionary *messageArray;
}

+(NotificationQueue_Conversation*)sharedInstance;
-(void)addMessage:(NSDictionary*)message user:(NSString*)userName fromUser:(NSString*)fromUser;
-(NSArray*)getMessages:(NSString*)userName;
-(NSUInteger)count:(NSString*)userName;


@end
