//
//  NSTextStorage+Html.h
//   
//
//  Created by tbin on 2018/11/22.
//  Copyright © 2018  bin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TextStorageHtmlTagType) {
    Undefined_HtmlTag = 100,
    /// 段落
    P_HtmlTag,
    /// 加粗
    B_HtmlTag,
    /// 下划线
    U_HtmlTag,
    /// 斜体
    I_HtmlTag
};

NS_ASSUME_NONNULL_BEGIN

@interface NSTextStorage (Html)

/**
 解析html中支持的标签

 @param simpleHtml 仅解析支持的html标签 p、b、u、i
 @param typingAttributes typingAttributes description
 @return return value description
 */
+ (NSMutableAttributedString *)attributedStringForSimpleHtml:(NSString *)simpleHtml typingAttributes:(NSDictionary<NSAttributedStringKey, id> *)typingAttributes;

/**
 转换为简单html标签，附件使用占位符代替

 @param handleAttachment handleAttachment description
 @return return value description
 */
- (NSString *)draftHtmlForAttributedString:(void(^)(NSTextAttachment *attachment))handleAttachment;


- (NSString *)convertToHtml;

/// html标签映射富文本字符串
+ (NSDictionary<NSString *,NSMutableAttributedString *> *)mapingHtmlTagAttributedString:(NSString *)matchText;

/// html标签 枚举字符串
+ (NSString *)enumHtmlTagString:(TextStorageHtmlTagType)tag;

+ (void)searchHtmlTag:(NSString *)tag inString:(NSString *)string complate:(void(^)(NSTextCheckingResult *result))complate;
@end

NS_ASSUME_NONNULL_END
