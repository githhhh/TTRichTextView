//
//  UIViewController+Base.m
//  
//
//  Created by tbin on 2018/8/13.
//  Copyright © 2018年  bin. All rights reserved.
//

#import "UIViewController+Base.h"
#import <objc/runtime.h>

static char const * const kTopNavView      = "topNavView";
static char const * const kContentView     = "contentView";
static char const * const kLeftButton      = "LeftButton";
static char const * const kRightbutton     = "rightButton";
static char const * const kTitleLabel      = "titleLabel";
static char const * const kLineView        = "lineView";
static char const * const kIsPopup         = "isPopup";
static char const * const kChildDelegate   = "ChildDelegate";

@interface UIViewController ()

@property (weak, nonatomic) id childDelegate;

@end

@implementation UIViewController (Base)

- (instancetype)init_base
{
    self = [self init_base];
    if (self) {
        
        self.childDelegate = self;
        
    }
    return self;
}

#pragma mark - Hook

- (void)base_viewDidLoad
{
    BOOL isNeedTopNavView = NO;
    if ([self.childDelegate respondsToSelector:@selector(isNeedTopNavView)]) {
        isNeedTopNavView = [self.childDelegate isNeedTopNavView];
    }
    
    if (isNeedTopNavView) {
        
        [self setupTopNavView];
        
        [self setupContentView];
        
        [self setupLeftButton];
        
        [self setupTitleLabel];
        
        [self setupRightButton];
        
        [self setupLineView];
        
    }
    
    [self base_viewDidLoad];
}

#pragma mark - Button Click Event

- (void)leftButtonClicked:(UIButton *)button
{
    if ([self.childDelegate respondsToSelector:@selector(leftButtonClickedHandler)]) {
        [self.childDelegate leftButtonClickedHandler];
    }
}

- (void)rightButtonClicked:(UIButton *)button
{
    if ([self.childDelegate respondsToSelector:@selector(rightButtonClickedHandler)]) {
        [self.childDelegate rightButtonClickedHandler];
    }
}

#pragma mark - SetupSubviews Method

- (void)setupTopNavView
{
    CGFloat topNavViewHeight = 0;
    
    if ([self.childDelegate respondsToSelector:@selector(topNavViewHeight)]) {
        topNavViewHeight = [self.childDelegate topNavViewHeight];
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat statusBarH  = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat height = statusBarH + topNavViewHeight;
    
    UIView *topNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    topNavView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topNavView];
    
    self.topNavView = topNavView;
}

- (void)setupContentView
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat topNavViewHeight = self.topNavView.bounds.size.height;
//    CGFloat safeAreaBottom  = [UIApplication sharedApplication].statusBarFrame.size.height > 20 ? 34 : 0 ;
    CGFloat height = [UIScreen mainScreen].bounds.size.height - topNavViewHeight;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, topNavViewHeight, width, height)];
    contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentView];
    
    self.contentView = contentView;
}

- (void)setupLeftButton
{
    NSString *leftButtonImageName = @"";
    
    if ([self.childDelegate respondsToSelector:@selector(leftButtonImageName)]) {
        leftButtonImageName = [self.childDelegate leftButtonImageName];
    }
    
    UIImage *leftButtonImage = [UIImage imageNamed:leftButtonImageName];
    
    if (!leftButtonImage) {
        return;
    }
    
    CGFloat width = leftButtonImage.size.width;
    CGFloat height = leftButtonImage.size.height;
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat y = (self.topNavView.bounds.size.height - statusBarHeight - height) / 2 + statusBarHeight;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, y, width, height)];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:leftButtonImage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.topNavView addSubview:leftButton];
    
    self.leftButton = leftButton;
}

- (void)setupRightButton
{
    NSString *rightButtonImageName = @"";
    
    if ([self.childDelegate respondsToSelector:@selector(rightButtonImageName)]) {
        rightButtonImageName = [self.childDelegate rightButtonImageName];
    }
    
    UIImage *rightButtonImage = [UIImage imageNamed:rightButtonImageName];
    
    if (!rightButtonImage) {
        return;
    }
    
    CGFloat width = 30;
    CGFloat height = 30;
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat y = (self.topNavView.bounds.size.height - statusBarHeight - height) / 2 + statusBarHeight;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat x = screenWidth - width;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setImage:rightButtonImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.topNavView addSubview:rightButton];
    
    self.rightButton = rightButton;
}

- (void)setupTitleLabel
{
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat x = self.leftButton.bounds.size.width + 10;
    CGFloat y = statusBarHeight;
    CGFloat width = screenWidth - x * 2;
    CGFloat height = self.topNavView.bounds.size.height - statusBarHeight;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.topNavView addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
}

- (void)setupLineView
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 0.5;
    CGFloat x = 0;
    CGFloat y = self.topNavView.bounds.size.height - height;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    lineView.backgroundColor = [UIColor clearColor];
    [self.topNavView addSubview:lineView];
    
    self.lineView = lineView;
}


#pragma mark - Swizzle Method

+ (void)load {
    [self swizzleInstanceSelector:@selector(viewDidLoad) withNewSelector:@selector(base_viewDidLoad)];
    [self swizzleInstanceSelector:@selector(init) withNewSelector:@selector(init_base)];
}

#pragma mark - Setter Method

- (void)setTopNavView:(UIView *)topNavView
{
    if (topNavView != self.topNavView) {
        objc_setAssociatedObject(self, &kTopNavView, topNavView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setContentView:(UIView *)contentView
{
    if (contentView != self.contentView) {
        objc_setAssociatedObject(self, &kContentView, contentView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setLeftButton:(UIButton *)leftButton
{
    if (leftButton != self.leftButton) {
        objc_setAssociatedObject(self, &kLeftButton, leftButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setRightButton:(UIButton *)rightButton
{
    if (rightButton != self.rightButton) {
        objc_setAssociatedObject(self, &kRightbutton, rightButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setTitleLabel:(UILabel *)titleLabel
{
    if (titleLabel != self.titleLabel) {
        objc_setAssociatedObject(self, &kTitleLabel, titleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setLineView:(UIView *)lineView
{
    if (lineView != self.lineView) {
        objc_setAssociatedObject(self, &kLineView, lineView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setIsPopup:(BOOL)isPopup
{
    objc_setAssociatedObject(self, &kIsPopup, @(isPopup), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setChildDelegate:(id)childDelegate
{
    if (![childDelegate isEqual:self.childDelegate]) {
        objc_setAssociatedObject(self, &kChildDelegate, childDelegate, OBJC_ASSOCIATION_ASSIGN);
    }
}


#pragma mark - Getter Method

- (UIView *)topNavView
{
    return objc_getAssociatedObject(self, &kTopNavView);
}

- (UIView *)contentView
{
    return objc_getAssociatedObject(self, &kContentView);
}

- (UIButton *)leftButton
{
    return objc_getAssociatedObject(self, &kLeftButton);
}

- (UIButton *)rightButton
{
    return objc_getAssociatedObject(self, &kRightbutton);
}

- (UILabel *)titleLabel
{
    return objc_getAssociatedObject(self, &kTitleLabel);
}

- (UIView *)lineView
{
    return objc_getAssociatedObject(self, &kLineView);
}

- (BOOL)isPopup
{
    return [objc_getAssociatedObject(self, &kIsPopup) boolValue];
}

- (id)childDelegate
{
    return objc_getAssociatedObject(self, &kChildDelegate);
}

@end
