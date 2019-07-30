//
//  AttachmentMetaDataModel.m
//   
//
//  Created by tbin on 2018/11/22.
//  Copyright © 2018  bin. All rights reserved.
//

#import "DraftMetaDataModel.h"
#import "NSTextStorage+Draft.h"
#import <objc/runtime.h>
#import "RichTextTools.h"

@implementation DraftMetaDataModel

+(LKDBHelper *)getUsingLKDBHelper{
    static LKDBHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[LKDBHelper alloc] initWithDBName:@"draft"];
        NSLog(@"DBName====%@",[LKDBHelper performSelector:@selector(getDBPathWithDBName:) withObject:@"draft"]);
    });
    return helper;
}

+ (void)initialize{
    [self removePropertyWithColumnNameArray:@[@"dataModes"]];
}

+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (BOOL)isContainParent{
    return NO;
}

+(NSString *)getPrimaryKey{
    return @"uuid";
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _uuid = [NSUUID UUID].UUIDString;
        _createTime = [[NSDate date] timeIntervalSince1970];
    }
    return self;
}


+ (instancetype)defaultDraftModel{
    DraftMetaDataModel *draftModel = [[DraftMetaDataModel alloc] init];
    
    NSString *html = @"<p>Writing Swift code is <b>interactive and fun</b>, the syntax is <i>concise yet</i> expressive, and apps run <u>lightning-fast</u>. Swift is ready for your next project — or addition into your current app — because Swift code works side-by-side with Objective-C.</p>";
    NSMutableString *string = [NSMutableString stringWithString:html];
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:0];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    for (int i = 0; i < 200; i++) {
        if (i%2 == 0) {
            DraftAttachmentDataModel *gifDataModel = [[DraftAttachmentDataModel alloc] init];
            gifDataModel.attachmentWidth = screenWidth - 20;
            gifDataModel.attachmentHeight = 200;
            gifDataModel.attachmentType = GifAttachmentType;

            [datas addObject:gifDataModel];
        }else{
            DraftAttachmentDataModel *audioDataModel = [[DraftAttachmentDataModel alloc] init];
            audioDataModel.attachmentWidth = screenWidth - 20;
            audioDataModel.attachmentHeight = 50;

            audioDataModel.attachmentType = AudioAttachmentType;
            
            [datas addObject:audioDataModel];
        }
        [string appendFormat:@"%@%@",kAttachmentDraftPlaceholder,html];
    }
    
    draftModel.richTextType = RichTextHtml;
    draftModel.richText = string;
    draftModel.dataModes = datas;
    return draftModel;
}

@end





@implementation DraftAttachmentDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _uuid = [NSUUID UUID].UUIDString;
    }
    return self;
}

+(LKDBHelper *)getUsingLKDBHelper{
    static LKDBHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[LKDBHelper alloc] initWithDBName:@"draft"];
    });
    return helper;
}

+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (BOOL)isContainParent{
    return NO;
}

+(NSString *)getPrimaryKey{
    return @"uuid";
}


@end
