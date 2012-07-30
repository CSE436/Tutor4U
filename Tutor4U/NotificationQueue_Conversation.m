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
    userArray_tutor = [[NSMutableArray alloc] init];
    userArray_student = [[NSMutableArray alloc] init];
    return self;
}

-(BOOL)hasUsername:(NSString*)username {
    //NSLog(@"%@",[messageArray objectForKey:username]);
    if ( [[messageArray objectForKey:username] count] > 0 )
        return YES;
    return NO;
}

-(void)addMessage:(NSDictionary*)message user:(NSString*)userName fromUser:(NSString*)fromUser {
    
    if ( [(NSString*)[message objectForKey:@"fromType"] caseInsensitiveCompare:@"student"] == NSOrderedSame ) {
        if ( ![userArray_student containsObject:userName] ) {
            NSLog(@"Adding %@ to Students",userName);
            [userArray_student addObject:userName];
        }
    } else {
        if ( ![userArray_tutor containsObject:userName] ) {
            NSLog(@"Adding %@ to Tutors",userName);
            [userArray_tutor addObject:userName];
        }
    }
  
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

-(NSArray*)getUsernames_tutor {
    return userArray_tutor;
}

-(NSArray*)getUsernames_student {
    return userArray_student;    
}

-(NSUInteger)count_tutor {
    return [userArray_tutor count];
}

-(NSUInteger)count_student {
    return [userArray_student count];
}

-(NSString*)getDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

-(void)saveToDisk {
    NSDictionary *toDisk = [[NSDictionary alloc] initWithDictionary:messageArray];
    NSString* filePath = [self getDocumentsDirectory];
    if ( filePath ) {
        if ( [PFUser currentUser] ) {
            NSString* userName = [PFUser currentUser].username;
            NSString *fileName = [[NSString alloc] initWithFormat:@"Conversations_%@.plist",userName];
            
            if ( [NSKeyedArchiver archiveRootObject:toDisk toFile:[filePath stringByAppendingPathComponent:fileName]] ) {
                NSLog(@"Successfully Saved [Conversations]");
            } else {
                NSLog(@"Failed to Save [Conversations]");
            }

            fileName = [[NSString alloc] initWithFormat:@"userArray_tutor_%@.plist",userName];
            [userArray_tutor writeToFile:[filePath stringByAppendingPathComponent:fileName] atomically:YES];

            
            fileName = [[NSString alloc] initWithFormat:@"userArray_student_%@.plist",userName];
            [userArray_student writeToFile:[filePath stringByAppendingPathComponent:fileName] atomically:YES];
        }
    }
}


-(void)loadFromDisk {
    NSLog(@"loadFromDisk");
    NSString* filePath = [self getDocumentsDirectory];
    if ( filePath ) {
        if ( [PFUser currentUser] ) {
            NSString* userName = [PFUser currentUser].username;
            NSString *fileName = [[NSString alloc] initWithFormat:@"Conversations_%@.plist",userName];
            
            messageArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[filePath stringByAppendingPathComponent:fileName]];
            messageArray = [[NSMutableDictionary alloc] initWithDictionary:messageArray];
        
            fileName = [[NSString alloc] initWithFormat:@"userArray_tutor_%@.plist",userName];
            userArray_tutor = [[NSMutableArray alloc] initWithContentsOfFile:[filePath stringByAppendingPathComponent:fileName]];
            // nil can be returned from above.  this initializes the mutable array anyways
            userArray_tutor = [[NSMutableArray alloc] initWithArray:userArray_tutor];   
            
            fileName = [[NSString alloc] initWithFormat:@"userArray_student_%@.plist",userName];
            userArray_student = [[NSMutableArray alloc] initWithContentsOfFile:[filePath stringByAppendingPathComponent:fileName]];
            // nil can be returned from above.  this initializes the mutable array anyways
            userArray_student = [[NSMutableArray alloc] initWithArray:userArray_student];   
        }
    }
}

@end
