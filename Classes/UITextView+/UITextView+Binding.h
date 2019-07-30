//
//  UITextView+Binding.h
//   
//
//  Created by tbin on 2018/11/21.
//  Copyright © 2018  bin. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * _Nullable const NSAttributedStringBindingKey = @"Tag_Custom";
static NSString * _Nullable const NSAttributedStringHighlightingKey = @"Highlighting_Custom";
/// 需要追加一个空格
#define AttributedStringBindingText(text) ([NSString stringWithFormat:@"%@ ", text])

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Binding)

/**
 对指定range内容绑定，和高亮
 
 NSString *bindText = AttributedStringBindingText(newTopicName);
 [textView insertText:bindText];
 ///根据当前光标位置判断位置 带空额 绑定文本后面带有空格
 NSRange tnRange =  NSMakeRange(textView.selectedRange.location - bindText.length, bindText.length - 1);
 [textView addBindingAttributeInRange:tnRange highlightingColor:color];

 @param range range description
 @param color color description
 */
- (void)addBindingAttributeInRange:(NSRange)range highlightingColor:(UIColor *)color;

/**
 指定NSAttributedStringKey 中不允许光标插入。只能选中整体。
 - (void)textViewDidChangeSelection:(UITextView *)textView {
     [textView bindSelectRange:NSAttributedStringBindingKey textViewDelegate:self];
 }

 @param attrKey 指定key 如 NSAttributedStringBindingKey
 @param textViewDelegate textViewDelegate description
 */
- (void)bindSelectRange:(NSAttributedStringKey )attrKey textViewDelegate:(id<UITextViewDelegate>)textViewDelegate;

/**
 是否绑定删除 指定的NSAttributedStringKey
 - (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
     if ( [textView  bindDelete:NSAttributedStringBindingKey inRange:range] == NO ) {
         if ([textView.delegate respondsToSelector:@selector(textViewDidChange:)]) {
             [textView.delegate textViewDidChange:textView];
         }
         return NO;
     }
     return YES;
 }
 中调用

 @param attrKey 如：NSAttributedStringBindingKey
 @param inRange inRange description
 @return return 是否命中绑定Key
 */
- (BOOL)bindDelete:(NSAttributedStringKey )attrKey inRange:(NSRange)inRange;

@end

NS_ASSUME_NONNULL_END
