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
        NSLog(@"Possibly a tutor message");
        if ( [[userInfo objectForKey:@"alert"] rangeOfString:@"New Tutor Available"].location != NSNotFound ) {
            NSLog(@"New Tutor Found Matching Your Filter");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil];
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

@end

