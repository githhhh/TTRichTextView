//
//  GifTextAttachment.m
//  HOHO
//
//  Created by tbin on 2018/11/21.
//  Copyright © 2018 ThinkFly. All rights reserved.
//

#import "GifTextAttachment.h"

@implementation GifTextAttachment

#pragma mark - CopyTextAttachmentProtocol

- (DraftAttachmentDataModel *)attachmentDraftMetaData{
    DraftAttachmentDataModel *dataModel = [[DraftAttachmentDataModel alloc] init];
    dataModel.attachmentType = GifAttachmentType;
    dataModel.attachmentWidth = self.bounds.size.width;
    dataModel.attachmentHeight = self.bounds.size.height;
    dataModel.userInfo = @{@"gif":@"niconiconi"};
    
    return dataModel;
}

- (instancetype)setupAttachmentForMetaData:(DraftAttachmentDataModel *)metaData{
    self.gif = metaData.userInfo[@"gif"];
    return self;
}

@end
