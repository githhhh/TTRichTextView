//
//  RichTextView+TextAttachment.m
//   
//
//  Created by tbin on 2018/11/27.
//  Copyright © 2018  bin. All rights reserved.
//

#import "RichTextView+TextAttachment.h"
#import "UITextView+TextAttachmentUtils.h"

@implementation RichTextView (TextAttachment)

- (VideoTextAttachment *)insertVideoAttachment:(UIImage *)posterImg paragraphStyle:(NSMutableParagraphStyle*)style{
    VideoTextAttachment *videoAttachment =  [[VideoTextAttachment alloc] init];
    
    videoAttachment.bounds = CGRectMake(0, 0, posterImg.size.width, posterImg.size.height);
    videoAttachment.image = posterImg;
    
    [self insertAttachment:videoAttachment paragraphStyle:style];
    return videoAttachment;
}

- (ImageTextAttachment *)insertImgAttachment:(UIImage *)resizeImg paragraphStyle:(NSMutableParagraphStyle*)style{
    ImageTextAttachment* imgAttachment = [[ImageTextAttachment alloc] init];
    
    imgAttachment.bounds = CGRectMake(0, 0, resizeImg.size.width, resizeImg.size.height);//
    imgAttachment.image = resizeImg;
    
    [self insertAttachment:imgAttachment paragraphStyle:style];
    return imgAttachment;
}


- (NSInteger)imageAttachmentCount{
    __block NSInteger count = 0;
    [self.textStorage enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.textStorage.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if (value != nil && [value isKindOfClass:[ImageTextAttachment class]]) {
            count++;
        }
    }];
    return count;
}

- (NSInteger)videoAttachmentCount{
    __block NSInteger count = 0;
    [self.textStorage enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.textStorage.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if (value != nil && [value isKindOfClass:[VideoTextAttachment class]]) {
            count++;
        }
    }];
    return count;
}

- (NSArray<MediaTextAttachment *> *)allPendingUploadAttachments{
    NSMutableArray<MediaTextAttachment *> * pendingUploadAtts = [NSMutableArray arrayWithCapacity:0];
    NSArray<NSTextAttachment *> *allAttachments = [self allAttachments];
    for (NSTextAttachment *att in allAttachments) {
        if ([att isKindOfClass:[MediaTextAttachment class]]) {
            if (![(MediaTextAttachment *)att isUploaded]) {
                [pendingUploadAtts addObject:(MediaTextAttachment *)att];
            }
        }
    }
    return pendingUploadAtts;
}

@end
