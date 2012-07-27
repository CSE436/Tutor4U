//
//  NotificationQueue_Conversation.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationQueue_Conversation.h"

@implementation NotificationQueue_Conversation

static NotificationQueue_Conversation* sharedInstance = nil;


+(NotificationQueue_Conversation*)sharedInstance {
    if ( sharedInstance )
        return sharedInstance;
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}


-(id)init {
    self = [super init];
    messageArray = [[NSMutableDictionary alloc] init];
    return self;
}

-(void)addMessage:(NSDictionary*)message user:(NSString*)userName fromUser:(NSString*)fromUser {
    
}

-(NSArray*)getMessages:(NSString*)userName {
    return [messageArray objectForKey:userName];
}

-(NSUInteger)count:(NSString*)userName {
    return [((NSArray*)[messageArray objectForKey:userName]) count];
}

-(NSArray*)getUsernames {
    return userArray;
}

-(NSUInteger)count {
    return [userArray count];
}

@end
