//
//  filterView.m
//  beijing
//
//  Created by zhou last on 2018/8/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "filterView.h"
#import "DefineConstants.h"
#import "YLBasicView.h"
#import "YLTapGesture.h"

@interface filterView ()
{
    UIButton *lastButton;
}

@property (nonatomic ,strong) YLFilterViewBlock filterblock;

@end

@implementation filterView

- (void)cordius
{
    [self notSelStatus:self.allButton];
    [self notSelStatus:self.freeVideoButton];
    [self notSelStatus:self.notFreeVideoButton];
}

- (void)selStatus:(UIButton *)btn
{
    [btn.layer setBorderColor:KCLEARCOLOR.CGColor];
    [btn.layer setBorderWidth:1.];
    
    [btn setTitleColor:KWHITECOLOR forState:UIControlStateNormal];
    [btn setBackgroundColor:XZRGB(0xFA0437)];
    [btn.layer setCornerRadius:16.];
    [btn setClipsToBounds:YES];
}

- (void)notSelStatus:(UIButton *)btn
{
    [btn.layer setBorderColor:IColor(232, 232, 232).CGColor];
    [btn.layer setBorderWidth:1.];
    
    [btn setTitleColor:XZRGB(0x666666) forState:UIControlStateNormal];
    [btn setBackgroundColor:KWHITECOLOR];
    [btn.layer setCornerRadius:16.];
    [btn setClipsToBounds:YES];
}

- (void)filterCordius:(YLFilterViewBlock)block
{
    _filterblock = block;
    
    lastButton = self.allButton;
 
    [YLTapGesture addTaget:self sel:@selector(allVideoTap:) view:self.allButton];
    [YLTapGesture addTaget:self sel:@selector(freeVideoTap:) view:self.freeVideoButton];
    [YLTapGesture addTaget:self sel:@selector(notFreeVideoTap:) view:self.notFreeVideoButton];
}

#pragma mark ---- 全部视频
- (void)allVideoTap:(UIButton *)sender
{
    [self lastViewAssignment:sender];
}

#pragma mark ---- 免费视频
- (void)freeVideoTap:(UIButton *)sender
{
    [self lastViewAssignment:sender];
}

#pragma mark ---- 付费视频
- (void)notFreeVideoTap:(UIButton *)sender
{
    [self lastViewAssignment:sender];
}


- (void)lastViewAssignment:(UIButton *)btn
{
    [self notSelStatus:lastButton];

    [self selStatus:btn];


    lastButton = btn;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.filterblock((int)btn.tag - 101);
    });
}




@end
