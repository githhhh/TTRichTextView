//
//  DraftManager.h
//   
//
//  Created by tbin on 2018/11/28.
//  Copyright © 2018  bin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DraftMetaDataModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 草稿数据最大限制
static NSInteger const maxCountDraftCache = 100;

@interface DraftManager : NSObject

@property (nonatomic,copy,readonly) NSString *draftId;

@property (nonatomic,strong,readonly) DraftMetaDataModel *model;

/// 启动调用当前方法，检测草稿编辑中是否异常退出
+ (void)isReopenEditingDraft;

/// 获取所有草稿
+ (void)fetchAllDraft:(void(^)(NSArray<DraftMetaDataModel *> * drafts))complate;

/// 删除草稿
- (BOOL)deleteDraft;
+ (BOOL)deleteDraft:(DraftMetaDataModel *)draftModel;

/// 更新草稿状态
- (void)updateDraftStatus:(DraftEditStatus)status;
/// 更新草稿正文
- (void)updateDraftText:(NSString *)contentText richText:(NSString *)richText richTextType:(RichTextType)richTextType;


@end

NS_ASSUME_NONNULL_END
