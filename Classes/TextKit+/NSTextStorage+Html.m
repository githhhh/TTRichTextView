//
//  NSTextStorage+Html.m
//   
//
//  Created by tbin on 2018/11/22.
//  Copyright © 2018  bin. All rights reserved.
//

#import "NSTextStorage+Html.h"
#import "MediaTextAttachment.h"
#import "ImageTextAttachment.h"
#import "VideoTextAttachment.h"
#import "RichTextTools.h"
#import "NSTextStorage+Utils.h"

@implementation NSTextStorage (Html)

#pragma mark -  Simple Html To NSAttributedString

+ (NSMutableAttributedString *)attributedStringForSimpleHtml:(NSString *)simpleHtml typingAttributes:(NSDictionary<NSAttributedStringKey, id> *)typingAttributes{
    
    NSMutableAttributedString *htmlAttrString = [[NSMutableAttributedString alloc] initWithString:simpleHtml];
    [typingAttributes enumerateKeysAndObjectsUsingBlock:^(NSAttributedStringKey  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [htmlAttrString addAttribute:key value:obj range:NSMakeRange(0, htmlAttrString.length)];
    }];

    NSArray *supportHtmlTags = @[@(P_HtmlTag),@(B_HtmlTag),@(U_HtmlTag),@(I_HtmlTag)];

    for (NSNumber *tag in supportHtmlTags) {
        TextStorageHtmlTagType htmlTag = [tag integerValue];

        [self searchHtmlTag:[self enumHtmlTagString:htmlTag] inString:htmlAttrString.string complate:^(NSTextCheckingResult *result) {
            NSString *htmlTagStr = [self enumHtmlTagString:htmlTag];
            NSString *openTag = [NSString stringWithFormat:@"<%@>",htmlTagStr];
            NSString *closeTag = [NSString stringWithFormat:@"</%@>",htmlTagStr];

            NSString *matchText = [htmlAttrString.string substringWithRange:result.range];
            matchText = [matchText stringByReplacingOccurrencesOfString:openTag withString:@""];

            if (htmlTag == P_HtmlTag) {
                matchText = [matchText stringByReplacingOccurrencesOfString:closeTag withString:@""];
                [htmlAttrString replaceCharactersInRange:result.range withString:matchText];
                
            }else{
                matchText = [matchText stringByReplacingOccurrencesOfString:closeTag withString:@""];
                NSMutableAttributedString *attr = [self mapingHtmlTagAttributedString:matchText][htmlTagStr];
                
                [typingAttributes enumerateKeysAndObjectsUsingBlock:^(NSAttributedStringKey  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    [attr addAttribute:key value:obj range:NSMakeRange(0, matchText.length)];

                    /// 加粗 更换字体
                    if (key == NSFontAttributeName && htmlTag == B_HtmlTag) {
                        UIFont *font = typingAttributes[NSFontAttributeName];
                        [attr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font.pointSize] range:NSMakeRange(0, matchText.length)];
                    }
                }];
                [htmlAttrString replaceCharactersInRange:result.range withAttributedString:attr];
            }
        }];
    }
    
    return htmlAttrString;
}

#pragma mark - NSAttributedString To Simple Html

- (NSString *)draftHtmlForAttributedString:(void(^)(NSTextAttachment *attachment))handleAttachment{
    NSMutableAttributedString *attributedString = [self mutableCopy];
    [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        if ([attrs.allKeys containsObject:NSAttachmentAttributeName]) {
            NSTextAttachment *attachment = attrs[NSAttachmentAttributeName];
            if ([attachment isKindOfClass:[MediaTextAttachment class]]) {
                if (handleAttachment) {
                    handleAttachment(attachment);
                }
                [attributedString replaceCharactersInRange:range withString: [NSString stringWithFormat:@"</p>%@<p>",kAttachmentDraftPlaceholder]];
            }
        }
        /// 转换 b、u、i 标签
        NSString *htmlTagContent = [NSTextStorage htmlTagContentInAttributedString:attributedString attrs:attrs range:range];
        if (htmlTagContent) {
            [attributedString replaceCharactersInRange:range withString:htmlTagContent];
        }
    }];
    
    NSString *effectiveText = [NSString stringWithFormat:@"<p>%@</p>",attributedString.string];
    /// 过滤换行
    effectiveText = [effectiveText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    effectiveText = [effectiveText stringByReplacingOccurrencesOfString:@"<p></p>" withString:@""];
    return effectiveText;
}

