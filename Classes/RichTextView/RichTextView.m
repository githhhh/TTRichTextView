//
//  RichTextView.m
//   
//
//  Created by tbin on 2018/7/19.
//  Copyright © 2018年  bin. All rights reserved.
//

#import "RichTextView.h"
#import "AttachmentGestureRecognizerDelegate.h"
#import "AttachmentLayoutManager.h"
#import "RichTextTools.h"
#import "MediaTextAttachment.h"
#import "NSLayoutManager+Attachment.h"
#import "NSTextStorage+Utils.h"
#import "NSObject+MJKeyValue.h"
#import "NSObject+MJKeyValue.h"

@interface RichTextView ()

@property (nonatomic,strong) UITapGestureRecognizer* attachmentGestureRecognizer;

@property (nonatomic,strong) AttachmentGestureRecognizerDelegate * recognizerDelegate;

@end

@implementation RichTextView

#pragma mark - init

+(instancetype)defaultRichTextView{
    NSTextContainer *container = [[NSTextContainer alloc] init];
    container.heightTracksTextView = YES;
    container.widthTracksTextView  = YES;

    NSTextStorage *storage = [[NSTextStorage alloc] init];
    AttachmentLayoutManager *layoutManager = [[AttachmentLayoutManager alloc] init];
    
    [storage addLayoutManager:layoutManager];
    [layoutManager addTextContainer:container];
    
    RichTextView *textView = [[RichTextView alloc] initWithFrame:CGRectZero textContainer:container];
    textView.layoutManager.allowsNonContiguousLayout = NO;
    return textView;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer{
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        /// 添加手势
        [self setupAttachmentTouchDetection];
        [self setupLayoutManager];
    }
    return self;
}

- (void)dealloc
{
    if ([self.textContainer.layoutManager isKindOfClass:[AttachmentLayoutManager class]]) {
        AttachmentLayoutManager *attLayoutManager = (AttachmentLayoutManager *)self.textContainer.layoutManager;
        [self removeObserver:attLayoutManager.attachmentsManager forKeyPath:@"contentOffset"];
        NSLog(@"RichTextView~~removeObserver:forKeyPath:~~~contentOffset");
    }
    NSLog(@"~~RichTextView~~~~dealloc");
}

#pragma mark - estimatedReusableViewHeight

- (void)setEstimatedReusableViewHeight:(CGFloat)estimatedReusableViewHeight{
    _estimatedReusableViewHeight = estimatedReusableViewHeight;
    if (![self.textContainer.layoutManager isKindOfClass:[AttachmentLayoutManager class]]) {
        return;
    }
    AttachmentLayoutManager *attLayoutManager = (AttachmentLayoutManager *)self.textContainer.layoutManager;
    attLayoutManager.attachmentsManager.estimatedReusableViewHeight = estimatedReusableViewHeight;
}

#pragma mark - register & dequeue

- (void)registerClass:(nullable Class)reusableViewClass forReusableViewWithIdentifier:(NSString *)identifier{
    if (![self.textContainer.layoutManager isKindOfClass:[AttachmentLayoutManager class]]) {
        return;
    }
    AttachmentLayoutManager *attLayoutManager = (AttachmentLayoutManager *)self.textContainer.layoutManager;
    [attLayoutManager.attachmentsManager registerReusableView:reusableViewClass reuseIdentifier:identifier];
}

- (TextAttachmentReusableView *)dequeueReusableAttachmentViewWithIdentifier:(NSString *)identifier{
    if (![self.textContainer.layoutManager isKindOfClass:[AttachmentLayoutManager class]]) {
        NSAssert([self.textContainer.layoutManager isKindOfClass:AttachmentLayoutManager.class], @"layoutManager must is AttachmentLayoutManager for dequeueReusableAttachmentViewWithIdentifier:");
        return nil;
    }
    AttachmentLayoutManager *attLayoutManager = (AttachmentLayoutManager *)self.textContainer.layoutManager;
    return [attLayoutManager.attachmentsManager dequeueReusableAttachmentView:identifier];
}

#pragma mark - setup

- (void)setupAttachmentTouchDetection{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        [gesture requireGestureRecognizerToFail:self.attachmentGestureRecognizer];
    }
    [self addGestureRecognizer:self.attachmentGestureRecognizer];
}

