//
//  FreeMessageAlertView.m
//  beijing
//
//  Created by 黎 涛 on 2020/4/15.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "FreeMessageAlertView.h"

@implementation FreeMessageAlertView
{
    UILabel *messageLabel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    //240 250
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((App_Frame_Width-240)/2, (APP_Frame_Height-250)/2, 240, 250)];
    bgImageView.image = [UIImage imageNamed:@"freemessage_alert"];
    bgImageView.userInteractionEnabled = YES;
    [self addSubview:bgImageView];
    
    UILabel *titleL = [UIManager initWithLabel:CGRectMake(20, 120, bgImageView.width-40, 25) text:@"每日首次登陆奖励" font:16 textColor:XZRGB(0x333333)];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    [bgImageView addSubview:titleL];
    
    messageLabel = [UIManager initWithLabel:CGRectMake(20, CGRectGetMaxY(titleL.frame)+10, bgImageView.width-40, 25) text:@"" font:14 textColor:XZRGB(0xAE4FFD)];
    messageLabel.font = [UIFont boldSystemFontOfSize:14];
    [bgImageView addSubview:messageLabel];
    
    UIButton *btn = [UIManager initWithButton:CGRectMake((bgImageView.width-190)/2, bgImageView.height - 55, 190, 34) text:@"我知道了" font:14 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 17;
    btn.backgroundColor = XZRGB(0xAE4FFD);
    [btn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:btn];
    
}

- (void)showWithNum:(NSString *)messageNum isCase:(BOOL)isCase goldNum:(NSString *)goldNum isGold:(BOOL)isGold {
    NSString *messageText = [NSString stringWithFormat:@"私信条数+%@", messageNum];
    NSString *goldText = [NSString stringWithFormat:@"金币+%@", goldNum];
    if (isCase == 1 && isGold == 1) {
        messageLabel.text = [NSString stringWithFormat:@"%@     %@", messageText, goldText];
    } else if (isCase == 1 && isGold == 0) {
        messageLabel.text = messageText;
    } else if (isCase == 0 && isGold == 1) {
        messageLabel.text = goldText;
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (void)remove {
    [self removeFromSuperview];
}

@end
