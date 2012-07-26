//
//  ChatBubbleView.h
//  Tutor4U
//
//  Created by Andrew Kutta on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  Method credit:  TwitterFon Source
//

#import <UIKit/UIKit.h>

typedef enum {
    MESSAGE_SEND,
    MESSAGE_RECIEVE
} MessageType;

@interface ChatBubbleView : UIView {
//    NSString *message;
    NSDictionary* message;
    MessageType msgType;
}

//@property (nonatomic,readonly) MessageType type;
//@property (nonatomic, retain, readonly) NSString* message;
//-(void)setMessage:(NSString*)newMessage msgType:(MessageType)messageType;
-(void)setMessage:(NSDictionary*)newMessage;

@end
