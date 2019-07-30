//
//  ImageTextAttachment.m
//  RichText
//
//  Created by tbin on 2018/7/16.
//  Copyright © 2018年 me.test. All rights reserved.
//

#import "ImageTextAttachment.h"
#import "UIImage+Utils.h"

@implementation ImageTextAttachment

#pragma mark - CopyTextAttachmentProtocol

- (DraftAttachmentDataModel *)attachmentDraftMetaData{
    DraftAttachmentDataModel *dataModel = [[DraftAttachmentDataModel alloc] init];
    dataModel.attachmentType = ImgAttachmentType;
    dataModel.attachmentWidth = self.bounds.size.width;
    dataModel.attachmentHeight = self.bounds.size.height;
    
    dataModel.diskPath = self.thumbnailDiskPath.absoluteString;
    return dataModel;
}

- (instancetype)setupAttachmentForMetaData:(DraftAttachmentDataModel *)metaData{
    UIImage *img = [UIImage imageWithContentsOfFile:metaData.diskPath];
    self.image = img;
    return self;
}

@end
