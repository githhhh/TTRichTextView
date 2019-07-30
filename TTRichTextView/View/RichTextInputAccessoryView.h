//
//  RichTextInputView.h
//  RichText
//
//  Created by bin on 2018/7/15.
//  Copyright © 2018年 me.test. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RichTextInputAccessoryView : UIView

@property (nonatomic,strong,readonly) UIButton *imgBtn;
@property (nonatomic,strong,readonly) UIButton *vedioBtn;
@property (nonatomic,strong,readonly) UIButton *tagBtn;

@property (nonatomic,strong,readonly) UIButton *audioBtn;
@property (nonatomic,strong,readonly) UIButton *anyBtn;
@property (nonatomic,strong,readonly) UIButton *bBtn;

@property (assign, nonatomic) NSInteger inputAccessoryViewHeight;

@property (assign, nonatomic) NSInteger maxTextLength;

@property (assign, nonatomic) NSInteger currentTextLength;


@end

NS_ASSUME_NONNULL_END
