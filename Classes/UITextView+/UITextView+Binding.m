//
//  UITextView+Binding.m
//   
//
//  Created by tbin on 2018/11/21.
//  Copyright © 2018  bin. All rights reserved.
//

#import "UITextView+Binding.h"

@implementation UITextView (Binding)

#pragma mark - Binding

- (void)addBindingAttributeInRange:(NSRange)range highlightingColor:(UIColor *)color{
    [self.textStorage addAttribute:NSAttributedStringHighlightingKey value:@"You_Want_Somthing" range:range];
    [self.textStorage addAttribute:NSAttributedStringBindingKey value:@"You_Want_Somthing" range:range];
    [self.textStorage addAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)bindSelectRange:(NSAttributedStringKey )attrKey textViewDelegate:(id<UITextViewDelegate>)textViewDelegate{
    UITextRange * selectedTextRange = self.selectedTextRange;
    if (selectedTextRange == nil){
        return;
    }
    
    [self.textStorage enumerateAttribute:attrKey inRange:NSMakeRange(0, self.textStorage.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value == nil) {
            return ;
        }
        
        UITextPosition *start = [self positionFromPosition:self.beginningOfDocument offset:range.location];
        if (start == nil){
            return;
        }
        //        UITextPosition *end = [self positionFromPosition:start offset:range.length];
        /// 绑定内容后追加的空格长度
        UITextPosition *end = [self positionFromPosition:start offset:range.length + 1];
        if (end == nil){
            return;
        }
        
        UITextPosition *harf = [self positionFromPosition:start offset:range.length/2];
        if (harf == nil){
            return;
        }
        
        /// 处理选中
        if ( [self offsetFromPosition:selectedTextRange.start toPosition:selectedTextRange.end] > 0){
            UITextPosition * shouldEnd = selectedTextRange.end;
            UITextPosition * shouldStart = selectedTextRange.start;
            
            /// 结束点在当前范围内 >= start && < end
            if( ([self comparePosition:selectedTextRange.end toPosition:start] == NSOrderedDescending || [self comparePosition:selectedTextRange.end toPosition:start] == NSOrderedSame)
               &&  [self comparePosition:selectedTextRange.end toPosition:end] == NSOrderedAscending) {
                shouldEnd = end;
            }
            
            /// 开始点在当前范围内 > start && <= end
            if ( [self comparePosition:selectedTextRange.start toPosition:start] == NSOrderedDescending
                && ( [self comparePosition:selectedTextRange.start toPosition:end] ==  NSOrderedAscending || [self comparePosition:selectedTextRange.start toPosition:end] ==  NSOrderedSame)){
                shouldStart = start;
            }
            
            if ( [self comparePosition:selectedTextRange.start toPosition:shouldStart] != NSOrderedSame ||
                [self comparePosition:selectedTextRange.end toPosition:shouldEnd] != NSOrderedSame ){
                self.delegate = nil; /// 打破循环调用 mmp
                self.selectedTextRange = [self textRangeFromPosition:shouldStart toPosition:shouldEnd];
                self.delegate = textViewDelegate;
            }
            return;
        }
        
        /// 是否在当前区域
        BOOL isArea = ([self comparePosition:selectedTextRange.start toPosition:start] == NSOrderedDescending
                       || [self comparePosition:selectedTextRange.start toPosition:start] == NSOrderedSame)
        && ( [self comparePosition:selectedTextRange.start toPosition:end] == NSOrderedAscending
            || [self comparePosition:selectedTextRange.start toPosition:end] == NSOrderedSame );
        
        if (isArea){
            /// 重置光标
            if ([self comparePosition:selectedTextRange.start toPosition:harf] == NSOrderedAscending ||
                [self comparePosition:selectedTextRange.start toPosition:harf] == NSOrderedSame )  {
                /// 位于左边
                self.delegate = nil; /// 打破循环调用 mmp
                self.selectedTextRange = [self textRangeFromPosition:start toPosition:start];
                self.delegate = textViewDelegate;
            }else {
                /// 位于右边
                self.delegate = nil;
                self.selectedTextRange = [self textRangeFromPosition:end toPosition:end];
                self.delegate = textViewDelegate;
            }
        }
        
    }];
}

/// 绑定删除 对指定的key
- (BOOL)bindDelete:(NSAttributedStringKey )attrKey inRange:(NSRange)inRange{
    
    if (inRange.location > self.textStorage.length ){
        return YES;
    }
    __block BOOL shouldReplace = false;
    __block NSRange currentReplacementRange = inRange;
    
    [self.textStorage enumerateAttribute:attrKey inRange:NSMakeRange(0, self.textStorage.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value == nil){
            return ;
        }
        ///  处理边界情况
        ///  inRange.location ==  (attrRange.location + attrRange.length)
        ///  #a# #b#  --->  #a##b#
        ///  删除中间空格, 会被识别成一个整体（相同的富文本key），判断光标位置等于 #a#结束位置就要绑定删除了。
        ///
        BOOL isReturn = inRange.location > range.location && ( NSLocationInRange(inRange.location, range) == YES || inRange.location ==  (range.location + range.length) );
        //        BOOL isReturn = inRange.location > range.location && ( NSLocationInRange(inRange.location, range) == YES);
        if (!isReturn){
            return;
        }
        
        currentReplacementRange = range;
        shouldReplace = YES;
    }];
    
    if (shouldReplace) {
        
        [self.textStorage removeAttribute:attrKey range:currentReplacementRange];
        //        [self.textStorage replaceCharactersInRange:currentReplacementRange withString:@""];
        ///删除内容后的空格
        [self.textStorage replaceCharactersInRange:NSMakeRange(currentReplacementRange.location, currentReplacementRange.length + 1) withString:@""];
        
        // set the cursor position to the end of the edited location
        UITextPosition *cursorPosition = [self positionFromPosition:self.beginningOfDocument offset:currentReplacementRange.location];
        if (cursorPosition != nil){
            self.selectedTextRange = [self textRangeFromPosition:cursorPosition toPosition:cursorPosition];
        }
        
        return NO;
    }
    
    return YES;
}

@end
