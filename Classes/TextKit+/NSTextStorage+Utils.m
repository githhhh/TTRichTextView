//
//  NSTextStorage+Utils.m
//   
//
//  Created by tbin on 2018/11/27.
//  Copyright © 2018  bin. All rights reserved.
//

#import "NSTextStorage+Utils.h"

@implementation NSTextStorage (Utils)

+ (NSMutableAttributedString *)attributedStringForAttachment:(NSTextAttachment *)attachment typingAttributes:(NSDictionary<NSAttributedStringKey, id> *)typingAttributes{
    NSAttributedString * attachmentString = [NSAttributedString  attributedStringWithAttachment:attachment];
    NSMutableAttributedString* separatorString = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    NSMutableAttributedString* insertion = [[NSMutableAttributedString alloc] init];
    
    [typingAttributes enumerateKeysAndObjectsUsingBlock:^(NSAttributedStringKey  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [separatorString addAttribute:key value:obj range:NSMakeRange(0, separatorString.length)];
        [insertion addAttribute:key value:obj range:NSMakeRange(0, insertion.length)];
    }];
    
    [insertion appendAttributedString:separatorString];
    [insertion appendAttributedString:attachmentString];
    [insertion appendAttributedString:separatorString];
    return insertion;
}


#pragma mark - toggle Style

- (void)removeAttributeFor:(NSArray<NSAttributedStringKey> *)keys range:(NSRange)range typingAttributes:(NSDictionary<NSAttributedStringKey, id> *)typingAttributes{
    if (range.location == NSNotFound || range.location + range.length > self.length) {
        return;
    }
    [self beginEditing];
    
    for (NSAttributedStringKey key in keys) {
        [self removeAttribute:key range:range];
        if ([key isEqualToString:NSFontAttributeName]) {
            if ([typingAttributes.allKeys containsObject:NSFontAttributeName] ) {
                [self addAttribute:NSFontAttributeName value:typingAttributes[NSFontAttributeName] range:range];
            }else{
                [self addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[UIFont systemFontSize]] range:range];
            }
        }
    }
    
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

@end
