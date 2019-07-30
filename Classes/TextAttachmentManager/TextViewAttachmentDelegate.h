//
//  TextViewAttachmentDelegate.h
//   
//
//  Created by tbin on 2018/11/20.
//  Copyright © 2018  bin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnyViewTextAttachment.h"
#import "TextAttachmentReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TextViewAttachmentDelegate <NSObject>

- (TextAttachmentReusableView *)textView:(UITextView *)textView viewForAttachment:(AnyViewTextAttachment *)attachment;

- (void)textView:(UITextView *)textView tapedAttachment:(NSTextAttachment *)attachment;

- (void)textView:(UITextView *)textView deselected:(NSTextAttachment *)deselectedAttachment  atPoint: (CGPoint)point;

@end

NS_ASSUME_NONNULL_END
