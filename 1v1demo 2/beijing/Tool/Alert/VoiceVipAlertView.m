//
//  VoiceVipAlertView.m
//  beijing
//
//  Created by 黎 涛 on 2019/11/18.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "VoiceVipAlertView.h"
#import "YLRechargeVipController.h"
#import "SLHelper.h"

@implementation VoiceVipAlertView
{
    UILabel *contentLabel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        [self setSubViews];
    }
    return self;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (void)showWithContent:(NSString *)content {
    contentLabel.text = content;
    [self show];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)setSubViews {
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(30, (APP_Frame_Height-180)/2, App_Frame_Width-60, 180)];
    whiteView.backgroundColor = UIColor.whiteColor;
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 8;
    [self addSubview:whiteView];
    
    UIImageView *vipImageView = [[UIImageView alloc] initWithFrame:CGRectMake((App_Frame_Width-87)/2+15, CGRectGetMinY(whiteView.frame)-52, 87, 53)];
    vipImageView.image = [UIImage imageNamed:@"voice_vip_img"];
    [self addSubview:vipImageView];
    [self sendSubviewToBack:vipImageView];
    
    contentLabel = [UIManager initWithLabel:CGRectMake(0, 0, whiteView.width, 95) text:@"VIP用户\n才能和附近美女视频互动哦~" font:17 textColor:XZRGB(0x333333)];
    contentLabel.numberOfLines = 2;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:contentLabel];
    
    UIButton *vipBtn = [UIManager initWithButton:CGRectMake((whiteView.width-120)/2, 95, 120, 36) text:@"立即升级" font:18 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    vipBtn.backgroundColor = XZRGB(0xAE4FFD);
    vipBtn.layer.masksToBounds = YES;
    vipBtn.layer.cornerRadius = 18;
    [vipBtn addTarget:self action:@selector(rechargeVIP) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:vipBtn];
    
    UIButton *noBtn = [UIManager initWithButton:CGRectMake((whiteView.width-120)/2, 145, 120, 30) text:@"暂不升级" font:18 textColor:XZRGB(0x999999) normalImg:nil highImg:nil selectedImg:nil];
    [noBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:noBtn];
    
}

- (void)rechargeVIP {
    [self dismiss];
    [YLPushManager pushVipWithEndTime:nil];
}
   

   
@end
