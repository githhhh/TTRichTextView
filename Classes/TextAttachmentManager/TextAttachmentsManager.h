//
//  AnyViewTextAttachmentsManager.h
//   
//
//  Created by tbin on 2018/11/19.
//  Copyright © 2018  bin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RichTextView.h"
#import "AnyViewTextAttachment.h"
#import "TextAttachmentReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TextAttachmentsManager : NSObject

@property (nonatomic,assign) CGFloat estimatedReusableViewHeight;

@property (nonatomic,weak,readonly) RichTextView *textView;

+ (instancetype)attachmentsManagerFor:(RichTextView *)textView;

/// ReusableView
- (void)registerReusableView:(Class)viewCls reuseIdentifier:(NSString *)identifier;
- (TextAttachmentReusableView *)dequeueReusableAttachmentView:(NSString *)identifier;
- (TextAttachmentReusableView *)reusableViewForAttachment:(AnyViewTextAttachment *)attachment;

/// InMapTable
- (NSArray<AnyViewTextAttachment *> *)anyViewAttachmentsInTable;
- (TextAttachmentReusableView *)reusableViewInTableFor:(AnyViewTextAttachment *)anyViewAttachment;
- (void)removeAttachmentFromMapTable:(AnyViewTextAttachment *)anyViewAttment;

@end

NS_ASSUME_NONNULL_END
