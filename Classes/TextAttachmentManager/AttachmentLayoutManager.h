//
//  AttachmentLayoutManager.h
//   
//
//  Created by tbin on 2018/11/20.
//  Copyright © 2018  bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextAttachmentsManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AttachmentLayoutManager : NSLayoutManager

@property (nonatomic,strong) TextAttachmentsManager *attachmentsManager;

@end

NS_ASSUME_NONNULL_END
