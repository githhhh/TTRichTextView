//
//  AttachmentMetaDataModel.h
//   
//
//  Created by tbin on 2018/11/22.
//  Copyright © 2018  bin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RichTextTools.h"
#import <LKDBHelper/LKDBHelper.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DraftAttachmentDataModel;

@interface DraftMetaDataModel : NSObject

@property (nonatomic,copy) NSString *uuid;

@property (nonatomic,assign) DraftEditStatus status;

@property (nonatomic,assign) RichTextType richTextType;

/// 草稿类型
@property (nonatomic,assign) DraftType type;

/// 纯文本内容,用于草稿列表展示
@property (nonatomic,copy) NSString *textContent;

/// 富文本字符串 html、markdown
@property (nonatomic,copy) NSString *richText;

@property (nonatomic,strong) NSArray<DraftAttachmentDataModel *> *dataModes;

@property (nonatomic,assign) NSTimeInterval createTime;

+ (instancetype)defaultDraftModel;

@end


@interface DraftAttachmentDataModel : NSObject

@property (nonatomic,copy) NSString *uuid;
/// 对应草稿文章uuid
@property (nonatomic,copy) NSString *draft_uuid;


/// 附件显示尺寸
@property (nonatomic,assign) CGFloat attachmentWidth;
@property (nonatomic,assign) CGFloat attachmentHeight;

@property (nonatomic,assign) AttachmentType attachmentType;

@property (nonatomic,copy) NSString *diskPath;

@property (nonatomic,copy) NSString *urlPath;

@property (nonatomic,strong) NSDictionary *userInfo;
 
@end


NS_ASSUME_NONNULL_END
