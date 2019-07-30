//
//  UITextView+TextAttachmentUtils.h
//   
//
//  Created by tbin on 2018/11/20.
//  Copyright © 2018  bin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (TextAttachmentUtils)

- (NSArray<NSTextAttachment *> *)allAttachments;

- (NSArray<NSTextAttachment*> *)viewAttachments:(NSRange)inRange;

- (NSTextAttachment *)attachmentAtPoint:(CGPoint)point;

/// 插入附件，前后各有换行
- (void)insertAttachment:(NSTextAttachment *)attachment paragraphStyle:(NSMutableParagraphStyle*)style;

@end

NS_ASSUME_NONNULL_END
