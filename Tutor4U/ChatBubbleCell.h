//
//  ChatBubbleCell.h
//  Tutor4U
//
//  Created by Andrew Kutta on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatBubbleView.h"

#define CHAT_BUBBLE_WIDTH           (320 - 32 - 8 - 20 - 20)
#define CHAT_BUBBLE_TEXT_WIDTH      (CHAT_BUBBLE_WIDTH - 30)
#define CHAT_BUBBLE_TIMESTAMP_DIFF  (60 * 30)

@interface ChatBubbleCell : UITableViewCell {
    ChatBubbleView*     cellView;
//    NSString*           message;
    NSDictionary*       message;
    BOOL                needTimestamp;
    CGRect             bubbleRect;
}

//@property (retain, nonatomic) NSString* message;
//-(void)setMessage:(NSString*)newMessage msgType:(MessageType)messageType;
-(void)setMessage:(NSDictionary*)newMessage;
+ (CGFloat)calcCellHeight:(NSDictionary*)msg diff:(int)diff;


@end
