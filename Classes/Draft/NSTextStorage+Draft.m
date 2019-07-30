//
//  NSTextStorage+Draft.m
//   
//
//  Created by tbin on 2018/11/21.
//  Copyright © 2018  bin. All rights reserved.
//

#import "NSTextStorage+Draft.h"
#import "MediaTextAttachment.h"
#import "AnyViewTextAttachment.h"
#import "NSTextStorage+Utils.h"
#import "NSTextStorage+Html.h"

#define TTextAttachmentAttributeName (@"TTextAttachmentAttributeName")

@implementation NSTextStorage (Draft)

+ (NSTextStorage *)textStorageWithDraft:(DraftMetaDataModel *)draft typingAttributes:(NSDictionary<NSAttributedStringKey, id> *)typingAttributes{
    if (!draft || draft.richText.length == 0) {
        return [[NSTextStorage alloc] init];
    }
    NSMutableAttributedString *textAttr = [NSTextStorage attributedStringForSimpleHtml:draft.richText typingAttributes:typingAttributes];
   
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:kAttachmentDraftPlaceholderRegularExpression options:NSRegularExpressionCaseInsensitive error:nil];
    __block NSInteger index = 0;
    NSRange allRange = NSMakeRange(0, textAttr.length);
    NSArray<NSTextCheckingResult *> *resute = [expression matchesInString:textAttr.string options:0 range:allRange];
    
    for (NSTextCheckingResult *match in resute) {
        if (!match || index >= draft.dataModes.count) break;
    
        /// 标记
        NSMutableAttributedString *attachmentAttr  = [[NSMutableAttributedString alloc ] initWithString: [textAttr.string substringWithRange:match.range] ];
        [attachmentAttr addAttribute:TTextAttachmentAttributeName value:@(1) range:NSMakeRange(0, attachmentAttr.length)];
        
        [textAttr replaceCharactersInRange:match.range withAttributedString:attachmentAttr];
        index = index + 1;
    }
    
    index = 0;
    [textAttr enumerateAttribute:TTextAttachmentAttributeName inRange:allRange options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (!value || index >= draft.dataModes.count) {
            return ;
        }
        NSTextAttachment *attachment = [MediaTextAttachment attachmentForMetaData:draft.dataModes[index]];
        NSAttributedString* attachmentAttr =  [NSTextStorage attributedStringForAttachment:attachment typingAttributes:typingAttributes];
        [textAttr replaceCharactersInRange:range withAttributedString:attachmentAttr];
    }];
    
    
    return  [[NSTextStorage alloc] initWithAttributedString:textAttr];
}


- (void)buildDraft:(RichTextType)richTextType complated:(void(^)(DraftMetaDataModel *draftModel))complated{
    DraftMetaDataModel *draft = [[DraftMetaDataModel alloc] init];
    NSMutableArray<DraftAttachmentDataModel *> *dataModes = [NSMutableArray arrayWithCapacity:0];
    
    NSString * textDraft = [self draftHtmlForAttributedString:^(NSTextAttachment * _Nonnull attachment) {
        DraftAttachmentDataModel *dataModel =  [(MediaTextAttachment *)attachment attachmentDraftMetaData];
        [dataModes addObject: dataModel];
    }];
        
    draft.richTextType = RichTextHtml;
    
    draft.richText = textDraft;
    draft.dataModes = dataModes;
    
    [self serializationDraftToJSON:draft];
    
    if (complated) {
        complated(draft);
    }
}

- (void)serializationDraftToJSON:(DraftMetaDataModel *)draftModel{
    if (!draftModel || draftModel.richText.length == 0) {
        return;
    }
    NSMutableArray *jsonArr = [NSMutableArray arrayWithCapacity:0];
    NSArray *textArr = [NSTextStorage subTextArrFor:draftModel.richText spliteWith:kAttachmentDraftPlaceholder];
    if (textArr.count == 1) {
        jsonArr = [NSMutableArray arrayWithArray:textArr];
    }else{
        NSInteger index = 0;
        for (NSString *text in textArr) {
            if ([text isEqualToString:kAttachmentDraftPlaceholder] && index < draftModel.dataModes.count) {
                /// 附件
                DraftAttachmentDataModel *attachmentDataModel = draftModel.dataModes[index];
                [jsonArr addObject:attachmentDataModel];
                index = index + 1;
            }else{
                [jsonArr addObject:text];
            }
        }
    }
    NSLog(@"~~~~~~~~~@!!!jsonArr!!!!!!!!!%@",jsonArr);
}

#pragma mark - Private

/// 分割字符串 返回有序数组 ===> @[subText,placeholder,subText,placeholder....]
+ (NSArray *)subTextArrFor:(NSString *)text spliteWith:(NSString *)placeholder{
    if (text.length == 0) {
        return @[];
    }
    if (placeholder.length == 0) {
        return @[text];
    }
    NSRange searchRange = NSMakeRange(0, text.length);
    NSMutableArray *textArrs = [NSMutableArray arrayWithCapacity:0];
    while (true) {
        if (searchRange.location == NSNotFound || searchRange.length == 0 || searchRange.length + searchRange.location > text.length) {
            break;
        }
        NSRange placeholderRange = [text rangeOfString:placeholder options:NSCaseInsensitiveSearch range:searchRange locale:nil];
        if (placeholderRange.length == 0 || placeholderRange.location == NSNotFound) {
            /// 没有了
            NSString *subText = [text substringWithRange:searchRange];
            [textArrs addObject:subText];
            break;
        }
        
        if (placeholderRange.location == searchRange.location) {
            NSString *placeholderText = [text substringWithRange:placeholderRange];
            [textArrs addObject:placeholderText];
        }else{
            NSRange textRange = NSMakeRange(searchRange.location, placeholderRange.location - searchRange.location);
            NSString *subText = [text substringWithRange:textRange];
            [textArrs addObject:subText];
            
            NSString *placeholderText = [text substringWithRange:placeholderRange];
            [textArrs addObject:placeholderText];
        }
        
        searchRange.location = placeholderRange.location  + placeholderRange.length;
        searchRange.length = text.length - searchRange.location;
    }
    return [textArrs copy];
}

@end
