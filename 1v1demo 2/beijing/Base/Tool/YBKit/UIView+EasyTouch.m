//
//  UIView+EasyTouch.m
// app
//
//  Created by binbins on 2019/4/2.
//  Copyright © 2019 zhifanYoung. All rights reserved.
//

#import "UIView+EasyTouch.h"
#import <objc/runtime.h>

@implementation UIView (EasyTouch)

static NSString *blockName = @"touchViewBlock";

- (void)setTouchViewBlock:(OnTouchView)touchViewBlock {
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchEvent)];
    [self addGestureRecognizer:tap];

    objc_setAssociatedObject(self, &blockName, touchViewBlock, OBJC_ASSOCIATION_COPY);
}

- (OnTouchView)touchViewBlock {
    
    return objc_getAssociatedObject(self, &blockName);
}


#pragma mark -

- (void)touchEvent {
    if (self.touchViewBlock) {
        self.touchViewBlock();
    }
}

@end
