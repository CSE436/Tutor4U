//
//  ChatBubbleView.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChatBubbleView.h"

@implementation ChatBubbleView

static UIImage* sGreenBubble = nil;
static UIImage* sGrayBubble = nil;

-(void)setMessage:(NSDictionary*)newMessage {
    message = newMessage;
    msgType = (MessageType)[[message objectForKey:@"messageType"] intValue];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.859 green:0.886 blue:0.929 alpha:1.0];
    }
    return self;
}

#define IMAGE_SIZE 32
#define IMAGE_H_PADDING 8

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    float top = 0;
//    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGRect msgBubbleRect = [[message objectForKey:@"bubbleRect"] CGRectValue];
    //
    // Draw chat bubble
    //
    UIImage *bubble;
    int height = self.bounds.size.height - 5;
    //if (message.needTimestamp) height -= 21;
    CGRect bubbleRect = CGRectMake(0, 0, msgBubbleRect.size.width, height);
    
    int width = bubbleRect.size.width + 30;
    width = (width / 10) * 10 + ((width % 10) ? 10 : 0);
    bubbleRect.size.width = width;
    bubbleRect.origin.y = 4 + top;
    
    if (msgType == MESSAGE_RECIEVE) {
        bubble = [ChatBubbleView grayBubble];
        bubbleRect.origin.x = IMAGE_SIZE + IMAGE_H_PADDING;
    }
    else {
        bubble = [ChatBubbleView greenBubble];
        bubbleRect.origin.x = 320 - bubbleRect.size.width - IMAGE_SIZE - IMAGE_H_PADDING;
    }
    [bubble drawInRect:bubbleRect];
    
    //
    // Draw message text
    //
    [[UIColor blackColor] set];
    bubbleRect.origin.y += 6;
    bubbleRect.size.width = msgBubbleRect.size.width;
    if (msgType == MESSAGE_RECIEVE) {
        bubbleRect.origin.x += 20;
    } else {
        bubbleRect.origin.x += 10;
    }
    [(NSString*)[message objectForKey:@"message"] drawInRect:bubbleRect withFont:[UIFont systemFontOfSize:14]];
}


+ (UIImage*)greenBubble
{
    if (sGreenBubble == nil) {
        UIImage *i = [UIImage imageNamed:@"Balloon_1.png"];
        sGreenBubble = [i stretchableImageWithLeftCapWidth:15 topCapHeight:13];
    }
    return sGreenBubble;
}

+ (UIImage*)grayBubble
{
    if (sGrayBubble == nil) {
        UIImage *i = [UIImage imageNamed:@"Balloon_2.png"];
        sGrayBubble = [i stretchableImageWithLeftCapWidth:21 topCapHeight:13];
    }
    return sGrayBubble;
}
@end
