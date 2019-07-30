//
//  TextAttachmentReusableView.h
//   
//
//  Created by tbin on 2018/11/20.
//  Copyright © 2018  bin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextAttachmentReusableView : UIView

@property (nonatomic,copy,readonly) NSString *identifier;

- (instancetype)initAttachmentReusableView:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
