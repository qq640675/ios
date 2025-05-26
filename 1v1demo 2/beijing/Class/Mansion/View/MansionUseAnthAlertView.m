//
//  MansionUseAnthAlertView.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/6.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MansionUseAnthAlertView.h"
#import "YLRechargeVipController.h"

@implementation MansionUseAnthAlertView

#pragma mark - init
- (instancetype)initWithCoin:(NSString *)coinNum {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        [self setSubViewsWithCoin:coinNum];
    }
    return self;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

#pragma mark - subViews
- (void)setSubViewsWithCoin:(NSString *)coinNum {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((App_Frame_Width-310)/2, (APP_Frame_Height-200)/2-40, 310, 200)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 10;
    bgView.backgroundColor = UIColor.whiteColor;
    [self addSubview:bgView];
    
    UILabel *titleLabel = [UIManager initWithLabel:CGRectMake(40, 0, bgView.width-80, 40) text:@"您的权限不足" font:18 textColor:XZRGB(0x333333)];
    [bgView addSubview:titleLabel];
    
    UIButton *closeBtn = [UIManager initWithButton:CGRectMake(bgView.width-40, 0, 40, 40) text:@"" font:1 textColor:nil normalImg:@"mansion_alert_close" highImg:nil selectedImg:nil];
    [closeBtn addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];
    
    NSString *content = [NSString stringWithFormat:@"只有消费超过%@金币或者开通vip会员才可以开通府邸", coinNum];
    UILabel *contentLabel = [UIManager initWithLabel:CGRectMake(15, 40, bgView.width-30, 80) text:@"" font:14 textColor:XZRGB(0x333333)];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.numberOfLines = 0;
    [bgView addSubview:contentLabel];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:XZRGB(0xfe2947) range:NSMakeRange(6, coinNum.length+2)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:XZRGB(0xfe2947) range:NSMakeRange(content.length-19, 5)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:XZRGB(0xfe2947) range:NSMakeRange(content.length-13, 6)];
    contentLabel.attributedText = attributedStr;
    
    CGFloat gap = (bgView.width-180)/3;
    UIButton *rechargeBtn = [UIManager initWithButton:CGRectMake(gap, bgView.height-35-18, 90, 35) text:@"充值" font:18 textColor:XZRGB(0xae4ffd) normalImg:nil highImg:nil selectedImg:nil];
    rechargeBtn.layer.masksToBounds = YES;
    rechargeBtn.layer.cornerRadius = 17.5;
    rechargeBtn.layer.borderWidth = 1;
    rechargeBtn.layer.borderColor = [XZRGB(0xae4ffd) colorWithAlphaComponent:0.72].CGColor;
    [rechargeBtn addTarget:self action:@selector(rechargeCoin) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:rechargeBtn];
    
    UIButton *vipBtn = [UIManager initWithButton:CGRectMake(gap*2+90, bgView.height-35-18, 90, 35) text:@"开通VIP" font:18 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    vipBtn.backgroundColor = [XZRGB(0xae4ffd) colorWithAlphaComponent:0.72];
    vipBtn.layer.masksToBounds = YES;
    vipBtn.layer.cornerRadius = 17.5;
    [vipBtn addTarget:self action:@selector(rechargeVIP) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:vipBtn];
    
}

#pragma mark - func
- (void)closeButtonClick {
    [self removeFromSuperview];
}

- (void)rechargeCoin {
    [self removeFromSuperview];
    YLRechargeVipController *rechargeVC = [[YLRechargeVipController alloc] init];
    UIViewController *nowVC = [SLHelper getCurrentVC];
    [nowVC.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)rechargeVIP {
    [self removeFromSuperview];
    [YLPushManager pushVipWithEndTime:nil];
}

@end
