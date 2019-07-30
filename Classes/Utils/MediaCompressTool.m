//
//  XFMediaCompressTool.m
//  RichText
//
//  Created by tbin on 2018/7/17.
//  Copyright © 2018年 me.test. All rights reserved.
//

#import "MediaCompressTool.h"
#import "UIImage+Utils.h"

/// 图片压缩目标 1M
#define IMG_TARGETSIZE (1 * 1024 * 1024)

@implementation MediaCompressTool

+ (NSData *)compressImage:(NSData *)imgData{
    /// 超过1M 压缩
    if (imgData.length <= IMG_TARGETSIZE || imgData == nil) {
        return imgData;
    }
    
    UIImage *img = [UIImage imageWithData:imgData];
    return [UIImage compressImage:img toSize:IMG_TARGETSIZE];
}

+ (void)compressVideo:(PHAsset *)asset completion:(void(^)(NSURL *videoDiskPath))completion  progress:(void(^)(AVAssetExportSession * exportSession))progressCallback {
    NSURL *documentUrl = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSTimeInterval timeInterval = [NSDate date].timeIntervalSince1970 * 1000;
    NSURL *tempFileURL = [NSURL URLWithString:[NSString stringWithFormat:@"video_%.f.mp4",timeInterval]  relativeToURL:documentUrl];
    
    PHVideoRequestOptions * options = [[PHVideoRequestOptions alloc] init];
    [options setNetworkAccessAllowed:YES];
    [PHImageManager.defaultManager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable avAsset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        NSArray<NSString *> *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
        
        if (![compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
            completion(nil);
            return;
        }

        AVAssetExportSession * exportSession = [AVAssetExportSession exportSessionWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        if (exportSession == nil) {
            completion(nil);
            return;
        }
        
        // 视频转码压缩后的本地保存地址
        exportSession.outputURL = tempFileURL;
        // 优化网络
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        if (progressCallback) {
            progressCallback(exportSession);
        }
        /// 导出
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            if (exportSession.status == AVAssetExportSessionStatusFailed) {
                completion(nil);
            }else if (exportSession.status == AVAssetExportSessionStatusCompleted){
                completion(tempFileURL);
            }
        }];
    }];
}

+ (void)checkVideo:(PHAsset *)asset unavailable:(void(^)(NSString *errormsg,NSString *info,XFCheckVideoResult type))unavailable available:(void(^)(float duration,long long dataLength,NSString *format))available{
    PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
    [options setNetworkAccessAllowed:YES];
    [PHImageManager.defaultManager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable avAsset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        CMTime assetTime = [avAsset duration];
        float duration = CMTimeGetSeconds(assetTime);
        NSLog(@"视频时长是：%f",duration );
        AVURLAsset *avurlAsset =  (AVURLAsset *)avAsset;
        if (avAsset == nil) {
            unavailable(nil,nil,XFCheckVideoUndefined);
            return;
        }
        NSURL* videoUrl = avurlAsset.URL;
        NSData * data = [NSData dataWithContentsOfURL:videoUrl];
        NSLog(@"===%f=",(unsigned long)data.length / 1024.0 / 1024.0);
        
        NSString * errorString = nil;
        NSString *format = [videoUrl.absoluteString.lastPathComponent.lowercaseString componentsSeparatedByString:@"."].lastObject;
        
        if(![videoUrl.absoluteString.lastPathComponent.lowercaseString containsString:@"mp4"]&&
           ![videoUrl.absoluteString.lastPathComponent.lowercaseString containsString:@"mov"]){//格式不符合
            errorString = @"目前仅支持上传MP4、MOV格式的视频哦";
            unavailable(errorString,format,XFVideoUnavailableFormat);
            return;
        }else if(data.length > videoMaxSize*1024*1024){
            errorString = [NSString stringWithFormat:@"为了保证您的视频上传体验，被添加的视频文件不要超过%ldMB哦",videoMaxSize];
            NSString* videoSize = [NSString stringWithFormat:@"%.1f",(double)data.length/1024.0/1024.0];
            unavailable(errorString,videoSize,XFVideoSizeTooBig);
            return;
        }
        else if( duration < videoMinDuration){//视频时间 不少于5秒
            errorString = [NSString stringWithFormat:@"为保证视频播放体验\n目前仅支持上传时长不少于%ld秒的视频哦", videoMinDuration];
            unavailable(errorString,@(duration).stringValue,XFVideoDurationTooShort);
            return;
        }
        /// 子线程
        available(duration,data.length,format);
    }];
    
}

#pragma mark - 处理 附件图片

+ (void)handleVideoAttachment:(UIImage *)orgImg resize:(CGSize)resize complate:(void(^)(UIImage *resizeImg,NSURL *imgPath))complate{
    
    /// 保存视频封面
    CGFloat scale = resize.width / orgImg.size.width;
    
    CGFloat hight = orgImg.size.height * scale;
    
    CGSize newResiz = CGSizeMake(resize.width, hight);
    
    UIImage* aspectScaledToFitImage = [UIImage scaleImage:orgImg toSize:newResiz];
    
    UIImage* coverImg = [UIImage composeVideoCoverImg:aspectScaledToFitImage];
    
    /// 原图写入
    NSURL *fileURL = [orgImg saveToDisk];
    
    complate(coverImg,fileURL);
}


+ (void)handleImgAttachment:(UIImage *)orgImg resize:(CGSize)resize complate:(void(^)(UIImage *resizeImg,NSURL*resizeImgDiskPath))complate{
    
    CGFloat scale = resize.width / orgImg.size.width;
    
    CGFloat hight = orgImg.size.height * scale;
    
    CGSize newSize = CGSizeMake(resize.width, hight);
    
    UIImage* aspectScaledToFitImage = [UIImage scaleImage:orgImg toSize:newSize];
    
    /// 写入磁盘
    NSURL *diskPath =  [aspectScaledToFitImage saveToDisk];
        
    complate(aspectScaledToFitImage,diskPath);
}

@end
