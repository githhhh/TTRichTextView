//
//  DraftManager+Attachment.m
//   
//
//  Created by tbin on 2018/11/29.
//  Copyright © 2018  bin. All rights reserved.
//

#import "DraftManager+Attachment.h"

@implementation DraftManager (Attachment)


- (void)insertImgAttachmentInDraft:(NSURL *)photoFileURL photoUrl:(NSURL *)photoUrl{
    DraftAttachmentDataModel *imgAttachment = [[DraftAttachmentDataModel alloc] init];
    imgAttachment.draft_uuid = self.model.uuid;
    imgAttachment.diskPath = photoFileURL.absoluteString;
}






@end
