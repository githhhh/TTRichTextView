//
//  AttachmentGestureRecognizerDelegate.h
//   
//
//  Created by tbin on 2018/11/20.
//  Copyright © 2018  bin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RichTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AttachmentGestureRecognizerDelegate : NSObject<UIGestureRecognizerDelegate>

@property (nonatomic,weak) RichTextView *textView;

- (void)richTextViewWasPressed:(UIGestureRecognizer *)recognizer;

@end

NS_ASSUME_NONNULL_END
