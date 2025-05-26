//
//  MysteriousView.m
//  beijing
//
//  Created by 黎 涛 on 2021/4/12.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "MysteriousView.h"

@implementation MysteriousView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_FRAME_HEIGHT);
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        [self setSubViews];
    }
    return self;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (void)remove {
    [self removeFromSuperview];
}

- (void)setSubViews {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((App_Frame_Width-310)/2, (APP_Frame_Height-280)/2, 310, 280)];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    [self addSubview:bgView];
    
    UIImageView *titleIV = [[UIImageView alloc] initWithFrame:CGRectMake((App_Frame_Width-310)/2-1, bgView.y-26, 311, 106)];
    titleIV.image = [UIImage imageNamed:@"mysterious_img"];
    [self addSubview:titleIV];
    
    UILabel *label_1 = [UIManager initWithLabel:CGRectMake(0, 125, bgView.width, 30) text:@"我是神秘人，猜猜我是谁?" font:18 textColor:XZRGB(0x333333)];
    [bgView addSubview:label_1];
    
    UILabel *label_2 = [UIManager initWithLabel:CGRectMake(0, 155, bgView.width, 25) text:@"榜单隐身，VIP专属特权!" font:16 textColor:XZRGB(0x868686)];
    [bgView addSubview:label_2];
    
    UIButton *vipB = [UIManager initWithButton:CGRectMake((bgView.width-90)/2, bgView.height-55, 90, 35) text:@"开通VIP" font:18 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    vipB.backgroundColor = XZRGB(0xC580FE);
    vipB.layer.masksToBounds = YES;
    vipB.layer.cornerRadius = vipB.height/2;
    [vipB addTarget:self action:@selector(vipButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:vipB];
    
    UIButton *closeB = [UIManager initWithButton:CGRectMake((App_Frame_Width-50)/2, CGRectGetMaxY(bgView.frame)+10, 50, 50) text:@"" font:1 textColor:nil normalImg:@"mansion_room_delete" highImg:nil selectedImg:nil];
    [closeB addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeB];
}

- (void)vipButtonClick {
    [YLPushManager pushVipWithEndTime:nil];
    [self remove];
}


@end
