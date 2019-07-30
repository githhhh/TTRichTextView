//
//  RichTextView+Draft.m
//   
//
//  Created by tbin on 2018/11/22.
//  Copyright © 2018  bin. All rights reserved.
//

#import "RichTextView+Draft.h"
#import "AttachmentLayoutManager.h"
#import "NSTextStorage+Draft.h"

@implementation RichTextView (Draft)

+(instancetype)richTextViewWithDraft:(DraftMetaDataModel *)draft typingAttributes:(NSDictionary<NSAttributedStringKey, id> *)typingAttributes{
    NSTextStorage *storage = [NSTextStorage textStorageWithDraft:draft typingAttributes:typingAttributes];
    NSTextContainer *container = [[NSTextContainer alloc] init];
    AttachmentLayoutManager *layoutManager = [[AttachmentLayoutManager alloc] init];
    
    container.heightTracksTextView = YES;
    container.widthTracksTextView  = YES;
    [storage addLayoutManager:layoutManager];
    [layoutManager addTextContainer:container];
    
    RichTextView *textView = [[RichTextView alloc] initWithFrame:CGRectZero textContainer:container];
    textView.layoutManager.allowsNonContiguousLayout = NO;
    textView.typingAttributes = typingAttributes;
    return textView;
}

@end
