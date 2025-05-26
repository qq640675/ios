//
//  UIView+EasyTouch.h
// app
//
//  Created by binbins on 2019/4/2.
//  Copyright © 2019 zhifanYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (EasyTouch)

typedef void (^OnTouchView)(void);

@property (copy, nonatomic) OnTouchView touchViewBlock;

@end

NS_ASSUME_NONNULL_END
