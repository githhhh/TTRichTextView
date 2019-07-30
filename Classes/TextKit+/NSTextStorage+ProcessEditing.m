//
//  NSTextStorage+ProcessEditing.m
//   
//
//  Created by tbin on 2018/11/22.
//  Copyright © 2018  bin. All rights reserved.
//

#import "NSTextStorage+ProcessEditing.h"
#import <objc/runtime.h>

static char const * const kHookDelegate     = "kHookDelegate";

@implementation NSTextStorage (ProcessEditing)

- (void)hook_processEditing{
    [self hook_processEditing];
    
    if (self.hookDelegate) {
        [self.hookDelegate textStorageHook_processEditing:self];
    }
}

#pragma mark - Hook

+ (void)textStorage_swizzleInstanceSelector:(SEL)originalSelector
                            withNewSelector:(SEL)newSelector
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    
    BOOL methodAdded = class_addMethod([self class],
                                       originalSelector,
                                       method_getImplementation(newMethod),
                                       method_getTypeEncoding(newMethod));
    
    if (methodAdded) {
        class_replaceMethod([self class],
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}


+ (void)load{
    [self textStorage_swizzleInstanceSelector:@selector(processEditing)
                              withNewSelector:@selector(hook_processEditing)];
}

#pragma mark - Getter/Setter

- (void)setHookDelegate:(id<NSTextStorageHookDelegate>)hookDelegate
{
    id __weak weakObject = hookDelegate;
    id (^block)() = ^{ return weakObject; };
    objc_setAssociatedObject(self, &kHookDelegate,
                             block, OBJC_ASSOCIATION_COPY);
}

- (id<NSTextStorageHookDelegate>)hookDelegate{
    id (^block)() = objc_getAssociatedObject(self, &kHookDelegate);
    return (block ? block() : nil);
}

@end
