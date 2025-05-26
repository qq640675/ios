//
//  applyUnionView.m
//  beijing
//
//  Created by zhou last on 2018/9/14.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "applyUnionView.h"
#import "DefineConstants.h"

@implementation applyUnionView

- (void)unionCordius{
    [self RadiusOfView:self.nameBgView];
    [self RadiusOfView:self.idcardBgView];
    [self RadiusOfView:self.mobileBgView];
    [self RadiusOfView:self.unionNameBgView];
    [self RadiusOfView:self.numberBgView];
}

- (void)RadiusOfView:(UIView *)view
{
    [view.layer setCornerRadius:3.];
    [view setClipsToBounds:YES];
    [view.layer setBorderColor:XZRGB(0xd5d5d5).CGColor];
    [view.layer setBorderWidth:1.];
}

@end
