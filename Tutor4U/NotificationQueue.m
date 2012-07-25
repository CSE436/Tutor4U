//
//  NotificationQueue.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationQueue.h"

@implementation NotificationQueue

static NotificationQueue* sharedInstance = nil;

+(NotificationQueue*)sharedInstance {
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
    messageArray = [[NSMutableArray alloc] init];
    return self;
}

+(id)allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

-(id)copyWithZone:(NSZone *)zone {
    return self;
}

-(void)addMessage:(NSDictionary*)message {
    NSLog(@"Adding Message");
    if ( !messageArray )
        messageArray = [[NSMutableArray alloc] init];
    
    [messageArray addObject:message];
}

-(NSDictionary*)popMessage {
    if ( !messageArray )
        messageArray = [[NSMutableArray alloc] init];
    NSDictionary* ret = [messageArray objectAtIndex:0];
    [messageArray removeObjectAtIndex:0];
    return ret;
}

-(NSUInteger)count {
    if ( !messageArray )
        messageArray = [[NSMutableArray alloc] init];
    return [messageArray count];
}

@end
