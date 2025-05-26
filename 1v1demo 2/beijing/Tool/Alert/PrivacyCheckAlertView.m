//
//  PrivacyCheckAlertView.m
//  beijing
//
//  Created by 黎 涛 on 2020/5/20.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "PrivacyCheckAlertView.h"

@implementation PrivacyCheckAlertView


- (instancetype)initWithType:(NSString *)type coin:(int)coinNum {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        [self setSubViewsWithType:type coin:coinNum];
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
    }
    return self;
}

- (void)setSubViewsWithType:(NSString *)type coin:(int)coinNum {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((App_Frame_Width-310)/2, (APP_Frame_Height-190)/2-20, 310, 190)];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 10;
    [self addSubview:bgView];
    
    NSString *title = @"VIP可免费查看主播私密信息哦【立即升级】";
    UILabel *vipL = [UIManager initWithLabel:CGRectMake(5, 20, bgView.width-10, 30) text:@"" font:15 textColor:XZRGB(0x333333)];
    [bgView addSubview:vipL];
    NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] initWithString:title];
    [titleAttr addAttribute:NSForegroundColorAttributeName value:KDEFAULTCOLOR range:NSMakeRange(title.length-6, 6)];
    vipL.attributedText = titleAttr;
    vipL.userInteractionEnabled = YES;
    UITapGestureRecognizer *vipTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateVIP)];
    [vipL addGestureRecognizer:vipTap];
    
    NSString *content = [NSString stringWithFormat:@"查看本%@需要支付 %d金币 哦！", type, coinNum];
    UILabel *contentL = [UIManager initWithLabel:CGRectMake(10, (bgView.height-30)/2, bgView.width-20, 30) text:@"" font:15 textColor:XZRGB(0x333333)];
    [bgView addSubview:contentL];
    NSMutableAttributedString *contentAttr = [[NSMutableAttributedString alloc] initWithString:content];
    [contentAttr addAttribute:NSForegroundColorAttributeName value:KDEFAULTCOLOR range:NSMakeRange(7+type.length, content.length-9-type.length)];
    contentL.attributedText = contentAttr;
    
    CGFloat gap = (bgView.width-180)/3;
    UIButton *cancleBtn = [UIManager initWithButton:CGRectMake(gap, bgView.height-55, 90, 35) text:@"取消" font:17 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
    cancleBtn.backgroundColor = XZRGB(0xf2f3f7);
    cancleBtn.layer.masksToBounds = YES;
    cancleBtn.layer.cornerRadius = 17.5;
    [cancleBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancleBtn];
    
    UIButton *sureBtn = [UIManager initWithButton:CGRectMake(gap*2+90, bgView.height-55, 90, 35) text:@"确定" font:17 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    sureBtn.backgroundColor = KDEFAULTCOLOR;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 17.5;
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sureBtn];
}

- (void)remove {
    [self removeFromSuperview];
}

- (void)sure {
    [self remove];
    if (self.sureButtonClickBlock) {
        self.sureButtonClickBlock();
    }
}

- (void)updateVIP {
    [self remove];
    [YLPushManager pushVipWithEndTime:nil];
}



@end
