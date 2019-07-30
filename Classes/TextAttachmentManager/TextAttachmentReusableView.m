//
//  TextAttachmentReusableView.m
//   
//
//  Created by tbin on 2018/11/20.
//  Copyright © 2018  bin. All rights reserved.
//

#import "TextAttachmentReusableView.h"

@interface TextAttachmentReusableView ()

@property (nonatomic,copy,readwrite) NSString *identifier;

@end

@implementation TextAttachmentReusableView

- (instancetype)initAttachmentReusableView:(NSString *)identifier{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = NO;
        _identifier = identifier;
        
        self.layer.borderColor = UIColor.redColor.CGColor;
        self.layer.borderWidth = 0.5f;
    }
    return self;
}

@end
