//
//  AttachmentLayoutManager.m
//   
//
//  Created by tbin on 2018/11/20.
//  Copyright © 2018  bin. All rights reserved.
//

#import "AttachmentLayoutManager.h"

@interface AttachmentLayoutManager ()

@end

@implementation AttachmentLayoutManager

- (void)drawGlyphsForGlyphRange:(NSRange)glyphsToShow atPoint:(CGPoint)origin{
    [super drawGlyphsForGlyphRange:glyphsToShow atPoint:origin];
    if (!self.attachmentsManager) {
        return;
    }
    [self.textStorage enumerateAttribute:NSAttachmentAttributeName inRange:glyphsToShow options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSTextAttachment* attachment, NSRange range, BOOL * _Nonnull stop) {
        if (!attachment) {
            return ;
        }
        NSUInteger glyphsIndex = [self glyphIndexForCharacterAtIndex:range.location];
        NSTextContainer *textContainer = [self textContainerForGlyphAtIndex:glyphsIndex effectiveRange:nil];
        CGRect glyphsRect = [self boundingRectForGlyphRange:NSMakeRange(glyphsIndex, 1) inTextContainer:textContainer];
        
        CGFloat x = origin.x + CGRectGetMinX(glyphsRect);
        CGFloat y = origin.y + CGRectGetMinY(glyphsRect);
        CGFloat width = CGRectGetWidth(glyphsRect);
        CGFloat height = CGRectGetHeight(glyphsRect);

        if ([attachment isKindOfClass:[AnyViewTextAttachment class]]) {
            AnyViewTextAttachment *anyViewAttachment = (AnyViewTextAttachment *)attachment;
            TextAttachmentReusableView *reusableView = [self.attachmentsManager reusableViewForAttachment:anyViewAttachment];
            
            UIEdgeInsets contentInset = anyViewAttachment.contentInset;
            if (UIEdgeInsetsEqualToEdgeInsets(contentInset, UIEdgeInsetsZero)) {
                reusableView.frame = CGRectMake(x, y, width, height);
            }else{
                reusableView.frame = CGRectMake(x + contentInset.left, y + contentInset.top, width - contentInset.left - contentInset.right, height - contentInset.bottom - contentInset.top);
            }
        }else{
            /// fix 原生(其它类型)附件 和 AnyViewTextAttachment 混用, 重叠显示问题
            if (!(CGRectGetWidth(glyphsRect) > 0 && CGRectGetHeight(glyphsRect) > 0)) {
                return ;
            }
            CGRect frame =  CGRectMake(x, y, width, height);
            [[self.attachmentsManager anyViewAttachmentsInTable] enumerateObjectsUsingBlock:^(AnyViewTextAttachment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                TextAttachmentReusableView *reusableView = [self.attachmentsManager reusableViewInTableFor:obj];
                if (reusableView && CGRectIntersectsRect(reusableView.frame, frame)) {
                    reusableView.frame = CGRectZero;
                }
            }];
        }
        
    }];
}



@end
