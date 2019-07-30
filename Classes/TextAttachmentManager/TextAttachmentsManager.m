//
//  AnyViewTextAttachmentsManager.m
//   
//
//  Created by tbin on 2018/11/19.
//  Copyright © 2018  bin. All rights reserved.
//

#import "TextAttachmentsManager.h"
#import "NSLayoutManager+Attachment.h"

@interface  TextAttachmentsManager()

@property (nonatomic,strong) NSMapTable<AnyViewTextAttachment *,TextAttachmentReusableView *> *attachmentMapTable;

@property (nonatomic,strong) NSMutableDictionary<NSString *,Class> *registerViewHash;

@property (nonatomic,strong) NSMutableArray<TextAttachmentReusableView *> *reusableAttachmentViews;

@property (nonatomic,weak,readwrite) RichTextView *textView;

@property (nonatomic,assign) CGFloat containerOffset;
@end

@implementation TextAttachmentsManager

+ (instancetype)attachmentsManagerFor:(RichTextView *)textView{
    return [[TextAttachmentsManager alloc] initWithTextView:textView];
}

- (instancetype)initWithTextView:(RichTextView *)textView
{
    self = [super init];
    if (self) {
        _attachmentMapTable = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableStrongMemory];
        _registerViewHash = [NSMutableDictionary dictionaryWithCapacity:0];
        _reusableAttachmentViews = [NSMutableArray arrayWithCapacity:0];
        _textView = textView;
        if (_textView) {
            [_textView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        }
        
        _containerOffset = CGRectGetHeight(self.textView.frame)/2;
        if (_containerOffset == 0) {
            _containerOffset = [UIScreen mainScreen].bounds.size.height/2;
        }
    }
    return self;
}

- (void)dealloc{
    NSLog(@"~~~~TextAttachmentsManager~~dealloc~~");
}

- (void)setEstimatedReusableViewHeight:(CGFloat)estimatedReusableViewHeight{
    _estimatedReusableViewHeight = estimatedReusableViewHeight;
    if (estimatedReusableViewHeight * 2.5 > _containerOffset) {
        _containerOffset = estimatedReusableViewHeight * 2.5;
    }else if (estimatedReusableViewHeight * 2.5 > 1.5*[UIScreen mainScreen].bounds.size.height){
        _containerOffset = 1.5*[UIScreen mainScreen].bounds.size.height;
    }
}

#pragma mark - MapTable

- (NSArray<AnyViewTextAttachment *> *)anyViewAttachmentsInTable{
    return self.attachmentMapTable.keyEnumerator.allObjects;
}

- (TextAttachmentReusableView *)reusableViewInTableFor:(AnyViewTextAttachment *)anyViewAttachment{
    return [self.attachmentMapTable objectForKey:anyViewAttachment];
}

- (void)removeAttachmentFromMapTable:(AnyViewTextAttachment *)anyViewAttment{
    [self.attachmentMapTable removeObjectForKey:anyViewAttment];
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *newvalue = change[NSKeyValueChangeNewKey];
        CGPoint offset = [newvalue CGPointValue];
        [self textViewContentOffsetChanged:offset];
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)textViewContentOffsetChanged:(CGPoint)offset{
    if (!self.textView || [self anyViewAttachmentsInTable].count == 0) {
        return;
    }
    
    [[self anyViewAttachmentsInTable] enumerateObjectsUsingBlock:^(AnyViewTextAttachment * _Nonnull attachment, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UIView *reusableView = [self reusableViewInTableFor:attachment];
        
        if (reusableView) {
            /// 是否可见
            CGRect actualContainer = CGRectMake(offset.x, offset.y, CGRectGetWidth(self.textView.frame) , CGRectGetHeight(self.textView.frame));
            /// 预加载范围
            CGFloat containerOffset = self.containerOffset;
            CGFloat containerMinY = CGRectGetMinY(actualContainer) - containerOffset > 0 ? CGRectGetMinY(actualContainer) - containerOffset : 0;
            CGRect preloadContainer = CGRectMake(CGRectGetMinX(actualContainer), containerMinY, CGRectGetWidth(actualContainer), CGRectGetHeight(actualContainer) + containerOffset);
            
            bool isIntersect = CGRectIntersectsRect(reusableView.frame, preloadContainer);
            if (!isIntersect) {
                [reusableView removeFromSuperview];
                [self removeAttachmentFromMapTable:attachment];
                [self.reusableAttachmentViews addObject:(TextAttachmentReusableView *)reusableView];
                [self.textView.layoutManager setNeedsDisplay:attachment];
            }
        }
    }];
}

#pragma mark - reusable

- (void)registerReusableView:(Class)viewCls reuseIdentifier:(NSString *)identifier{
    NSAssert(([viewCls isSubclassOfClass:[TextAttachmentReusableView class]]), @"viewCls must is TextAttachmentReusableView");
    [self.registerViewHash setObject:viewCls forKey:identifier];
}

- (TextAttachmentReusableView *)dequeueReusableAttachmentView:(NSString *)identifier {
    TextAttachmentReusableView *reusableView = [self getReusableViewFor:identifier];
    if (!reusableView && [self.registerViewHash.allKeys containsObject:identifier]) {
        reusableView = [[self.registerViewHash[identifier] alloc] initAttachmentReusableView:identifier];
    }
    
    return reusableView;
}

- (TextAttachmentReusableView *)reusableViewForAttachment:(AnyViewTextAttachment *)attachment{
    if (!self.textView) {
        return nil;
    }
    TextAttachmentReusableView *reusableView = [self reusableViewInTableFor:attachment];
    if (reusableView) {
        return reusableView;
    }
    
    if ([self.textView.attachmentDelegate respondsToSelector:@selector(textView:viewForAttachment:)]) {
        reusableView = [self.textView.attachmentDelegate textView:self.textView viewForAttachment:attachment];
        [self.textView addSubview:reusableView];
        [self.attachmentMapTable setObject:reusableView forKey:attachment];
    }

    return reusableView;
}

- (TextAttachmentReusableView *)getReusableViewFor:(NSString *)identifier{
    TextAttachmentReusableView *reusableView = nil;
    for (TextAttachmentReusableView *view in self.reusableAttachmentViews) {
        if ([view.identifier isEqualToString:identifier]) {
            reusableView = view;
            break;
        }
    }
    if (reusableView) {
        [self.reusableAttachmentViews removeObject:reusableView];
    }
    return reusableView;
}

@end
