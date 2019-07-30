//
//  AttachmentGestureRecognizerDelegate.m
//   
//
//  Created by tbin on 2018/11/20.
//  Copyright © 2018  bin. All rights reserved.
//

#import "AttachmentGestureRecognizerDelegate.h"

@interface AttachmentGestureRecognizerDelegate ()

@property (nonatomic,weak) NSTextAttachment *currentSelectedAttachment;

@end

@implementation AttachmentGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (!self.textView) {
        return NO;
    }
    
    CGPoint locationInTextView = [touch locationInView:self.textView];
    BOOL isAttachmentInLocation = [self.textView attachmentAtPoint:locationInTextView] != nil;
    
    if (!isAttachmentInLocation) {
        NSTextAttachment *selectedAttachment = self.currentSelectedAttachment;
        if (selectedAttachment && [self.textView.attachmentDelegate respondsToSelector:@selector(textView:deselected:atPoint:)]) {
            [self.textView.attachmentDelegate textView:self.textView deselected:selectedAttachment atPoint:locationInTextView];
        }
        self.currentSelectedAttachment = nil;
    }
    return isAttachmentInLocation;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (!self.textView) {
        return NO;
    }
    CGPoint locationInTextView = [gestureRecognizer locationInView:self.textView];
    
    NSTextAttachment *pointAttachment = [self.textView attachmentAtPoint:locationInTextView];
    
    if (!pointAttachment) {
        NSTextAttachment *selectedAttachment = self.currentSelectedAttachment;
        if (selectedAttachment && [self.textView.attachmentDelegate respondsToSelector:@selector(textView:deselected:atPoint:)]) {
            [self.textView.attachmentDelegate textView:self.textView deselected:selectedAttachment atPoint:locationInTextView];
        }
        self.currentSelectedAttachment = nil;
        return NO;
    }
    return YES;
}


- (void)richTextViewWasPressed:(UIGestureRecognizer *)recognizer{
    if (self.textView == nil || recognizer.state != UIGestureRecognizerStateRecognized) {
        return;
    }
    CGPoint locationInTextView = [recognizer locationInView:self.textView];
    NSTextAttachment *attachment = [self.textView attachmentAtPoint:locationInTextView];
    if (!attachment) {
        return;
    }
    
    if ([self.textView.attachmentDelegate respondsToSelector:@selector(textView:tapedAttachment:)]) {
        [self.textView.attachmentDelegate textView:self.textView tapedAttachment:attachment];
    }
    self.currentSelectedAttachment = attachment;
}

@end
