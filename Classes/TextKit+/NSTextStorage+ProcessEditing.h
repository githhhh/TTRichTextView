//
//  NSTextStorage+ProcessEditing.h
//   
//
//  Created by tbin on 2018/11/22.
//  Copyright © 2018  bin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NSTextStorageHookDelegate

@optional
- (void)textStorageHook_processEditing:(NSTextStorage *_Nullable)textStorage;

@end

@interface NSTextStorage (ProcessEditing)

@property (nullable, weak, NS_NONATOMIC_IOSONLY) id <NSTextStorageHookDelegate> hookDelegate;

@end

NS_ASSUME_NONNULL_END
