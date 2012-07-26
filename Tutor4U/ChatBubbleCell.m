//
//  ChatBubbleCell.m
//  Tutor4U
//
//  Created by Andrew Kutta on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChatBubbleCell.h"

@implementation ChatBubbleCell

//-(void)setMessage:(NSString*)newMessage msgType:(MessageType)messageType; {
//    message = newMessage;
//    [cellView setMessage:newMessage msgType:messageType];
//}

-(void)setMessage:(NSDictionary *)newMessage {
    message = newMessage;
    [cellView setMessage:newMessage];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        cellView = [[ChatBubbleView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:cellView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    cellView.frame = self.bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)calcCellHeight:(NSDictionary*)msg diff:(int)diff
{
    // Calculate text bounds and cell height here
    //
    CGRect bounds;
    
    bounds = CGRectMake(0, 0, CHAT_BUBBLE_TEXT_WIDTH, 200);
    static UILabel *label = nil;
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:14];
    }
    
    label.text = [msg objectForKey:@"message"];
    CGRect bubbleRect = [label textRectForBounds:bounds limitedToNumberOfLines:10];
    CGFloat ret = bubbleRect.size.height + 5 + 5 + 5; // bubble height
    
    [msg setValue:[NSValue valueWithCGRect:bubbleRect] forKey:@"bubbleRect"];
//    
//    if (diff > CHAT_BUBBLE_TIMESTAMP_DIFF) {
//        needTimestamp = YES;
//        ret += 26;
//    }
//    else {
//        needTimestamp = NO;
//        ret += 5;
//    }
    
    return ret;
}


@end
