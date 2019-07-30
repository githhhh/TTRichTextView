//
//  UIImage+Utils.m
//   
//
//  Created by tbin on 2018/11/21.
//  Copyright © 2018  bin. All rights reserved.
//

#import "UIImage+Utils.h"
#import "RichTextTools.h"

@implementation UIImage (Utils)

+ (NSData *)compressImage:(UIImage *)img toSize:(long long)targetSize {
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        UIGraphicsEndImageContext();
        return nil;
    }
    UIGraphicsEndImageContext();
    
    // targetSize以字节(K)为单位
    long long maxFileSize = targetSize * 1024;
    CGFloat compression = 0.9;
    CGFloat maxCompression = 0.1;
    NSData *compressedData = UIImageJPEGRepresentation(newImage, compression);
    if (compressedData == nil) {
        return nil;
    }
    while (compressedData.length > maxFileSize && compression > maxCompression ) {
        compression  = compression - 0.1;
        compressedData = UIImageJPEGRepresentation(newImage, compression);
    }
    return  compressedData;
}


+ (UIImage *)composeVideoCoverImg:(UIImage *)originImg{
    if (originImg == nil) {
        return nil;
    }
    UIImage *tempImage = [UIImage imageWithCGImage:[originImg CGImage]];
    
    UIImage* icon =  XFRichTextImage(@"movie_play");
    //[UIImage imageNamed:@"movie_play"];
    if (icon == nil) {
        return nil;
    }
    CGImageRef iconRef = icon.CGImage;
    CGFloat iconW = CGImageGetWidth(iconRef);
    CGFloat iconH = CGImageGetHeight(iconRef);
    
    CGImageRef videoImgRef = tempImage.CGImage;
    CGFloat videoImgW = CGImageGetWidth(videoImgRef);
    CGFloat videoImgH = CGImageGetHeight(videoImgRef);
    
    UIGraphicsBeginImageContext(CGSizeMake(videoImgW, videoImgH));
    [tempImage drawInRect:CGRectMake(0, 0, videoImgW, videoImgH)];
    [icon drawInRect:CGRectMake(videoImgW/2 - iconW/2, videoImgH/2 - iconH/2, iconW, iconH)];
    UIImage *coverImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //    CGImageRelease(iconRef);
    //    CGImageRelease(videoImgRef);
    return coverImg;
}

@end


@implementation UIImage (Resize)

+ (UIImage *)scaleImage:(UIImage *)originalImage toSize:(CGSize)size
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
    if (originalImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -size.height, 0.0f);
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), originalImage.CGImage);
    } else {
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), originalImage.CGImage);
    }
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(context);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    UIImage *image = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    
    return image;
}

+ (CGSize)estimateNewSize:(CGSize)newSize forImage:(UIImage *)image
{
    if (image.size.width > image.size.height) {
        newSize = CGSizeMake((image.size.width/image.size.height) * newSize.height, newSize.height);
    } else {
        newSize = CGSizeMake(newSize.width, (image.size.height/image.size.width) * newSize.width);
    }
    
    return newSize;
}

+ (UIImage *)scaleImage:(UIImage *)image proportionallyToSize:(CGSize)newSize
{
    return [self scaleImage:image toSize:[self estimateNewSize:newSize forImage:image]];
}

@end


@implementation UIImage (Placeholder)

+ (UIImage *)placeholderColor:(UIColor *)color size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)] fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation UIImage (Save)

- (NSURL *)saveToDisk{
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",[NSUUID UUID].UUIDString,@"jpg"];
    NSData* imageData =  UIImageJPEGRepresentation(self, 1);
    if (!imageData) {
        imageData = UIImagePNGRepresentation(self);
        fileName = [fileName stringByReplacingOccurrencesOfString:@".jpg" withString:@".png"];
    }
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    // Now we get the full path to the file
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    // and then we write it out
    
    BOOL isWrite = [imageData writeToFile:fullPathToFile atomically:NO];
    
    if (!isWrite) {
        return nil;
    }
    return [NSURL URLWithString:fullPathToFile];
}

+ (UIImage *)loadImgWith:(NSString *)fileName{
    if (fileName.length == 0) {
        return nil;
    }
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager] isExecutableFileAtPath:fullPathToFile]) {
        return nil;
    }
    return [UIImage imageWithContentsOfFile:fullPathToFile];
}

@end

