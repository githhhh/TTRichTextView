//
//  RichTextTools.h
//   
//
//  Created by tbin on 2018/11/21.
//  Copyright © 2018  bin. All rights reserved.
//

#ifndef RichTextTools_h
#define RichTextTools_h

#define XFRichTextSrcName(file) ([@"XFRichTextTool.bundle" stringByAppendingPathComponent:file])
#define XFRichTextImage(file) ([UIImage imageNamed:XFRichTextSrcName(file)])


#define kHtmlExpression(tag) ([NSString stringWithFormat:@"\\<(%@)(?![\\w-])([^\\>\\/]*(?:\\/(?!\\>)[^\\>\\/]*)*?)(?:(\\/)\\>|\\>(?:([^\\<]*(?:\\<(?!\\/\\1\\>)[^\\<]*)*)(\\<\\/\\1\\>))?)",tag])

#define UnavailableMacro(msg) __attribute__((unavailable(msg)))

/// 附件类型
typedef NS_ENUM(NSUInteger, AttachmentType) {
    UndefinedAttachmentType,
    ImgAttachmentType,
    GifAttachmentType,
    AudioAttachmentType,
    VideoAttachmentType,
};

/// 富文本存储类型
typedef NS_ENUM(NSUInteger, RichTextType) {
    RichTextHtml
};

/// 草稿类型
typedef NS_ENUM(NSUInteger, DraftType) {
    DraftDefaultType
};

/// 草稿状态
typedef NS_ENUM(NSUInteger, DraftEditStatus) {
    DraftEditing, /// 编辑中
    DraftEdited, /// 编辑完成
};


/// html 存储草稿： 附件占位符
static NSString *const kAttachmentDraftPlaceholder = @"[Attachment]";
static NSString *const kAttachmentDraftPlaceholderRegularExpression = @"\\[Attachment\\]";

#endif /* RichTextTools_h */
