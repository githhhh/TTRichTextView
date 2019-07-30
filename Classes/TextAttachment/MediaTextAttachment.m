//
//  MediaTextAttachment.m
//   
//
//  Created by tbin on 2018/7/17.
//  Copyright © 2018年  bin. All rights reserved.
//

#import "MediaTextAttachment.h"

#import "ImageTextAttachment.h"
#import "GifTextAttachment.h"
#import "AudioTextAttachment.h"
#import "VideoTextAttachment.h"

@implementation MediaTextAttachment

+ (MediaTextAttachment *)attachmentForMetaData:(DraftAttachmentDataModel *)metaData{
    MediaTextAttachment * textAttachment = nil;
    if (metaData.attachmentType == ImgAttachmentType) {
        textAttachment = [[ImageTextAttachment alloc] init];
    }else if (metaData.attachmentType == GifAttachmentType){
        textAttachment = [[GifTextAttachment alloc] init];
    }else if (metaData.attachmentType == AudioAttachmentType){
        textAttachment = [[AudioTextAttachment alloc] init];
    }else if (metaData.attachmentType == VideoAttachmentType){
        textAttachment = [[VideoTextAttachment alloc] init];
    }else{
    }
    
    textAttachment.bounds = CGRectMake(0, 0, metaData.attachmentWidth, metaData.attachmentHeight);
    return [textAttachment setupAttachmentForMetaData:metaData];
}

#pragma mark - CopyTextAttachmentProtocol

- (DraftAttachmentDataModel *)attachmentDraftMetaData{
    return nil;
}

- (instancetype)setupAttachmentForMetaData:(DraftAttachmentDataModel *)metaData{
    return self;
}

@end
