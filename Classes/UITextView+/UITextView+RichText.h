//
//  UITextView+RichText.h
//   
//
//  Created by tbin on 2018/11/23.
//  Copyright © 2018  bin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (RichText)

/// Style
- (void)removeBold;

- (void)removeUnderline;

- (void)removeObliqueness;

@end

NS_ASSUME_NONNULL_END
