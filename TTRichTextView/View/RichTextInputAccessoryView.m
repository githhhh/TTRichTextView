//
//  RichTextInputView.m
//  RichText
//
//  Created by bin on 2018/7/15.
//  Copyright © 2018年 me.test. All rights reserved.
//

#import "RichTextInputAccessoryView.h"
#import "Masonry.h"
#import "TZImagePickerController.h"
#import <YYKit.h>
@interface RichTextInputAccessoryView()

@property (nonatomic,strong) UIButton *imgBtn;
@property (nonatomic,strong) UIButton *vedioBtn;
@property (nonatomic,strong) UIButton *tagBtn;

@property (nonatomic,strong) UIButton *audioBtn;
@property (nonatomic,strong) UIButton *anyBtn;
@property (nonatomic,strong) UIButton *bBtn;

@property (strong, nonatomic) UILabel  *textLengthLabel;

@end

@implementation RichTextInputAccessoryView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        _inputAccessoryViewHeight = 45;
        _maxTextLength = 500;

        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];

        [self addSubview: self.imgBtn];
        [self addSubview: self.vedioBtn];
        [self addSubview: self.tagBtn];
        [self addSubview:self.audioBtn];
        [self addSubview: self.anyBtn];
        [self addSubview: self.bBtn];

        [self.imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.top.equalTo(self);
            make.left.equalTo(self).offset(10);
        }];

        [self.vedioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.top.equalTo(self);
            make.left.equalTo(self.imgBtn.mas_right).offset(30);
        }];
        
        [self.tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.top.equalTo(self);
            make.left.equalTo(self.vedioBtn.mas_right).offset(30);
        }];
        
        [self.audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.top.equalTo(self);
            make.left.equalTo(self.tagBtn.mas_right).offset(30);
        }];
        
        [self.anyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.top.equalTo(self);
            make.left.equalTo(self.audioBtn.mas_right).offset(30);
        }];

        [self.bBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.top.equalTo(self);
            make.left.equalTo(self.anyBtn.mas_right).offset(30);
        }];

    }
    return self;
}


- (CGSize)intrinsicContentSize {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, self.inputAccessoryViewHeight);
}


- (void)setCurrentTextLength:(NSInteger)currentTextLength
{
    _currentTextLength = currentTextLength;
        self.textLengthLabel.text = [NSString stringWithFormat:@"%@/%@",@(currentTextLength),@(_maxTextLength)];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGSize size = [self.textLengthLabel sizeThatFits:CGSizeMake(screenWidth/3, 100)];
    self.textLengthLabel.size = size;
    self.textLengthLabel.center = CGPointMake(screenWidth-self.textLengthLabel.width/2-10, self.height/2 + 5);
}




/// fix iPhone X
/// https://stackoverflow.com/questions/46282987/iphone-x-how-to-handle-view-controller-inputaccessoryview
- (void)didMoveToWindow{
    [super didMoveToWindow];
    if (@available(iOS 11.0, *)) {
        if (self.window.safeAreaLayoutGuide != nil) {
            [[self.bottomAnchor constraintLessThanOrEqualToSystemSpacingBelowAnchor:[self.window.safeAreaLayoutGuide bottomAnchor] multiplier:1.0] setActive:YES];
        }
    }
}


- (UIButton *)imgBtn{
    if (_imgBtn == nil){
        _imgBtn = [[UIButton alloc] init];
        [_imgBtn setImage:[UIImage imageNamed:@"cf_richText_tool_image"] forState:UIControlStateNormal];
        [_imgBtn setImage:[UIImage imageNamed:@"cf_richText_tool_image_unenable"] forState:UIControlStateDisabled];

    }
    return _imgBtn;
}

- (UIButton *)vedioBtn{
    if (_vedioBtn == nil){
        _vedioBtn = [[UIButton alloc] init];
        [_vedioBtn setImage:[UIImage imageNamed:@"cf_richText_tool_video_normal"] forState:UIControlStateNormal];
        [_vedioBtn setImage:[UIImage imageNamed:@"cf_richText_tool_video_un"] forState:UIControlStateDisabled];

    }
    return _vedioBtn;
}

- (UIButton *)tagBtn{
    if (_tagBtn == nil){
        _tagBtn = [[UIButton alloc] init];
        [_tagBtn setImage:[UIImage imageNamed:@"rich_topic_icon"] forState:UIControlStateNormal];
    }
    return _tagBtn;
}

- (UIButton *)anyBtn{
    if (!_anyBtn) {
        _anyBtn = [[UIButton alloc] init];
        [_anyBtn setTitle:@"gif" forState:UIControlStateNormal];
        [_anyBtn setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
    }
    return _anyBtn;
}

- (UIButton *)audioBtn{
    if (!_audioBtn) {
        _audioBtn = [[UIButton alloc] init];
        [_audioBtn setTitle:@"audio" forState:UIControlStateNormal];
        [_audioBtn setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
    }
    return _audioBtn;
}


- (UIButton *)bBtn{
    if (!_bBtn) {
        _bBtn = [[UIButton alloc] init];
        [_bBtn setTitle:@"B" forState:UIControlStateNormal];
        [_bBtn setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
    }
    return _bBtn;
}

- (UILabel *)textLengthLabel
{
    if(!_textLengthLabel){
        _textLengthLabel = [UILabel new];
        _textLengthLabel.textColor = [UIColor redColor];
        _textLengthLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_textLengthLabel];
    }
    return _textLengthLabel;
}

@end

