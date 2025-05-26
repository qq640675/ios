//
//  YLCordius.m
//  beijing
//
//  Created by zhou last on 2018/6/27.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLCordius.h"

@implementation YLCordius

+ (void)codius:(UIView *)view radian:(float)radian
{
    [view.layer setCornerRadius:radian];
    [view setClipsToBounds:YES];
}

@end
