//
//  MediaCompressTool.h
//  RichText
//
//  Created by tbin on 2018/7/17.
//  Copyright © 2018年 me.test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "UIImage+Utils.h"

typedef NS_ENUM(NSUInteger,XFCheckVideoResult){
    XFCheckVideoUndefined = 0,
    /// 格式错误
    XFVideoUnavailableFormat ,
    /// 视频太大
    XFVideoSizeTooBig,
    /// 视频时长太短
    XFVideoDurationTooShort,
};

// 500M
static NSUInteger videoMaxSize = 500;
// 5s
static NSUInteger videoMinDuration = 5;

@interface MediaCompressTool : NSObject

/// 压缩图片到 1M
+ (NSData *_Nullable)compressImage:(NSData *_Nonnull)imgData;

/// 压缩视频进度
+ (void)compressVideo:(PHAsset *_Nonnull)asset
           completion:(void(^_Nullable)(NSURL * _Nullable videoDiskPath))completion
             progress:(void(^_Nullable)(AVAssetExportSession * _Nullable exportSession))progressCallback;

/// 检查视频格式、大小、时长
+ (void)checkVideo:(PHAsset *_Nullable)asset
       unavailable:(void(^_Nullable)(NSString * _Nullable errormsg,NSString * _Nullable info,XFCheckVideoResult type))unavailable
         available:(void(^_Nullable)(float duration,long long dataLength,NSString * _Nullable format))available;

/// 合成 视频附件 封图（带播放icon）
+ (void)handleVideoAttachment:(UIImage *_Nullable)orgImg
                       resize:(CGSize)resize
                     complate:(void(^_Nullable)(UIImage * _Nullable resizeImg,NSURL * _Nullable imgPath))complate;

/// 图片附件 显示的图片
+ (void)handleImgAttachment:(UIImage *_Nullable)orgImg
                     resize:(CGSize)resize
                   complate:(void(^_Nullable)(UIImage * _Nullable resizeImg,NSURL* _Nullable resizeImgDiskPath))complate;

@end
