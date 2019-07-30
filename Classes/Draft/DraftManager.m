//
//  DraftManager.m
//   
//
//  Created by tbin on 2018/11/28.
//  Copyright © 2018  bin. All rights reserved.
//

#import "DraftManager.h"

@interface DraftManager ()

@property (nonatomic,copy,readwrite) NSString *draftId;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,strong,readwrite) DraftMetaDataModel *model;


@end

@implementation DraftManager (limitCount)

+ (void)limitDraftCount{
    /// 限制100条
    
}

@end


@implementation DraftManager

- (instancetype)initWith:(NSString *)draftId draftType:(DraftType)type
{
    self = [super init];
    if (self) {
        _draftId = draftId;
        /// search
        DraftMetaDataModel *draftModel = [DraftManager draftModelWith:draftId];
        if (draftModel) {
            _model = draftModel;
        }else{
            _model = [[DraftMetaDataModel alloc] init];
            _model.type = type;
            if (![_model saveToDB]) {
                NSLog(@"DraftMetaDataModel SaveToDB ~~~~~~~~~ Error");
            }
            _draftId = _model.uuid;
        }
    
        /// 重置草稿状态为编辑中....
        [self updateDraftStatus:DraftEditing];
        
        /// 限制草稿箱数量
        [DraftManager limitDraftCount];
    }
    return self;
}

#pragma mark - 异常退出 重新打开

+ (void)isReopenEditingDraft{
    /// 获取最后一次编辑中的草稿
    [[DraftMetaDataModel getUsingLKDBHelper] search:DraftMetaDataModel.class where:@{@"status":@(0)} orderBy:@"createTime desc" offset:0 count:NSIntegerMax callback:^(NSMutableArray * _Nullable array) {
        if (array.count == 0) {
            return ;
        }
        DraftMetaDataModel *draft = array.firstObject;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *topVC = [self getTopViewController];
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"检测到你在编辑中异常退出，是否继续编辑" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                /// 重置草稿状态 编辑完成
                draft.status = DraftEdited;
                if ([draft updateToDB]) {
                    NSLog(@"~~~~编辑状态更新完成");
                }
            }];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"继续编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //TODO: 弹出编辑器控制器
                NSAssert(NO, @"TODO: 弹出编辑器控制器");
            }];
            [alert addAction:cancelAction];
            [alert addAction:action];
            [topVC presentViewController:alert animated:YES completion:nil];
        });
    }];
}

+ (UIViewController *)getTopViewController {
    
    UIViewController *topViewController = [[[UIApplication sharedApplication].windows objectAtIndex:0] rootViewController];
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    
    if ([topViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController*)topViewController;
        topViewController = [nav.viewControllers lastObject];
    }
    if ([topViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController*)topViewController;
        topViewController = tab.selectedViewController;
    }
    
    return topViewController;
}


#pragma mark - Fetch draft

/// 主键查询
+ (DraftMetaDataModel *)draftModelWith:(NSString *)draftId{
    if (draftId.length == 0) {
        return nil;
    }
    return [DraftMetaDataModel searchSingleWithWhere:@{@"uuid":draftId} orderBy:nil];;
}

/// 获取所有草稿
+ (void)fetchAllDraft:(void(^)(NSArray<DraftMetaDataModel *> * drafts))complate{
    /// 时间倒序
    [[DraftMetaDataModel getUsingLKDBHelper] search:DraftMetaDataModel.class where:nil orderBy:@"createTime desc" offset:0 count:NSIntegerMax callback:^(NSMutableArray * _Nullable array) {

        /// 查询附件
        for (DraftMetaDataModel *draftModel in array) {
            /// TODO: 附件数据排序
            draftModel.dataModes = [self fetchDraftAttachments:draftModel orderBy:nil];
        }
        
        if (complate) {
            complate(array);
        }
    }];
}

/// 获取草稿对应的附件
+ (NSArray<DraftAttachmentDataModel *> *)fetchDraftAttachments:(DraftMetaDataModel *)draft orderBy:(NSString *)orderBy{
    return [DraftAttachmentDataModel searchWithWhere:@{@"draft_uuid":draft.uuid} orderBy:orderBy offset:0 count:NSIntegerMax];
}

/// 获取草稿对应的其他内容

#pragma mark - Delete draft

/// 删除草稿
- (BOOL)deleteDraft{
   return [DraftManager deleteDraft:_model];
}

+ (BOOL)deleteDraft:(DraftMetaDataModel *)draftModel{
    if (![DraftMetaDataModel isExistsWithModel:draftModel]) {
        return YES;
    }
    /// 查询附件
    NSArray<DraftAttachmentDataModel *> * attachmentsInDB = [self fetchDraftAttachments:draftModel orderBy:nil];
    [[DraftMetaDataModel getUsingLKDBHelper] executeForTransaction:^BOOL(LKDBHelper * _Nonnull helper) {
        /// 删除附件
        BOOL isSuc = [DraftManager deleteDraftAttachments:attachmentsInDB];
        /// 删除草稿
        isSuc = [draftModel deleteToDB];
        return isSuc;
    }];
    
    /// 是否删除成功
    if ([DraftMetaDataModel isExistsWithModel:draftModel]) {
        return NO;
    }
    /// 在删除附件对应资源文件
    for (DraftAttachmentDataModel *attachment in attachmentsInDB) {
        [self clearSandboxResourceWithFileName:attachment.diskPath];
    }
    return YES;
}

/// 删除附件
+ (BOOL)deleteDraftAttachments:(NSArray<DraftAttachmentDataModel *> *) attachmentsInDB{
    BOOL isSuc = YES;
    /// 先删除附件表数据
    for (DraftAttachmentDataModel *attachment in attachmentsInDB) {
        isSuc = [attachment deleteToDB];
        if (!isSuc) {
            return NO;
        }
    }
    return isSuc;
}

+ (BOOL)clearSandboxResourceWithFileName:(NSString *)fileName{
    if (fileName.length == 0) {
        return NO;
    }
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile] == NO) {
        NSLog(@"~~~~%@!!!!!!!!文件不存在",fullPathToFile);
        return NO;
    }
    NSError *err;
    BOOL isRemoved = [[NSFileManager defaultManager] removeItemAtPath:fullPathToFile error:&err];
    if (!isRemoved || err) {
        return NO;
    }
    return YES;
}

#pragma mark - Update draft

/// 更新草稿状态
- (void)updateDraftStatus:(DraftEditStatus)status{
    if (status == _model.status) {//不用更新了
        return;
    }
    _model.status = status;
    if (status == DraftEdited) {
        /// 更新时间
        _model.createTime = [[NSDate date] timeIntervalSince1970];
    }
    if (![_model updateToDB]) {
        NSLog(@"更新草稿状态失败~~~~~~");
    }
}

/// 更新草稿正文
- (void)updateDraftText:(NSString *)contentText richText:(NSString *)richText richTextType:(RichTextType)richTextType{
    _model.textContent = contentText;
    _model.richTextType = richTextType;
    _model.richText = richText;
    if ([_model saveToDB]) {
        NSLog(@"~~~~~~~更新文本内容失败");
    }
}


@end

