//
//  ChatBubbleView.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChatBubbleView.h"

@implementation ChatBubbleView

//-(void)setMessage:(NSString*)newMessage msgType:(MessageType)messageType {
//    message = newMessage;
//    msgType = messageType;
//    [self setNeedsDisplay]; 
//}

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

/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    
    //
    // Draw chat bubble
    //
    UIImage *bubble;
    int height = self.bounds.size.height - 5;
    //if (message.needTimestamp) height -= 21;
    CGRect bubbleRect = CGRectMake(0, 0, bubbleRect.size.width, height);
    
    int width = bubbleRect.size.width + 30;
    width = (width / 10) * 10 + ((width % 10) ? 10 : 0);
    bubbleRect.size.width = width;
    bubbleRect.origin.y = 4 + top;
    
    if (type == BUBBLE_TYPE_GRAY) {
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
    bubbleRect.size.width = message.bubbleRect.size.width;
    if (type == BUBBLE_TYPE_GRAY) {
        bubbleRect.origin.x += 20;
    }
    else {
        bubbleRect.origin.x += 10;
    }
    [message.text drawInRect:bubbleRect withFont:[UIFont systemFontOfSize:14]];
    

}

*/
@end
