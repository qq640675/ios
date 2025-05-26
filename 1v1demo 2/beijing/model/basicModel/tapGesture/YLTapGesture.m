//
//  YLTapGesture.m
//  beijing
//
//  Created by zhou last on 2018/6/26.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLTapGesture.h"

@implementation YLTapGesture

+ (void)tapGestureTarget:(id)selfTarget sel:(SEL)tapAction view:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:selfTarget action:tapAction];
    [view addGestureRecognizer:tap];
}


+ (void)addTaget:(id)selfTarget sel:(SEL)tapAction view:(UIButton *)button
{
    [button addTarget:selfTarget action:tapAction forControlEvents:UIControlEventTouchUpInside];
}

@end