+ (NSString *)htmlTagContentInAttributedString:(NSAttributedString *)attributedString attrs:(NSDictionary<NSAttributedStringKey,id> * _Nonnull)attrs range:(NSRange)range{
    if (attributedString.length == 0 || attrs.count == 0 || range.location == NSNotFound) {
        return nil;
    }
    
    /// 下划线
    if([attrs.allKeys containsObject:NSUnderlineStyleAttributeName]){
        NSString *uTag = [NSTextStorage enumHtmlTagString:U_HtmlTag];
        NSString *content = [attributedString.string substringWithRange:range];
        NSString *uHtml = [NSString stringWithFormat:@"<%@>%@</%@>",uTag,content,uTag];
        return uHtml;
    }
    /// 加粗
    if([attrs.allKeys containsObject:NSFontAttributeName]){
        UIFont *font = attrs[NSFontAttributeName];
        if ([font.fontName rangeOfString:@"bold"].location != NSNotFound) {
            NSString *bTag = [NSTextStorage enumHtmlTagString:B_HtmlTag];
            NSString *content = [attributedString.string substringWithRange:range];
            NSString *bHtml = [NSString stringWithFormat:@"<%@>%@</%@>",bTag,content,bTag];
            return bHtml;
        }
    }
    /// 斜体
    if([attrs.allKeys containsObject:NSObliquenessAttributeName]){
        NSString *iTag = [NSTextStorage enumHtmlTagString:I_HtmlTag];
        NSString *content = [attributedString.string substringWithRange:range];
        NSString *iHtml = [NSString stringWithFormat:@"<%@>%@</%@>",iTag,content,iTag];
        return iHtml;
    }
    return nil;
}

- (NSString *)convertToHtml{
    NSMutableAttributedString *attributedString = [self mutableCopy];
    [attributedString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value == nil) {
            return ;
        }
        NSLog(@"range:---%@",NSStringFromRange(range));
        
        if ([value isKindOfClass:[ImageTextAttachment class]]) {
            ImageTextAttachment *imgAttachment = (ImageTextAttachment *)value;
            
            NSString *imgTagStr = [NSString stringWithFormat:@"</p><img src=\"%@\" width =\"%.2f\" height=\"%.2f\" /><p>",imgAttachment.imageURL.absoluteString,imgAttachment.orgImgSize.width,imgAttachment.orgImgSize.height];
            
            [attributedString replaceCharactersInRange:range withString:imgTagStr];
            
        }else if ([value isKindOfClass:[VideoTextAttachment class]]){
            VideoTextAttachment *videoAttachment = (VideoTextAttachment *)value;
            
            NSString *videoTagStr = [NSString stringWithFormat:@"</p><video src=\"%@\" poster=\"%@\" width =\"%.2f\" height=\"%.2f\" ></video><p>",videoAttachment.videoURL.absoluteString,videoAttachment.posterURL.absoluteString,videoAttachment.coverSize.width,videoAttachment.coverSize.height];
            
            [attributedString replaceCharactersInRange:range withString:videoTagStr];
        }
    }];
    
    NSString *effectiveText = [NSString stringWithFormat:@"<p>%@</p>",attributedString.string];
    /// 过滤换行
    effectiveText = [effectiveText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    effectiveText = [effectiveText stringByReplacingOccurrencesOfString:@"<p></p>" withString:@""];
    
    return effectiveText;
}

#pragma mark - Simple Html Tag & NSMutableAttributedString

+ (void)searchHtmlTag:(NSString *)tag inString:(NSString *)string complate:(void(^)(NSTextCheckingResult *result))complate{
    if (!(tag.length > 0)) {
        return;
    }
    NSRegularExpression *kTopicExp = [NSRegularExpression regularExpressionWithPattern:kHtmlExpression(tag) options:NSRegularExpressionCaseInsensitive error:nil];
    [kTopicExp enumerateMatchesInString:string options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (!result) return;
        if (complate) {
            complate(result);
        }
    }];
}

+ (NSDictionary<NSString *,NSMutableAttributedString *> *)mapingHtmlTagAttributedString:(NSString *)matchText {
    NSMutableAttributedString *bAttr = [[NSMutableAttributedString alloc] initWithString:matchText];
    [bAttr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]] range:NSMakeRange(0, matchText.length)];

    NSMutableAttributedString* uAttr = [[NSMutableAttributedString alloc] initWithString:matchText];
    [uAttr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, matchText.length)];
    [uAttr addAttribute:NSUnderlineColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, matchText.length)];

    NSMutableAttributedString *iAttr = [[NSMutableAttributedString alloc] initWithString:matchText];
    [iAttr addAttribute:NSObliquenessAttributeName value:@(0.5) range:NSMakeRange(0, matchText.length)];

    return @{
             [self enumHtmlTagString:B_HtmlTag]:bAttr,
             [self enumHtmlTagString:U_HtmlTag]:uAttr,
             [self enumHtmlTagString:I_HtmlTag]:iAttr
             };
}

+ (NSString *)enumHtmlTagString:(TextStorageHtmlTagType)tag{
    switch (tag) {
        case P_HtmlTag:
            return @"p";
            break;
        case B_HtmlTag:
            return @"b";
            break;
        case U_HtmlTag:
            return @"u";
            break;
        case I_HtmlTag:
            return @"i";
            break;
            
        default:
            return @"";
            break;
    }
}
@end
