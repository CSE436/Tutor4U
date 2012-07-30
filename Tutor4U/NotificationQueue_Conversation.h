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
    NSMutableArray      *userArray_tutor, *userArray_student;
}

+(NotificationQueue_Conversation*)sharedInstance;
-(void)addMessage:(NSDictionary*)message user:(NSString*)userName fromUser:(NSString*)fromUser;
-(NSArray*)getMessages:(NSString*)userName;
-(NSUInteger)count:(NSString*)userName;

-(NSArray*)getUsernames_student;
-(NSArray*)getUsernames_tutor;
-(NSUInteger)count_tutor;
-(NSUInteger)count_student;

-(BOOL)hasUsername:(NSString*)username;

-(void)saveToDisk;
-(void)loadFromDisk;
@end
