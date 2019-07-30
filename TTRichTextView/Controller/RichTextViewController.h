//
//  RichTextViewController.h
//  TTRichTextView
//
//  Created by bin on 2019/7/30.
//  Copyright © 2019 xp.bin.pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichTextInputAccessoryView.h"
#import "RichTextView.h"
#import "TextViewAttachmentDelegate.h"
#import "RichTextView+TextAttachment.h"
#import "UITextView+RichText.h"
#import "Define.h"
#import "TZImagePickerController.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kTopicExpStr = @"#[^@#;<>\\s]+#";
static NSInteger const  inputAccessoryViewHeight = 45;

static NSInteger const maxVedioCount = 1000000;
static NSInteger const maxPhotoCount = 900000;

@interface RichTextViewController : UIViewController<UITextViewDelegate,NSTextStorageHookDelegate,TextViewAttachmentDelegate,TZImagePickerControllerDelegate>

@property (nonatomic,assign) BOOL isEmptyContent;

@property (nonatomic,strong,readonly) RichTextView *textView;

@property (nonatomic,strong,readonly) UILabel *placeholderLabel;

@property (nonatomic,strong) RichTextInputAccessoryView * textInputView;

@property (assign, nonatomic,readonly) CGFloat kbHeight;

/// should overrid
- (void)backMenuPressed;

- (void)sendMenuPressed;


- (void)insertTagAction;
- (void)insertAudioAction;
- (void)insertGifAction;
- (void)insertBAction;
- (void)insertImgAction;
- (void)insertVedioAction;
@end

NS_ASSUME_NONNULL_END
