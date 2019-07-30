//
//  AudioAttachmentReusableView.m
//  HOHO
//
//  Created by tbin on 2018/11/21.
//  Copyright © 2018 ThinkFly. All rights reserved.
//

#import "AudioAttachmentReusableView.h"
#import "RichTextTools.h"
#import <Masonry/Masonry.h>

@interface AudioAttachmentReusableView()

@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic,strong) UIButton *playerBtn;

@property (nonatomic,strong) UILabel *leftLb;

@property (nonatomic,strong) UILabel *rightLb;

@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation AudioAttachmentReusableView

- (UIButton *)playerBtn{
    if (!_playerBtn) {
        _playerBtn = [[UIButton alloc] init];
        [_playerBtn setImage:XFRichTextImage(@"movie_play") forState:UIControlStateNormal];
    }
    return _playerBtn;
}

- (UILabel *)leftLb{
    if (!_leftLb) {
        _leftLb = [UILabel new];
        _leftLb.font = [UIFont systemFontOfSize:10];
        _leftLb.textColor = [UIColor blackColor];
        _leftLb.text = @"00:00";
    }
    return _leftLb;
}

- (UILabel *)rightLb{
    if (!_rightLb) {
        _rightLb = [UILabel new];
        _rightLb.font = [UIFont systemFontOfSize:10];
        _rightLb.textColor = [UIColor blackColor];
        _rightLb.text = @"00:05";
    }
    return _rightLb;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        //设置进度条的颜色
        _progressView.progressTintColor = [UIColor orangeColor];
        //设置进度条的当前值，范围：0~1；
        _progressView.progress = 0.0;
        _progressView.progressViewStyle = UIProgressViewStyleDefault;
    }
    return _progressView;
}

- (instancetype)initAttachmentReusableView:(NSString *)identifier{
    self = [super initAttachmentReusableView:identifier];
    if (self) {
        self.backgroundColor = [UIColor cyanColor];
        
        [self addSubview:self.playerBtn];
        [self addSubview:self.leftLb];
        [self addSubview:self.rightLb];
        [self addSubview:self.progressView];

        [self.playerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(5);
        }];
        
        [self.leftLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playerBtn.mas_right).offset(5);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLb.mas_right).offset(2);
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.rightLb.mas_left).offset(-2);
        }];
        
        [self.rightLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-5);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}


- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor yellowColor];
    }
    return _imgView;
}
@end
