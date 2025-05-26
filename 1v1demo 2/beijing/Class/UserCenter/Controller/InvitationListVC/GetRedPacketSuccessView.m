//
//  GetRedPacketSuccessView.m
//  beijing
//
//  Created by 黎 涛 on 2020/12/24.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "GetRedPacketSuccessView.h"

@implementation GetRedPacketSuccessView

- (instancetype)initWithRedPacketData:(NSDictionary *)dataDic {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_FRAME_HEIGHT);
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        [self setSubViewsWithRedPacketData:dataDic];
        
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

- (void)setSubViewsWithRedPacketData:(NSDictionary *)dataDic {
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((App_Frame_Width-240)/2, (APP_FRAME_HEIGHT-210)/2, 240, 210)];
    bgImageView.image = [UIImage imageNamed:@"redPacket_bg_img"];
    [self addSubview:bgImageView];
    bgImageView.userInteractionEnabled = YES;
    
    UILabel *titleL = [UIManager initWithLabel:CGRectMake(60, 30, bgImageView.width-120, 50) text:@"恭喜您已领取奖励" font:18 textColor:XZRGB(0xf3823c)];
    titleL.numberOfLines = 2;
    titleL.adjustsFontSizeToFitWidth = YES;
    [bgImageView addSubview:titleL];
    
    UILabel *moneyL = [UIManager initWithLabel:CGRectMake(60, 80, bgImageView.width-120, 35) text:[NSString stringWithFormat:@"￥%@", dataDic[@"t_share_rmb"]] font:24 textColor:XZRGB(0xD05800)];
    moneyL.font = [UIFont boldSystemFontOfSize:24];
    moneyL.adjustsFontSizeToFitWidth = YES;
    [bgImageView addSubview:moneyL];
    
    UIButton *okBtn = [UIManager initWithButton:CGRectMake((bgImageView.width-160)/2, bgImageView.height-53, 160, 45) text:nil font:1 textColor:nil normalImg:@"redPacket_ok_btn" highImg:nil selectedImg:nil];
    [okBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:okBtn];
}

@end
