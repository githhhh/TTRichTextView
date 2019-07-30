//
//  NSLayoutManager+Attachment.m
//  RichText
//
//  Created by tbin on 2018/7/16.
//  Copyright © 2018年 me.test. All rights reserved.
//

#import "NSLayoutManager+Attachment.h"

@implementation NSLayoutManager (Attachment)

- (NSArray<NSValue *> *)rangesForAttachment:(NSTextAttachment *)attachment{
    
    if (self.textStorage == nil) {
        return nil;
    }
    
    NSRange inRange = NSMakeRange(0, self.textStorage.length);

    NSMutableArray<NSValue *> *rangs = (id)[NSMutableArray arrayWithCapacity:0];
    
    [self.textStorage enumerateAttribute:NSAttachmentAttributeName inRange:inRange options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if (value != nil && [value isKindOfClass:[NSTextAttachment class]] && attachment == value) {
            NSValue *rangeValue = [NSValue valueWithRange:range];
            [rangs addObject:rangeValue];
        }
        
    }];
    
    if (rangs.count == 0) {
        return nil;
    }
    
    return rangs;
}


/// Trigger a relayout for an attachment
-(void)setNeedsLayout:(NSTextAttachment *)attachment{
    
    NSArray<NSValue *> *rangs = [self rangesForAttachment:attachment];
    
    if (rangs == nil) {
        return;
    }
    
    for (NSValue *rangeValue in rangs) {
        NSRange range = [rangeValue rangeValue];
        [self invalidateLayoutForCharacterRange:range actualCharacterRange:nil];
        [self invalidateDisplayForCharacterRange:range];
    }
}

/// Trigger a re-display for an attachment
-(void)setNeedsDisplay:(NSTextAttachment *)attachment{
    NSArray<NSValue *> *rangs = [self rangesForAttachment:attachment];
    
    if (rangs == nil) {
        return;
    }
    // invalidate the display for the corresponding ranges
    for (NSValue *rangeValue in rangs) {
        NSRange range = [rangeValue rangeValue];
        [self invalidateDisplayForCharacterRange:range];
    }
}

@end
