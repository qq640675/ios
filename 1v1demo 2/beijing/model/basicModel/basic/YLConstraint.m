//
//  YLConstraint.m
//  beijing
//
//  Created by zhou last on 2018/6/27.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLConstraint.h"
#import <Masonry.h>

@implementation YLConstraint

+ (void)masConstraint:(UIView *)view x:(float)x y:(float)y w:(float)w h:(float)h
{
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(x);
        make.top.mas_equalTo(y);
        make.width.mas_equalTo(w);
        make.height.mas_equalTo(h);
    }];
}

+ (void)masConstraint:(UIView *)view centerx:(UIView *)centerView y:(float)y w:(float)w h:(float)h
{
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(centerView);
        make.top.mas_equalTo(y);
        make.width.mas_equalTo(w);
        make.height.mas_equalTo(h);
    }];
}

@end
