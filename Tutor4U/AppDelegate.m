//
//  AppDelegate.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "NotificationQueue.h"
#import "NotificationQueue_Conversation.h"
#import "ParseTransport.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"rjO7gBUIiH3uBhPbjwMcBQcRMJdlKZY791waH8I5"
                  clientKey:@"05OlySxlGXm3GEZhUrmprz970fb9MoIFoQmmeqho"];
    
    // Set defualt ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound];
    
    if ( [PFUser currentUser] ) {
        [[NotificationQueue_Conversation sharedInstance] loadFromDisk];
    }
    
    NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ( notification ) {
        if ( [notification objectForKey:@"curUser"] != nil ) {
        }
        NSLog(@"We have a Push Notification!!");
        //[[NotificationQueue sharedInstance] addMessage:notification];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    // Tell Parse about the device token.
    [PFPush storeDeviceToken:newDeviceToken];
    // Subscribe to the global broadcast channel.
    //   No global channel.  We want specific channels
    
    [ParseTransport pushChannelManagement];
    //[PFPush subscribeToChannelInBackground:@""];
}
		
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Push Notification Recieved"); 
    if ( [userInfo objectForKey:@"studentUser"] != nil ) {
        NSLog(@"Found a studentUser");
        //
        [[NotificationQueue sharedInstance] addMessage:userInfo];
        //
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStudentRequests" object:nil userInfo:userInfo];
    } else {
        if ( [userInfo objectForKey:@"message"] != nil ) {
            NSLog(@"Message To %@ Request/Response",[userInfo objectForKey:@"fromType"]);
            [[NotificationQueue_Conversation sharedInstance] addMessage:[NSMutableDictionary dictionaryWithDictionary:userInfo]
                                                                   user:[userInfo objectForKey:@"userName"] 
                                                               fromUser:[userInfo objectForKey:@"userName"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshConversation" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshResponses" object:nil];
//            [[NotificationQueue_Conversation sharedInstance] saveToDisk];
        } else if ( [userInfo objectForKey:@"hourlyRate"] != nil ) {
            NSLog(@"New Tutor Found Matching Your Filter");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil];
        } else {
            handshakeProtocol currentHandshake = (handshakeProtocol)[[userInfo objectForKey:@"handShake"] intValue];
            NSString *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            NSLog(@"Handshake Notification");
            studentName = [userInfo objectForKey:@"userName"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Meeting Request" 
                                               message:msg 
                                              delegate:self 
                                     cancelButtonTitle:@"Reject" 
                                     otherButtonTitles:@"Accept", nil];
            if ( currentHandshake == HANDSHAKE_CONNECT_STAGE ) {
                // Initial Handshake
                NSLog(@"HANDSHAKE_CONNECT");
                currentStage = HANDSHAKE_CONNECT_STAGE;
            } else if ( currentHandshake == HANDSHAKE_RESPONSE_CONFIRM ) {
                // Accept
                NSLog(@"HANDSHAKE_CONFIRM");
//                [alert setTitle:@"Meeting Response"];
                currentStage = HANDSHAKE_RESPONSE_CONFIRM;
                alert = [[UIAlertView alloc] initWithTitle:@"Meeting Response" 
                                                   message:@"Meeting has been confirmed" 
                                                  delegate:self 
                                         cancelButtonTitle:@"OK" 
                                         otherButtonTitles:nil];
            } else if ( currentHandshake == HANDSHAKE_REJECT ) {
                // Reject
                NSLog(@"HANDSHAKE_REJECT");
                currentStage = HANDSHAKE_REJECT;
                
                alert = [[UIAlertView alloc] initWithTitle:@"Meeting Response" 
                                                   message:msg 
                                                  delegate:self 
                                         cancelButtonTitle:@"OK" 
                                         otherButtonTitles:nil];
                
            } else if ( currentHandshake == HANDSHAKE_FINISHED ) {
                NSLog(@"HANDSHAKE_FINISHED");
                currentStage = HANDSHAKE_FINISHED;
                alert = [[UIAlertView alloc] initWithTitle:@"Meeting Response" 
                                                  message:@"Meeting has been confirmed" 
                                                 delegate:self 
                                        cancelButtonTitle:@"OK" 
                                        otherButtonTitles:nil];

            }
            [alert show];
            //[PFPush handlePush:userInfo];
        }
    }
    //[PFPush handlePush:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if ([error code] == 3010) {
        NSLog(@"Push notifications don't work in the simulator!");
    } else {
        NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NotificationQueue_Conversation sharedInstance] saveToDisk];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil];
//    if ( [PFUser currentUser] )
//        [[NotificationQueue_Conversation sharedInstance] loadFromDisk];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveEventually];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ( currentStage == HANDSHAKE_REJECT || currentStage == HANDSHAKE_FINISHED || currentStage == HANDSHAKE_RESPONSE_CONFIRM ) {
        return;
    }
    
    NSLog(@"Selected %@\t%i",[alertView buttonTitleAtIndex:buttonIndex],buttonIndex);
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 [PFUser currentUser].username, @"userName",
                                 nil];
    
    
    if ( buttonIndex == 0 ) {
        // Reject
        [data setObject:[[NSNumber alloc] initWithInt:HANDSHAKE_REJECT] forKey:@"handShake"];
        [data setObject:[NSString stringWithFormat:@"%@ has declined your meeting request",[PFUser currentUser].username] forKey:@"alert"];
    } else {
        // Accept
        if ( currentStage == HANDSHAKE_RESPONSE_CONFIRM ) {
            [data setObject:[[NSNumber alloc] initWithInt:HANDSHAKE_FINISHED] forKey:@"handShake"];
        } else {
            [data setObject:[[NSNumber alloc] initWithInt:HANDSHAKE_RESPONSE_CONFIRM] forKey:@"handShake"];
        }
        [data setObject:[NSString stringWithFormat:@"%@ has accepted to meet",[PFUser currentUser].username] forKey:@"alert"];
    }
    
    PFPush *push = [[PFPush alloc] init];
    
    //NSMutableArray *channels = [NSMutableArray arrayWithArray:[subject.text componentsSeparatedByString:@","]];
    [push setChannels:[[NSArray alloc] initWithObjects:studentName, nil]];
    [push setPushToAndroid:false];
    [push expireAfterTimeInterval:86400];
    [push setData:data];
    [push sendPushInBackground];
}

@end

