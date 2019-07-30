//
//  RichTextView+Draft.h
//   
//
//  Created by tbin on 2018/11/22.
//  Copyright © 2018  bin. All rights reserved.
//

#import "RichTextView.h"
#import "DraftMetaDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RichTextView (Draft)

+(instancetype _Nullable )richTextViewWithDraft:(DraftMetaDataModel* _Nullable )draft
                               typingAttributes:(NSDictionary<NSAttributedStringKey, id> *_Nullable)typingAttributes;

@end

NS_ASSUME_NONNULL_END
