//
//  GifAttachmentReusableView.m
//  HOHO
//
//  Created by tbin on 2018/11/21.
//  Copyright © 2018 ThinkFly. All rights reserved.
//

#import "GifAttachmentReusableView.h"
#import "YYAnimatedImageView.h"
#import "RichTextTools.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYAnimatedImageView.h>
#import <YYKit/YYImage.h>

@implementation GifAttachmentReusableView

- (instancetype)initAttachmentReusableView:(NSString *)identifier{
    self = [super initAttachmentReusableView:identifier];
    if (self) {
        
        YYImage *image = [YYImage imageNamed:@"niconiconi"];
        YYAnimatedImageView *imgView = [[YYAnimatedImageView alloc] initWithImage:image];
        [self addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.mas_height);
        }];
    }
    return self;
}

@end
