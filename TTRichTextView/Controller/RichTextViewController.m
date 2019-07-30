//
//  RichTextViewController.m
//  TTRichTextView
//
//  Created by bin on 2019/7/30.
//  Copyright © 2019 xp.bin.pro. All rights reserved.
//

#import "RichTextViewController.h"
#import "MediaCompressTool.h"
#import "NSTextStorage+Draft.h"
#import "RichTextView+Draft.h"
#import "AttachmentLayoutManager.h"

#import "AudioTextAttachment.h"
#import "GifTextAttachment.h"

#import "GifAttachmentReusableView.h"
#import "AudioAttachmentReusableView.h"

@interface RichTextViewController ()

@property (nonatomic,strong) RichTextView *textView;

@property (nonatomic,strong) UILabel *placeholderLabel;

@property (assign, nonatomic) CGFloat kbHeight;

@end

@implementation RichTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    /// 导航栏
    [self setupNavView];
    /// 监听键盘
    [self observeKeyboard];
    
    
    // actions
    [self.textInputView.imgBtn addTarget:self action:@selector(insertImgAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.textInputView.vedioBtn addTarget:self action:@selector(insertVedioAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.textInputView.tagBtn addTarget:self action:@selector(insertTagAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.textInputView.audioBtn addTarget:self action:@selector(insertAudioAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.textInputView.anyBtn addTarget:self action:@selector(insertGifAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.textInputView.bBtn addTarget:self action:@selector(insertBAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"~~~~didReceiveMemoryWarning~~~");
}

#pragma mark - inputAccessoryView

- (BOOL)canBecomeFirstResponder{
    return  YES;
}

- (UIView *)inputAccessoryView{
    return self.textInputView;
}


#pragma mark - insert Action

- (void)insertTagAction {
    NSString* newTopicName = [NSString stringWithFormat:@"#%@#", @"测试话题"];
    /// 内容后面保留一个空格
    NSString *bindText = AttributedStringBindingText(newTopicName);
    [self.textView insertText:bindText];
    [self.textView becomeFirstResponder];
    
    ///根据当前光标位置判断位置 带空额 绑定文本后面带有空格
    NSRange tnRange =  NSMakeRange(self.textView.selectedRange.location - bindText.length, bindText.length - 1);
    /// 仅插入的话题才高亮:
    NSRegularExpression *kTopicExp = [NSRegularExpression regularExpressionWithPattern:kTopicExpStr options:kNilOptions error:nil];
    NSRange allRange = NSMakeRange(0, self.textView.textStorage.length);
    [kTopicExp enumerateMatchesInString:self.textView.textStorage.string options:NSMatchingWithoutAnchoringBounds range:allRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (!result) return;
        
        /// 当前的话题才加入高亮
        if (!NSEqualRanges(tnRange, result.range)) {
            return;
        }
        [self.textView addBindingAttributeInRange:result.range highlightingColor:[UIColor colorWithRed:253/255.0 green:136/255.0 blue:43/255.0 alpha:1] ];
    }];
    
}

- (void)insertAudioAction{
    CGSize size = CGSizeMake(self.textView.textContainer.size.width, 50);
    
    AudioTextAttachment *audioAttchement = [[AudioTextAttachment alloc] init];
    audioAttchement.bounds = CGRectMake(0, 0, size.width, size.height);
    [self.textView insertAttachment:audioAttchement paragraphStyle:nil];
    
    /// 限制图片个数 和 提示语隐藏
    if ([self.textView.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.textView.delegate textViewDidChange:self.textView];
    }
    [self.textView becomeFirstResponder];
}

- (void)insertGifAction{
    CGSize size = CGSizeMake(self.textView.textContainer.size.width, 200);
    GifTextAttachment *gifAttchement = [[GifTextAttachment alloc] init];
    gifAttchement.bounds = CGRectMake(0, 0, size.width, size.height);
    [self.textView insertAttachment:gifAttchement paragraphStyle:nil];
    
    /// 限制图片个数 和 提示语隐藏
    if ([self.textView.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.textView.delegate textViewDidChange:self.textView];
    }
    [self.textView becomeFirstResponder];
}

- (void)insertBAction{
    [self.textView toggleUnderline:self.textView];
    //        [self.textView removeUnderlineForRange:self.textView.selectedRange];
    //    [self.textView removeBold];
}

- (void)insertImgAction{
    CGSize newSize = CGSizeMake(self.textView.textContainer.size.width, 0);
    TZImagePickerController *imagePickerVc =  [[TZImagePickerController alloc] init];
    imagePickerVc.allowTakePicture = YES;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.maxImagesCount = maxPhotoCount - [self.textView imageAttachmentCount];
    WeakSelf
    imagePickerVc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (UIImage *photo in photos) {
            NSInteger index = [photos indexOfObject:photo];
            PHAsset *photoAsset = assets[index];
            /// 插入图片附件
            [weakself insertImageAttchment:photo resize:newSize photoAsset:photoAsset];
        }
        
        /// 限制图片个数 和 提示语隐藏
        if ([weakself.textView.delegate respondsToSelector:@selector(textViewDidChange:)]) {
            [weakself.textView.delegate textViewDidChange:weakself.textView];
        }
        [weakself.textView becomeFirstResponder];
    };
    
    [self presentViewController:imagePickerVc animated:true completion:nil];
}

- (void)insertVedioAction{
    CGSize newSize = CGSizeMake(self.textView.textContainer.size.width, 0);
    TZImagePickerController *imagePickerVc =  [[TZImagePickerController alloc] init];
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingImage = NO;
    WeakSelf
    imagePickerVc.didFinishPickingVideoHandle = ^(UIImage *coverImage, id asset) {
        if (![asset isKindOfClass:[PHAsset class]] || coverImage == nil) {
            return;
        }
        /// 检查视频是否合规
        [MediaCompressTool checkVideo:asset unavailable:^(NSString *errormsg,NSString *info,XFCheckVideoResult type){
            
            /// 弹框
            [weakself alertViewWhenUnavailableVideo:errormsg];
            
        } available:^(float duration,long long dataLength,NSString *format){
            /// 插入视频附件
            [weakself insertVideoAttchment:coverImage resize:newSize videoAsset:asset complate:^(VideoTextAttachment *videoAttachment) {
                /// 更新视频信息
                videoAttachment.duration = duration;
                videoAttachment.dataLength = dataLength;
                videoAttachment.format = format;
                
                /// 限制视频个数 和 提示语隐藏
                if ([weakself.textView.delegate respondsToSelector:@selector(textViewDidChange:)]) {
                    [weakself.textView.delegate textViewDidChange:weakself.textView];
                }
                [weakself.textView becomeFirstResponder];
            }];
        }];
    };
    
    [self presentViewController:imagePickerVc animated:true completion:nil];
}

- (void)insertImageAttchment:(UIImage *)photo resize:(CGSize)newSize photoAsset:(PHAsset *)asset{
    /// 处理照片
    WeakSelf
    [MediaCompressTool handleImgAttachment:photo resize:newSize complate:^(UIImage *resizeImg ,NSURL* resizeImgDiskPath) {
        
        ImageTextAttachment *imgAttachment = [weakself.textView insertImgAttachment:resizeImg paragraphStyle:nil];
        
        imgAttachment.imgAsset = asset;
        
        imgAttachment.thumbnailDiskPath = resizeImgDiskPath;
    }];
}

-(void)insertVideoAttchment:(UIImage *)coverImage resize:(CGSize)newSize videoAsset:(PHAsset *)asset complate:(void(^)(VideoTextAttachment * videoAttachment))complate{
    
    /// 处理视频 和 封面逻辑
    WeakSelf
    [MediaCompressTool handleVideoAttachment:coverImage resize:newSize complate:^(UIImage *resizeImg, NSURL *imgPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            VideoTextAttachment * videoAttachment = [weakself.textView insertVideoAttachment:resizeImg paragraphStyle:nil];
            videoAttachment.posterDiskPath = imgPath;
            videoAttachment.videoAsset = asset;
            videoAttachment.coverSize = coverImage.size;
            
            /// 插入视频附件完成
            if (complate) {
                complate(videoAttachment);
            }
        });
    }];
}

- (void)alertViewWhenUnavailableVideo:(NSString *)msg{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"视频添加失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"重新选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self insertVedioAction];
    }];
    [alert addAction:cancelAction];
    [alert addAction:action];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}


