//
//  UITextView+TextAttachmentUtils.m
//   
//
//  Created by tbin on 2018/11/20.
//  Copyright © 2018  bin. All rights reserved.
//

#import "UITextView+TextAttachmentUtils.h"
#import "NSTextStorage+Utils.h"

@implementation UITextView (TextAttachmentUtils)

#pragma mark - viewAttachments

- (NSArray<NSTextAttachment *> *)allAttachments{
    NSMutableArray<NSTextAttachment *> *attachments = (id)[NSMutableArray arrayWithCapacity:0];
    [self.textStorage enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.textStorage.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value != nil) {
            [attachments addObject:value];
        }
    }];
    return attachments;
}

- (NSArray<NSTextAttachment*> *)viewAttachments:(NSRange)inRange {
    
    NSMutableArray *atts = [NSMutableArray arrayWithCapacity:0];
    
    [self.textStorage enumerateAttribute:NSAttachmentAttributeName inRange:inRange options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if (value != nil && [value isKindOfClass:[NSTextAttachment class]]) {
            [atts addObject:value];
        }
        
    }];
    
    return atts;
}

- (NSTextAttachment *)attachmentAtPoint:(CGPoint)point{
    NSUInteger index = [self.layoutManager characterIndexForPoint:point inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:nil];
    
    if (!(index < self.textStorage.length)) {
        return nil;
    }
    
    NSRange effectiveRange;
    NSTextAttachment *attachment = [self.textStorage attribute:NSAttachmentAttributeName atIndex:index effectiveRange:&effectiveRange];
    if (!attachment) {
        return nil;
    }
    
    CGRect bounds = [self.layoutManager boundingRectForGlyphRange:effectiveRange inTextContainer:self.textContainer];
    bounds.origin.x += self.textContainerInset.left;
    bounds.origin.y += self.textContainerInset.top;
    
    return CGRectContainsPoint(bounds, point) ? attachment : nil;
}


- (void)insertAttachment:(NSTextAttachment *)attachment paragraphStyle:(NSMutableParagraphStyle*)style{
   NSAttributedString* insertion =  [NSTextStorage attributedStringForAttachment:attachment typingAttributes:self.typingAttributes];
    
   [self.textStorage insertAttributedString:insertion atIndex:self.selectedRange.location];
    
    /// 重置光标
    UITextPosition *end = [self positionFromPosition:self.selectedTextRange.start offset:3];
    self.selectedTextRange = [self textRangeFromPosition:end toPosition:end];
}

@end
