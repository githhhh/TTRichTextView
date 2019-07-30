//
//  NSTextStorage+Utils.h
//   
//
//  Created by tbin on 2018/11/27.
//  Copyright © 2018  bin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTextStorage (Utils)

+ (NSMutableAttributedString *)attributedStringForAttachment:(NSTextAttachment *)attachment typingAttributes:(NSDictionary<NSAttributedStringKey, id> *)typingAttributes;


- (void)removeAttributeFor:(NSArray<NSAttributedStringKey> *)keys range:(NSRange)range typingAttributes:(NSDictionary<NSAttributedStringKey, id> *)typingAttributes;

@end

NS_ASSUME_NONNULL_END