- (void)setupLayoutManager{
    if (![self.textContainer.layoutManager isKindOfClass:[AttachmentLayoutManager class]]) {
        return;
    }
    /// init TextAttachmentsManager
    TextAttachmentsManager *attachmentsManager = [TextAttachmentsManager attachmentsManagerFor:self];
    /// config AttachmentLayoutManager
    AttachmentLayoutManager *anyViewLayoutManager = (AttachmentLayoutManager *)self.textContainer.layoutManager;
    anyViewLayoutManager.attachmentsManager = attachmentsManager;
}

#pragma mark - override

- (void)paste:(id)sender{
    if (UIPasteboard.generalPasteboard.string.length == 0) {
        [super paste:sender];
        return;
    }
    NSString *contentStr = UIPasteboard.generalPasteboard.string;
    NSMutableAttributedString *pasteAttrString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    pasteAttrString = [self attributedStringForAttachmentJSON:pasteAttrString];
    [self.typingAttributes enumerateKeysAndObjectsUsingBlock:^(NSAttributedStringKey  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [pasteAttrString addAttribute:key value:obj range:NSMakeRange(0, pasteAttrString.length)];
    }];
    
    [self.textStorage replaceCharactersInRange:self.selectedRange withAttributedString:pasteAttrString];
    UITextPosition *end = [self positionFromPosition:self.selectedTextRange.start offset:pasteAttrString.length];
    self.selectedTextRange = [self textRangeFromPosition:end toPosition:end];
    [self.layoutManager invalidateDisplayForCharacterRange:self.selectedRange];
}

- (void)copy:(id)sender{
    NSString *result = [self convertSelectedRangeToString];
    if (result.length > 0) {
        [super copy:sender];
        UIPasteboard *defaultPasteboard = [UIPasteboard generalPasteboard];
        [defaultPasteboard setString:result];
        return;
    }
    [super copy:sender];
}

- (void)cut:(id)sender{
    NSString *result = [self convertSelectedRangeToString];
    if (result.length > 0) {
        [super cut:sender];
        UIPasteboard *defaultPasteboard = [UIPasteboard generalPasteboard];
        [defaultPasteboard setString:result];
        return;
    }
    [super cut:sender];
}

- (void)deleteBackward{
    if (!(self.selectedRange.location > 0 || self.selectedRange.length > 0)) {
        return;
    }

    if (![self.textContainer.layoutManager isKindOfClass:[AttachmentLayoutManager class]]) {
        [super deleteBackward];
        return;
    }
    
    AttachmentLayoutManager *anyViewLayoutManager = (AttachmentLayoutManager *)self.textContainer.layoutManager;
    NSRange range = self.selectedRange;
    if (range.length == 0) {
        NSInteger loc = (range.location - 1 < 0) ? 0 : (range.location - 1);
        range = NSMakeRange(loc, 1);
    }
    NSArray<NSTextAttachment *> *attachments = [self viewAttachments:range];
    for (NSTextAttachment *att in attachments) {
        if ([att isKindOfClass:[AnyViewTextAttachment class]]) {
            TextAttachmentReusableView * reusableView = [anyViewLayoutManager.attachmentsManager reusableViewInTableFor:(AnyViewTextAttachment *)att];
            [reusableView removeFromSuperview];
            [anyViewLayoutManager.attachmentsManager removeAttachmentFromMapTable:(AnyViewTextAttachment *)att];
        }
    }
    [self.textStorage setAttributes:nil range:range];
    [self.layoutManager invalidateDisplayForCharacterRange:range];
    [super deleteBackward];
}

/// 调整光标高度
//- (CGRect)caretRectForPosition:(UITextPosition *)position{
//    CGRect rect = [super caretRectForPosition:position];
//    if (self.font == nil) {
//        return rect;
//    }
//    CGFloat newHeight = self.font.pointSize - self.font.descender;
//    CGFloat newY = rect.origin.y + rect.size.height - newHeight;
//    rect.size.height = newHeight;
//    rect.origin.y = newY;
//    return rect;
//}

#pragma mark - Private

