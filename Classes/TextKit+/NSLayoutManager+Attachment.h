//
//  NSLayoutManager+Attachment.h
//  RichText
//
//  Created by tbin on 2018/7/16.
//  Copyright © 2018年 me.test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutManager (Attachment)

-(void)setNeedsLayout:(NSTextAttachment *)attachment;

-(void)setNeedsDisplay:(NSTextAttachment *)attachment;

@end
