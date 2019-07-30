//
//  VideoTextAttachment.h
//  RichText
//
//  Created by tbin on 2018/7/16.
//  Copyright © 2018年 me.test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "MediaTextAttachment.h"

@interface VideoTextAttachment : MediaTextAttachment

/// 已上传的视频封面远程地址
@property (nonatomic,copy) NSURL *posterURL;
/// 插入视频时已经写入沙盒路径
@property (nonatomic,copy) NSURL *posterDiskPath;
/// 封图尺寸
@property (nonatomic,assign) CGSize coverSize;


/// 已上传的视频远程地址
@property (nonatomic,copy)  NSURL *videoURL;
/// 对应相册资源
@property (nonatomic,strong) PHAsset *videoAsset;
/// 上传时需判断是否为nil ， 否则需要重新压缩写入沙盒 by videoAsset
@property (nonatomic,copy)  NSURL *videoDiskPath;


/// 视频信息
@property (nonatomic,assign) float duration;
@property (nonatomic,assign) long long dataLength;
@property (nonatomic,copy) NSString *format;

@end