#pragma mark - overried

- (void)backMenuPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendMenuPressed{
    
}

#pragma mark - keyboardWillShow

- (void)observeKeyboard{
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(adjustForKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(adjustForKeyboard:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)adjustForKeyboard:(NSNotification *)notification{
    CGRect keyboardScreenEndFrame =  [(NSValue * )notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardViewEndFrame =  [self.view convertRect:keyboardScreenEndFrame fromView:self.view.window];
    
    /// 键盘高度会包含 inputAccessoryView 的高度
    self.kbHeight = keyboardViewEndFrame.size.height;
    if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        self.textView.contentInset = UIEdgeInsetsZero;
    }else{
        self.textView.contentInset = UIEdgeInsetsMake(0, 0, keyboardViewEndFrame.size.height, 0);
    }
    
    self.textView.scrollIndicatorInsets = self.textView.contentInset;
    [self performSelector:@selector(scrollToCaret) withObject:nil afterDelay:0.01];
}

- (void)scrollToCaret{
    if (self.textView.isFirstResponder == NO) {
        return;
    }
    CGRect rect = [self.textView caretRectForPosition:self.textView.selectedTextRange.start];
    [self.textView scrollRectToVisible:rect animated:YES];
}

#pragma mark - NSTextStorageHookDelegate

- (void)textStorageHook_processEditing:(NSTextStorage *)textStorage{
    /// 输入高亮
    NSRange paragaphRange = [self.textView.textStorage.string paragraphRangeForRange: self.textView.textStorage.editedRange];
    [self.textView.textStorage removeAttribute:NSForegroundColorAttributeName range:paragaphRange];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10;
    [self.textView.textStorage addAttribute:NSParagraphStyleAttributeName value:style range:paragaphRange];

    NSRegularExpression *kTopicExp = [NSRegularExpression regularExpressionWithPattern:@"#[^@#;<>\\s]+#" options:NSRegularExpressionCaseInsensitive error:nil];
    [kTopicExp enumerateMatchesInString:self.textView.textStorage.string options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, self.textView.textStorage.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (!result) return;
        
        [self.textView.textStorage addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:253/255.0 green:136/255.0 blue:43/255.0 alpha:1] range:result.range];
    }];


    
//    /// 仅高亮 插入内容，输入不高亮
//    NSRange paragaphRange = [self.textView.textStorage.string paragraphRangeForRange: self.textView.textStorage.editedRange];
//    [self.textView.textStorage removeAttribute:NSForegroundColorAttributeName range:paragaphRange];
//
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.lineSpacing = 10;
//    [self.textView.textStorage addAttribute:NSParagraphStyleAttributeName value:style range:paragaphRange];
//
//    [self.textView.textStorage enumerateAttribute:NSAttributedStringHighlightingKey inRange:NSMakeRange(0, self.textView.textStorage.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
//        if (value == nil) {
//            return ;
//        }
//        [self.textView.textStorage addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:253/255.0 green:136/255.0 blue:43/255.0 alpha:1] range:range];
//    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    self.textInputView.hidden = NO;
}

