//
//  NSObject+Swizzle.m
//  
//
//  Created by Bin on 16/2/2.
//  Copyright © 2016年 BKER-inc. All rights reserved.
//

#import "NSObject+Swizzle.h"

#import <objc/runtime.h>

@implementation NSObject (Swizzle)

+ (void) swizzleInstanceSelector:(SEL)originalSelector
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

+ (void) swizzleClassSelector:(SEL)originalSelector
              withNewSelector:(SEL)newSelector
{
    Method originalMethod = class_getClassMethod(self, originalSelector);
    Method newMethod = class_getClassMethod(self, newSelector);
    
    BOOL methodAdded = class_addMethod(object_getClass(self),
                                       originalSelector,
                                       method_getImplementation(newMethod),
                                       method_getTypeEncoding(newMethod));
    
    if (methodAdded) {
        class_replaceMethod(object_getClass(self),
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

+ (void) swizzleSelector:(SEL)originalSelector
         withNewSelector:(SEL)newSelector
               andNewIMP:(IMP)imp{
    
    Method originMethod = class_getInstanceMethod(self, originalSelector);
    const char * methodEncodeType = method_getTypeEncoding(originMethod);
    BOOL methodAdded = class_addMethod(self, newSelector, imp, methodEncodeType);
    
    if (methodAdded) {
        Method newMethod = class_getInstanceMethod(self,newSelector);
        method_exchangeImplementations(newMethod, originMethod);
    }else{
#ifdef DEBUG
        NSLog(@"===swizzleSelector==faile=");
        NSAssert(NO,@"===========swizzleSelector==faile=========");
#endif
    }
}

@end
