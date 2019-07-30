//
//  PostRichEditViewController.m
//  TTRichTextView
//
//  Created by bin on 2019/7/30.
//  Copyright © 2019 xp.bin.pro. All rights reserved.
//

#import "PostRichEditViewController.h"
#import "Masonry.h"

#import "NSTextStorage+Html.h"
#import "MediaCompressTool.h"

#import "AudioTextAttachment.h"
#import "GifTextAttachment.h"

#import "GifAttachmentReusableView.h"
#import "AudioAttachmentReusableView.h"

#import "NSTextStorage+Draft.h"

@interface PostRichEditViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *titleField;

@property (nonatomic,assign) BOOL richTextIsFirstResponder;

@end

@implementation PostRichEditViewController



#pragma mark - left cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupLayout];
    
    // config AttachmentReusableView
    [self.textView registerClass:AudioAttachmentReusableView.class forReusableViewWithIdentifier:NSStringFromClass(AudioAttachmentReusableView.class)];
    [self.textView registerClass:GifAttachmentReusableView.class forReusableViewWithIdentifier:NSStringFromClass(GifAttachmentReusableView.class)];
}


#pragma mark - Send Post Paramters

- (void)sendPostContentRequest{
    NSString *content = [self.textView.textStorage convertToHtml];
    NSLog(@"---content Text-%@-",content);
}

-(void)sendMenuPressed{
    
    [self.textView.textStorage buildDraft:RichTextHtml complated:^(DraftMetaDataModel * _Nonnull draftModel) {
        NSLog(@"~~RichTextHtml~~~%@",draftModel.richText);
    }];
    
}

-(void)backMenuPressed{
    [self.textView resignFirstResponder];
    [self.titleField resignFirstResponder];
    [self resignFirstResponder];
    
    if (self.textView.text.length == 0) {
        [super backMenuPressed];
        return;
    }
    
    [super backMenuPressed];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.textView.inputAccessoryView = nil;
    [self.textView reloadInputViews];
    [self reloadInputViews];
    return YES;
}


#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.textView.inputAccessoryView = self.textInputView;
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView != self.textView) {
        return;
    }
    
    /// 重置
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10;
    self.textView.typingAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:AutoSize(15)],
                                       NSForegroundColorAttributeName:[UIColor blackColor],
                                       NSParagraphStyleAttributeName:style
                                       };
    
    self.textInputView.currentTextLength = self.textView.text.length;
    
    self.placeholderLabel.hidden = (self.textView.text.length > 0);
    /// 限制图片和视频个数
    self.textInputView.vedioBtn.enabled = ([self.textView videoAttachmentCount] < maxVedioCount);
    self.textInputView.imgBtn.enabled = ([self.textView imageAttachmentCount] < maxPhotoCount);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"☻"]){//防止输入^_^崩溃。☻是我输入^_^后系统打印出来的，也就是说输入^_^，系统却理解成了☻
        [textView insertText:@"^_^"];//如果你的服务器识别不了，所以还是把这句删除吧，删除后就变成禁止输入^_^
        if ([self.textView.delegate respondsToSelector:@selector(textViewDidChange:)]) {
            [self.textView.delegate textViewDidChange:self.textView];
        }
        return NO;
    }
    
    if ( [textView  bindDelete:NSAttributedStringBindingKey inRange:range] == NO ) {
        if ([self.textView.delegate respondsToSelector:@selector(textViewDidChange:)]) {
            [self.textView.delegate textViewDidChange:self.textView];
        }
        return NO;
    }
    //    if ([text isEqualToString:@"@"]){
    //
    //        return NO;
    //    }else
    
    /* 输入#字符 拉起页面
     if ([text isEqualToString:@"#"]){
     [self insertTagAction];
     return NO;
     } */
    return  YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    [textView bindSelectRange:NSAttributedStringBindingKey textViewDelegate:self];
}

#pragma mark - TextViewAttachmentDelegate

- (TextAttachmentReusableView *)textView:(UITextView *)textView viewForAttachment:(AnyViewTextAttachment *)attachment{
    if (![textView isKindOfClass:RichTextView.class]) {
        return nil;
    }
    
    TextAttachmentReusableView *reusableView = nil;
    
    if ([attachment isKindOfClass:[AudioTextAttachment class]]) {
        
        NSString *identifier = NSStringFromClass(AudioAttachmentReusableView.class);
        
        reusableView = [(RichTextView *)textView dequeueReusableAttachmentViewWithIdentifier:identifier];
        
    }else if ([attachment isKindOfClass:[GifTextAttachment class]]){
        
        NSString *identifier = NSStringFromClass(GifAttachmentReusableView.class);
        
        reusableView = [(RichTextView *)textView dequeueReusableAttachmentViewWithIdentifier:identifier];
    }
    
    return reusableView;
}


- (void)textView:(UITextView *)textView tapedAttachment:(NSTextAttachment *)attachment{
    
    NSLog(@"!!!!tapedAttachment!!!!!!!!!%@",attachment);
}

- (void)textView:(UITextView *)textView deselected:(NSTextAttachment *)deselectedAttachment atPoint:(CGPoint)point{
    
    NSLog(@"!!!deselected!!!!!!!!!!%@",deselectedAttachment);
}


#pragma mark - ConfigUI

- (void)setupLayout{
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1];
    
    [self.view addSubview:self.titleField];
    [self.view addSubview:line];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.placeholderLabel];
    
    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(TopBarHeight);
        make.left.equalTo(self.view.mas_left).offset(AutoSize(10));
        make.height.mas_equalTo(48);
        make.width.mas_equalTo(ScreenWidth - 2*AutoSize(10));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleField.mas_bottom);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(line.mas_bottom).offset(10);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView.mas_left).offset(10);
        make.top.equalTo(self.textView.mas_top);
    }];
}


#pragma mark - Getter

- (UITextField *)titleField {
    if (_titleField == nil) {
        _titleField = [[UITextField alloc] init];
        _titleField.placeholder  = @"标题 (必填)";
        _titleField.font = [UIFont systemFontOfSize:15];
        _titleField.delegate = self;
    }
    return _titleField;
}
@end