- (NSString *)convertSelectedRangeToString{
    NSMutableString *result = [[NSMutableString alloc]initWithCapacity:0];
    NSRange selectedRange = self.selectedRange;
    NSRange effectiveRange = NSMakeRange(selectedRange.location,0);
    NSUInteger length = NSMaxRange(selectedRange);
    while (NSMaxRange(effectiveRange) < length) {
        NSTextAttachment *attachment = [self.attributedText attribute:NSAttachmentAttributeName atIndex:NSMaxRange(effectiveRange) effectiveRange:&effectiveRange];
        if(attachment){
            NSString *attachmentJSON = [self copyAttachmentToJSON:attachment];
            if (attachmentJSON) {
                [result appendString:attachmentJSON];
            }
        }else{
            NSString *subStr = [self.text substringWithRange:effectiveRange];
            [result appendString:subStr];
        }
    }
    return [result copy];
}

/// <Attachment>JSON</Attachment> 标记
- (NSString *)copyAttachmentToJSON:(NSTextAttachment *)attachment{
    if (![self.textContainer.layoutManager isKindOfClass:[AttachmentLayoutManager class]]) {
        return nil;
    }
    AttachmentLayoutManager *anyViewLayoutManager = (AttachmentLayoutManager *)self.textContainer.layoutManager;
    NSRange selectedRange = self.selectedRange;
    if(![attachment isKindOfClass:[MediaTextAttachment class]]){
        return nil;
    }
    TextAttachmentReusableView * reusableView = [anyViewLayoutManager.attachmentsManager reusableViewInTableFor:(AnyViewTextAttachment *)attachment];
    [reusableView removeFromSuperview];
    [anyViewLayoutManager.attachmentsManager removeAttachmentFromMapTable:(AnyViewTextAttachment *)attachment];
    [self.layoutManager invalidateDisplayForCharacterRange:selectedRange];
    
    DraftAttachmentDataModel *draftAttachmentModel  = [(MediaTextAttachment *)attachment attachmentDraftMetaData];
    if (draftAttachmentModel) {
        NSDictionary *dic = [draftAttachmentModel mj_keyValuesWithIgnoredKeys:nil];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        NSString * jsonString =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (jsonString) {
            jsonString = [NSString stringWithFormat:@"%@%@%@",@"<Attachment>",jsonString,@"</Attachment>"];
            return jsonString;
        }
    }
    
    return nil;
}

/// 解析<Attachment>JSON</Attachment>标记
- (NSMutableAttributedString *)attributedStringForAttachmentJSON:(NSMutableAttributedString *)pasteAttrString{
    if (!pasteAttrString) {
        return nil;
    }
    NSRegularExpression *kTopicExp = [NSRegularExpression regularExpressionWithPattern:kHtmlExpression(@"Attachment") options:NSRegularExpressionCaseInsensitive error:nil];
    [kTopicExp enumerateMatchesInString:pasteAttrString.string  options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, pasteAttrString.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (!result) return;
        
        NSString *matchStr = [pasteAttrString.string substringWithRange:result.range];
        matchStr = [matchStr stringByReplacingOccurrencesOfString:@"<Attachment>" withString:@""];
        matchStr = [matchStr stringByReplacingOccurrencesOfString:@"</Attachment>" withString:@""];
        DraftAttachmentDataModel *draftAttachmentModel  =  [DraftAttachmentDataModel mj_objectWithKeyValues:matchStr];
        if (draftAttachmentModel) {
            NSTextAttachment *attachment = [MediaTextAttachment attachmentForMetaData:draftAttachmentModel];
            NSMutableAttributedString *insertion = [NSTextStorage attributedStringForAttachment:attachment typingAttributes:self.typingAttributes];
            [pasteAttrString replaceCharactersInRange:result.range withAttributedString:insertion];
        }
    }];
    
    return pasteAttrString;
}

#pragma mark - Geter & Setter

- (UITapGestureRecognizer *)attachmentGestureRecognizer{
    if (!_attachmentGestureRecognizer) {
        _attachmentGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        _attachmentGestureRecognizer.cancelsTouchesInView = YES;
        _attachmentGestureRecognizer.delaysTouchesBegan = YES;
        _attachmentGestureRecognizer.delaysTouchesEnded = YES;
        _attachmentGestureRecognizer.delegate = self.recognizerDelegate;
        [_attachmentGestureRecognizer addTarget:self.recognizerDelegate action:@selector(richTextViewWasPressed:)];
    }
    return _attachmentGestureRecognizer;
}

- (AttachmentGestureRecognizerDelegate *)recognizerDelegate{
    if (!_recognizerDelegate) {
        _recognizerDelegate = [[AttachmentGestureRecognizerDelegate alloc] init];
        _recognizerDelegate.textView = self;
    }
    return _recognizerDelegate;
}

@end
