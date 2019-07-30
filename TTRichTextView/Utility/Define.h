//
//  Define.h
//
//
//  Created by tbin on 2018/9/25.
//  Copyright © 2018年 bin. All rights reserved.
//

#ifndef Define_h
#define Define_h

#pragma mark - Frame

/// 屏幕的宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
/// 屏幕的高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

/// 状态栏高度，非刘海屏20，刘海屏44, 注：状态栏隐藏返回为0
#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

/// 导航栏高度，非刘海屏64，刘海屏88
#define TopBarHeight (StatusBarHeight + 44)

/// 底部按钮距离高度
#define iPhoneXSafeAreaBottom ( [UIApplication sharedApplication].statusBarFrame.size.height > 20 ? 34 : 0 )

/// 以iPhone6为标准，宽、高度自适应
#define AutoSize(x) (x) *(ScreenWidth/375.0)
#define AutoSizeRectMake(x,y,width,height) CGRectMake(AutoSize(x),AutoSize(y),AutoSize(width),AutoSize(height)
#define AutoSizeSizeMake(width,height) CGSizeMake(AutoSize(width),AutoSize(height))
#define AutoSizePointMake(x,y) CGPointMake(AutoSize(x),AutoSize(y))

/// 宽度的倍率(苹果6)
#define WidthScale ScreenWidth/375.0
/// 高度的倍率(苹果6)
#define HeightScale ScreenHeight/667.0

#define FontSize(size) ([UIFont systemFontOfSize:size])

#pragma mark - Color
#define RGBColor(r,g,b) RGBColorAlpha(r,g,b,1)
#define RGBColorSame(x) RGBColorAlpha(x,x,x,1)
#define RGBColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define HexColor(x) HexColorWithAlpha(x, 1)
#define HexColorWithAlpha(x, a) [UIColor colorWithRed:((float)((x & 0xFF0000) >> 16))/255.0 green:((float)((x & 0xFF00) >> 8))/255.0 blue:((float)(x & 0xFF))/255.0 alpha:(a)]

#define Text_blackColor HexColor(0x333333)
#define Text_title_blackColor HexColor(0x161418)
#define Text_grayColor [[UIColor blackColor] colorWithAlphaComponent:0.4]
#define Text_orangeColor HexColor(0xfd882b)
#define Text_gameGrayColor HexColor(0x999999)
#define Text_textGrayColor HexColor(0x7f7f7f)



#pragma mark - Font
#define FontSize(f) [UIFont systemFontOfSize:AutoSize(f)]
#define BoldFont(f) [UIFont boldSystemFontOfSize:AutoSize(f)]



#pragma mark - Version
//iOS系统版本
#define SystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
//app版本（用户可见）
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//app build版本
#define AppBuildVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//app名称
#define AppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
//语言
#define AppLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])



#pragma mark - Path
#define DocumentPath           [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define LibraryPath            [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define CachesPath             [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]



#pragma mark - Device
/// 是否刘海屏。查了一下iPhone的官方报道说法，看到这么一个词：iPhoneX notch槽口，刻痕的意思。
#define IsiPhoneNotch (StatusBarHeight == 44 ? YES : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断iphone6+
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断iPhoneX
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)



#pragma mark - 自定义
/// WeakSelf
#define WeakSelf WeakObj(self)
#define WeakObj(type) __weak typeof(type) weak##type = type;

/// strong WeakSelf
#define StrongSelf StrongObj(self)
#define StrongObj(type) __strong typeof(type) type = weak##type;


#endif /* Define_h */
