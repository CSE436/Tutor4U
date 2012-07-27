//
//  NotificationQueue_Conversation.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationQueue_Conversation.h"
#import "ParseTransport.h"

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
    if ( ![userArray containsObject:userName] )
        [userArray addObject:userName];
  
    NSMutableArray *messagesFromUser = [[NSMutableArray alloc] initWithArray:[messageArray objectForKey:userName]];
    [messagesFromUser addObject:message];
    [messageArray removeObjectForKey:userName];
    [messageArray setObject:messagesFromUser forKey:userName];
    [self saveToDisk];
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

-(NSString*)getDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [[NSString alloc] initWithFormat:@"Conversations_%@.plist",[PFUser currentUser].username];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    
   // NSLog(@"%@",documentsDirectory);
    return path;
}

-(void)saveToDisk {
    NSDictionary *toDisk = [[NSDictionary alloc] initWithDictionary:messageArray];
    
    if ( [NSKeyedArchiver archiveRootObject:toDisk toFile:[self getDocumentsDirectory]] ) {
        NSLog(@"Successfully Saved");
    } else {
        NSLog(@"Failed to Save");
    }
//    
//    NSLog(@"%@", [toDisk description]); // This Shows Up Fine
//    [[toDisk description] writeToFile:[documentsDirectory stringByAppendingPathComponent:@"Test.xml"] atomically:YES]; // This saves fine
//    
//    if ( [toDisk writeToFile:[self getDocumentsDirectory] atomically:YES] ) {
//        NSLog(@"Successfully Saved");
//    } else {
//        NSLog(@"Failed to Save");
//    }
}

-(void)loadFromDisk {
    NSLog(@"loadFromDisk");
    
    messageArray = [NSKeyedUnarchiver unarchiveObjectWithFile: [self getDocumentsDirectory]];
    messageArray = [[NSMutableDictionary alloc] initWithDictionary:messageArray];
//    NSDictionary* fromDisk = [[NSDictionary alloc] initWithContentsOfFile:[self getDocumentsDirectory]];
//    messageArray  = [[NSMutableDictionary alloc] initWithDictionary:fromDisk];
//    
//    for ( NSString *key in messageArray ) {
//        NSLog(@"%@",[messageArray objectForKey:key]);
//    }
//    
//    if ( !messageArray ) {
//        NSLog(@"Nothing Loaded");
//        messageArray = [[NSMutableDictionary alloc] init];
//    }
}

@end
