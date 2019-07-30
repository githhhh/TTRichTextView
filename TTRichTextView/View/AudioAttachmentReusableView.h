//
//  AudioAttachmentReusableView.h
//  HOHO
//
//  Created by tbin on 2018/11/21.
//  Copyright © 2018 ThinkFly. All rights reserved.
//

#import "TextAttachmentReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AudioAttachmentReusableView : TextAttachmentReusableView

@property (nonatomic,strong,readonly) UIImageView *imgView;

@property (nonatomic,strong,readonly) UILabel *leftLb;

@property (nonatomic,strong,readonly) UILabel *rightLb;

@property (nonatomic,strong,readonly) UIProgressView *progressView;

@end

NS_ASSUME_NONNULL_END
