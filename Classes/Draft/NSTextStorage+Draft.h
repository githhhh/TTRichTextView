//
//  NSTextStorage+Draft.h
//   
//
//  Created by tbin on 2018/11/21.
//  Copyright © 2018  bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraftMetaDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSTextStorage (Draft)

+ (NSTextStorage *)textStorageWithDraft:(DraftMetaDataModel *)draft typingAttributes:(NSDictionary<NSAttributedStringKey, id> *)typingAttributes;

- (void)buildDraft:(RichTextType)richTextType complated:(void(^)(DraftMetaDataModel *draftModel))complated;

- (void)serializationDraftToJSON:(DraftMetaDataModel *)draftModel;

@end


NS_ASSUME_NONNULL_END
