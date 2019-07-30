//
//  AnyViewTextAttachment.h
//   
//
//  Created by tbin on 2018/11/19.
//  Copyright © 2018  bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaTextAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnyViewTextAttachment : MediaTextAttachment

/// view的边距
@property (nonatomic,assign) UIEdgeInsets contentInset;

@end

NS_ASSUME_NONNULL_END
