//
//  RichTextView.h
//   
//
//  Created by tbin on 2018/7/19.
//  Copyright © 2018年  bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSTextStorage+ProcessEditing.h"
#import "UITextView+Binding.h"
#import "UITextView+TextAttachmentUtils.h"
#import "TextViewAttachmentDelegate.h"

@interface RichTextView : UITextView

+(instancetype _Nullable )defaultRichTextView;

@property (nonatomic,assign) CGFloat estimatedReusableViewHeight;

@property (nonatomic,weak)id<TextViewAttachmentDelegate> _Nullable attachmentDelegate;

/// 注册重用View
- (void)registerClass:(nullable Class)reusableViewClass forReusableViewWithIdentifier:(NSString *_Nullable)identifier;

/// 获取重用view
- (TextAttachmentReusableView *_Nullable)dequeueReusableAttachmentViewWithIdentifier:(NSString *_Nullable)identifier;
@end
