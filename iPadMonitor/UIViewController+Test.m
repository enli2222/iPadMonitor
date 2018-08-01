//
//  UIViewController+Test.m
//  mobileBaseTset
//
//  Created by enli on 2018/8/1.
//  Copyright © 2018年 liuzhaoyong. All rights reserved.
//  参考 https://github.com/Shevckcccc/DRPageTracker

#import "UIViewController+Test.h"
#import <objc/runtime.h>

@implementation UIViewController(Test)

#ifdef DEBUG
#define DRLog(FORMAT, ...) fprintf(stderr,"%s\n\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DRLog(...)
#endif

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        [self swizzled_swizzleMethod:class originalSelector:@selector(viewDidAppear:) swizzledSelector:@selector(swizzled_viewDidAppear:)];
    });
}

- (void)swizzled_viewDidAppear:(BOOL)animated {
    [self swizzled_viewDidAppear:animated];
//    NSString *className = NSStringFromClass([self class]);
//    if ([className hasPrefix:@"NS"] || [className hasPrefix:@"UI"]) {
//        return;
//    }
    DRLog(@"UIViewController: %@", NSStringFromClass([self class]));
}

+ (void)swizzled_swizzleMethod:(Class)cls originalSelector:(SEL)originalSel swizzledSelector:(SEL)swizzledSel {
    Class class = cls;
    SEL originalSelector = originalSel;
    SEL swizzledSelector = swizzledSel;
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
