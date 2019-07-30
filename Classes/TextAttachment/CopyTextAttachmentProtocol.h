//
//  CopyTextAttachmentProtocol.h
//   
//
//  Created by tbin on 2018/11/27.
//  Copyright © 2018  bin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DraftMetaDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CopyTextAttachmentProtocol <NSObject>

/// 支持 NSTextAttachment 复制、粘贴。
- (DraftAttachmentDataModel *)attachmentDraftMetaData;

/// 支持 NSTextAttachment 复制、粘贴。
- (instancetype)setupAttachmentForMetaData:(DraftAttachmentDataModel *)metaData;

@end

NS_ASSUME_NONNULL_END
