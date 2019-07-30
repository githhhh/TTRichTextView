//
//  AudioTextAttachment.m
//  HOHO
//
//  Created by tbin on 2018/11/21.
//  Copyright © 2018 ThinkFly. All rights reserved.
//

#import "AudioTextAttachment.h"

@implementation AudioTextAttachment

#pragma mark - CopyTextAttachmentProtocol

- (DraftAttachmentDataModel *)attachmentDraftMetaData{
    DraftAttachmentDataModel *dataModel = [[DraftAttachmentDataModel alloc] init];
    dataModel.attachmentType = AudioAttachmentType;
    dataModel.attachmentWidth = self.bounds.size.width;
    dataModel.attachmentHeight = self.bounds.size.height;
//    NSAssert(NO, @"TODO ...Function");
    return dataModel;
}

- (instancetype)setupAttachmentForMetaData:(DraftAttachmentDataModel *)metaData{
//    NSAssert(NO, @"TODO ...Function");
    return self;
}

@end
