//
//  RichTextView+TextAttachment.h
//   
//
//  Created by tbin on 2018/11/27.
//  Copyright © 2018  bin. All rights reserved.
//

#import "RichTextView.h"
#import "MediaTextAttachment.h"
#import "ImageTextAttachment.h"
#import "VideoTextAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface RichTextView (TextAttachment)

/// Attachment
- (NSInteger)imageAttachmentCount;
- (NSInteger)videoAttachmentCount;

// 获取所有未上传成功的附件
- (NSArray<MediaTextAttachment *> *)allPendingUploadAttachments;

// insert attachment
- (ImageTextAttachment *)insertImgAttachment:(UIImage *)resizeImg paragraphStyle:(NSMutableParagraphStyle*)style;
- (VideoTextAttachment *)insertVideoAttachment:(UIImage *)posterImg paragraphStyle:(NSMutableParagraphStyle*)style;

@end

NS_ASSUME_NONNULL_END
