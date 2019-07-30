//
//  MediaTextAttachment.h
//   
//
//  Created by tbin on 2018/7/17.
//  Copyright © 2018年  bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CopyTextAttachmentProtocol.h"

@interface MediaTextAttachment : NSTextAttachment<CopyTextAttachmentProtocol>

@property (nonatomic,assign) BOOL isUploaded;

+ (MediaTextAttachment *)attachmentForMetaData:(DraftAttachmentDataModel *)metaData NS_REQUIRES_SUPER;

@end
