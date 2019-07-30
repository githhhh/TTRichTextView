//
//  VideoTextAttachment.m
//  RichText
//
//  Created by tbin on 2018/7/16.
//  Copyright © 2018年 me.test. All rights reserved.
//

#import "VideoTextAttachment.h"

@implementation VideoTextAttachment

#pragma mark - CopyTextAttachmentProtocol

- (DraftAttachmentDataModel *)attachmentDraftMetaData{
    DraftAttachmentDataModel *dataModel = [[DraftAttachmentDataModel alloc] init];
    dataModel.attachmentType = ImgAttachmentType;
    dataModel.attachmentWidth = self.bounds.size.width;
    dataModel.attachmentHeight = self.bounds.size.height;
    NSAssert(NO, @"TODO ...Function");
    return dataModel;
}

- (instancetype)setupAttachmentForMetaData:(DraftAttachmentDataModel *)metaData{
    NSAssert(NO, @"TODO ...Function");
    return self;
}

@end
