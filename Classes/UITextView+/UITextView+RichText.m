//
//  UITextView+RichText.m
//   
//
//  Created by tbin on 2018/11/23.
//  Copyright © 2018  bin. All rights reserved.
//

#import "UITextView+RichText.h"
#import "NSTextStorage+Utils.h"

@implementation UITextView (RichText)

#pragma mark - Style

- (void)removeBold{
    [self.textStorage removeAttributeFor:@[NSFontAttributeName] range:self.selectedRange typingAttributes:self.typingAttributes];
}

- (void)removeUnderline{
    [self.textStorage removeAttributeFor:@[NSUnderlineStyleAttributeName,NSUnderlineColorAttributeName] range:self.selectedRange typingAttributes:self.typingAttributes];
}

- (void)removeObliqueness{
    [self.textStorage removeAttributeFor:@[NSObliquenessAttributeName] range:self.selectedRange typingAttributes:self.typingAttributes];
}


@end
