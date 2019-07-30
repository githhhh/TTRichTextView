//
//  UIViewController+Base.h
//
//
//  Created by tbin on 2018/8/13.
//  Copyright © 2018年 ThinkFly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+Swizzle.h"

@protocol UIViewControllerDelegate <NSObject>

@optional

/**
 *  是否需要顶部导航栏
 *
 */
- (BOOL)isNeedTopNavView;


/**
 *  顶部导航栏的高度
 *
 */
- (CGFloat)topNavViewHeight;

/**
 *  左侧按钮的图片名称
 *
 *  @return 图片名称
 */
- (NSString *)leftButtonImageName;

/**
 *  右侧按钮的图片名称
 *
 *  @return 图片名称
 */
- (NSString *)rightButtonImageName;

/**
 *  右侧按钮的图片名称
 *
 *  @return 图片名称
 */
- (NSString *)rightButtonTitle;

/**
 *  导航栏左侧按钮点击触发的方法
 */
- (void)leftButtonClickedHandler;

/**
 *  导航栏右侧按钮点击触发的方法
 */
- (void)rightButtonClickedHandler;

@end

@interface UIViewController (Base)

/**
 *  导航栏视图
 */
@property (strong, nonatomic) UIView   *topNavView;

/**
 *  主视图
 */
@property (strong, nonatomic) UIView   *contentView;

/**
 *  导航栏左侧按钮
 */
@property (strong, nonatomic) UIButton *leftButton;

/**
 *  导航栏预测按钮
 */
@property (strong, nonatomic) UIButton *rightButton;

/**
 *  标题Label
 */
@property (strong, nonatomic) UILabel  *titleLabel;

/**
 *  导航栏和主视图分割线
 */
@property (strong, nonatomic) UIView   *lineView;

/**
 *  当前视图是否是POPUP形式
 */
@property (assign, nonatomic) BOOL     isPopup;


@end
