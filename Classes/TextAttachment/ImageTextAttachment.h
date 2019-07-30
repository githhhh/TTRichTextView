//
//  ImageTextAttachment.h
//  RichText
//
//  Created by tbin on 2018/7/16.
//  Copyright © 2018年 me.test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "MediaTextAttachment.h"

@interface ImageTextAttachment : MediaTextAttachment

@property (nonatomic,copy) NSURL *imageURL;

@property (nonatomic,strong) PHAsset *imgAsset;

@property (nonatomic,assign) CGSize orgImgSize;

@property (nonatomic,copy) NSURL * thumbnailDiskPath;

@end
