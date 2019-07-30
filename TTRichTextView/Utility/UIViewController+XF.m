//
//  UIViewController+XF.m
//
//
//  Created by Bin on 2018/4/19.
//  Copyright © 2018年  bin. All rights reserved.
//

#import "UIViewController+XF.h"

@implementation UIViewController (XF)

+ (void)load
{
    [self swizzleInstanceSelector:@selector(viewDidLoad) withNewSelector:@selector(guide_viewDidLoad)];

    [self swizzleInstanceSelector:@selector(viewWillAppear:) withNewSelector:@selector(guide_viewWillApper:)];
}


#pragma mark - Hood Method

- (void)guide_viewDidLoad
{
    [self guide_viewDidLoad];
    
    BOOL isNeedTopNavView = NO;
    if ([self respondsToSelector:@selector(isNeedTopNavView)]) {
        isNeedTopNavView = [self isNeedTopNavView];
    }
    
    if (isNeedTopNavView) {
        [self setupTopNavViewCustom];
        [self setupTopNavViewConstraints];
    }
}


- (void)guide_viewWillApper:(BOOL)animated
{
    if ([self respondsToSelector:@selector(isNeedTopNavView)]) {
        NSLog(@"当前显示的VC的名称为：%@",NSStringFromClass(self.class));
        [[UIApplication sharedApplication].delegate performSelector:@selector(setViewController:) withObject:self];
    }
    
    [self guide_viewWillApper:animated];

    if ([self respondsToSelector:@selector(isNeedTopNavView)]) {
        [self.navigationController setNavigationBarHidden:[self isNeedTopNavView] animated:animated];
    }

   
}

#pragma mark - Private Method

- (void)setupTopNavViewCustom
{
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor blackColor];
    
    self.topNavView.backgroundColor = [UIColor whiteColor];
    self.lineView.backgroundColor   = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
}

- (void)setupTopNavViewConstraints
{
    CGFloat statusBarH  = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    self.lineView.frame = CGRectMake(0, CGRectGetHeight(self.topNavView.frame)  - 0.5,CGRectGetWidth(self.topNavView.frame) , 0.5);

    self.leftButton.frame = CGRectMake(0, CGRectGetMinY(self.topNavView.frame) + statusBarH , 45, CGRectGetHeight(self.topNavView.frame) - statusBarH - CGRectGetHeight(self.lineView.frame));

    self.titleLabel.frame = CGRectMake( CGRectGetMaxX(self.leftButton.frame) + 5,CGRectGetMinY(self.topNavView.frame) + statusBarH,  self.view.frame.size.width - 100, CGRectGetHeight(self.topNavView.frame)  - statusBarH - CGRectGetHeight(self.lineView.frame));
    
    self.rightButton.frame = CGRectMake( CGRectGetWidth(self.topNavView.frame)  - 45, CGRectGetMinY(self.leftButton.frame), 45, CGRectGetHeight( self.leftButton.frame));
    

        self.rightButton.layer.borderColor = [UIColor redColor].CGColor;
        self.rightButton.layer.borderWidth = 0.5f;
    
        self.leftButton.layer.borderColor = [UIColor redColor].CGColor;
        self.leftButton.layer.borderWidth = 0.5f;
    
        self.titleLabel.layer.borderColor = [UIColor redColor].CGColor;
        self.titleLabel.layer.borderWidth = 0.5f;
}

#pragma mark - UIViewControllerDelegate

- (CGFloat)topNavViewHeight
{
    return 44;
}

- (NSString *)leftButtonImageName
{
    return self.isPopup ? @"" : @"cf_login_backBtn2";
}

- (NSString *)rightButtonImageName
{
    return @"";
}

- (void)leftButtonClickedHandler
{
        if(self.navigationController.viewControllers.count>1){//如果当前栈缓存大于1个VC，则默认pop
        [self.navigationController popViewControllerAnimated:YES];
    }else{//否则dismiss回上一个级
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
