//
//  AnyViewTextAttachment.m
//   
//
//  Created by tbin on 2018/11/19.
//  Copyright © 2018  bin. All rights reserved.
//

#import "AnyViewTextAttachment.h"

@implementation AnyViewTextAttachment

- (void)dealloc{
    NSLog(@"~~~AnyViewTextAttachment~~~~dealloc~");
}

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex{
    return self.bounds;
}

@end
