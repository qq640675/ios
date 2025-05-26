//
//  UITextViewWorkaround.m
//  beijing
//
//  Created by 黎 涛 on 2019/11/8.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "UITextViewWorkaround.h"

@implementation UITextViewWorkaround


+ (void)executeWorkaround {
    if (@available(iOS 13.2, *)) {
 
    }
    else {
        const char *className = "_UITextLayoutView";
        Class cls = objc_getClass(className);
        if (cls == nil) {
            cls = objc_allocateClassPair([UIView class], className, 0);
            objc_registerClassPair(cls);
#if DEBUG
            printf("added %s dynamically\n", className);
#endif
        }
    }
}

@end