#pragma mark - setupNavView

- (void)setupNavView {
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIBarButtonItem * barButtonItem = nil;
    barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(sendMenuPressed)];
    barButtonItem.tintColor = UIColor.orangeColor;
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    
    barButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"cf_login_backBtn2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(backMenuPressed)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}


#pragma mark - Getter

- (UILabel *)placeholderLabel {
    if(_placeholderLabel == nil){
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = [UIFont systemFontOfSize:15];
        _placeholderLabel.textColor = [UIColor grayColor];
        _placeholderLabel.text = @"分享游戏新鲜事";
    }
    return _placeholderLabel;
}

- (RichTextView *)textView {
    if (_textView == nil){
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 10;
        NSDictionary *defaultTypingAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                  NSForegroundColorAttributeName:[UIColor blackColor],
                                                  NSParagraphStyleAttributeName:style
                                                  };
        
#warning  模拟从草稿加载
        DraftMetaDataModel *draftModel = nil;
        if (!self.isEmptyContent) {
            draftModel = [DraftMetaDataModel defaultDraftModel];
        }
        
        _textView =  [RichTextView richTextViewWithDraft:draftModel typingAttributes:defaultTypingAttributes];
        _textView.textContainerInset = UIEdgeInsetsMake(0, 10, 20, 10);
        _textView.textContainer.lineFragmentPadding = 0;
        _textView.backgroundColor = UIColor.whiteColor;
        
        _textView.layer.borderColor = UIColor.redColor.CGColor;
        _textView.layer.borderWidth = 0.5f;
        
        _textView.delegate = self;
        _textView.attachmentDelegate = self;
        _textView.textStorage.hookDelegate = self;
        
        if (_textView.textStorage.length > 0 && [_textView.delegate respondsToSelector:@selector(textViewDidChange:)]) {
            [_textView.delegate textViewDidChange:_textView];
        }
    }
    return  _textView;
}

- (RichTextInputAccessoryView *)textInputView {
    if (_textInputView == nil){
        _textInputView = [[RichTextInputAccessoryView alloc] init];
    }
    return _textInputView;
}

@end
