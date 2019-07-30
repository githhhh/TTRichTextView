//
//  UIImage+Utils.h
//   
//
//  Created by tbin on 2018/11/21.
//  Copyright © 2018  bin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Utils)

/// 压缩图片到目标尺寸
+ (NSData *)compressImage:(UIImage *)img toSize:(long long)targetSize;
/// 合成视频封图 + 播放icon
+ (UIImage *)composeVideoCoverImg:(UIImage *)videoImg;

@end

@interface UIImage (Resize)

/// 修改图片CGSize
+ (UIImage *)scaleImage:(UIImage *)originalImage toSize:(CGSize)size;
+ (CGSize)estimateNewSize:(CGSize)newSize forImage:(UIImage *)image;
+ (UIImage *)scaleImage:(UIImage *)image proportionallyToSize:(CGSize)newSize;

@end

@interface UIImage (Placeholder)

+ (UIImage *)placeholderColor:(UIColor *)color size:(CGSize)size;

@end


@interface UIImage (Save)

- (NSURL *)saveToDisk;

+ (UIImage *)loadImgWith:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
