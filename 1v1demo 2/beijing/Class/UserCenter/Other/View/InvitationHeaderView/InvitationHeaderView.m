//
//  InvitationHeaderView.m
//  beijing
//
//  Created by yiliaogao on 2019/3/23.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "InvitationHeaderView.h"

@implementation InvitationHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 240)];
    bgImageView.image = IChatUImage(@"newshare_bg");
    [self addSubview:bgImageView];
    
    UIView *ruleView = [[UIView alloc] initWithFrame:CGRectMake(App_Frame_Width-65, 10, 80, 25)];
    ruleView.backgroundColor = [UIColor whiteColor];
    ruleView.clipsToBounds = YES;
    ruleView.layer.cornerRadius = 12.5f;
    [self addSubview:ruleView];
    
    if ([YLUserDefault userDefault].t_sex == 0) {
        UIButton *ruleBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-65, 0, 65, 45) text:@"奖励规则" font:13.0f textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
        [ruleBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:ruleBtn];
    }
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 195, App_Frame_Width-25, 100)];
    bgView.image = IChatUImage(@"share_bg_white");
    [self addSubview:bgView];
    
    
    self.moneyNumberLb = [UIManager initWithLabel:CGRectMake(0, 22, bgView.width/2, 20) text:@"0" font:25.0f textColor:XZRGB(0x333333)];
    [bgView addSubview:_moneyNumberLb];
    
    UILabel *moneyLb = [UIManager initWithLabel:CGRectMake(0, 50, bgView.width/2, 20) text:@"邀请奖励" font:14.0f textColor:XZRGB(0x333333)];
    [bgView addSubview:moneyLb];
    
    self.countNumberLb = [UIManager initWithLabel:CGRectMake(bgView.width/2, 22, bgView.width/2, 20) text:@"0" font:25.0f textColor:XZRGB(0x333333)];
    [bgView addSubview:_countNumberLb];
    
    UILabel *countLb = [UIManager initWithLabel:CGRectMake(bgView.width/2, 50, bgView.width/2, 20) text:@"邀请用户" font:14.0f textColor:XZRGB(0x333333)];
    [bgView addSubview:countLb];
    
    UIButton *shareBtn = [UIManager initWithButton:CGRectMake(15, 295, App_Frame_Width-30, 59) text:@"我要赚钱" font:17.0f textColor:[UIColor whiteColor] normalBackGroudImg:@"insufficient_coin_pay" highBackGroudImg:nil selectedBackGroudImg:nil];
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    shareBtn.tag = 1;
    [shareBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareBtn];
    
}

- (void)clickedBtn:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectInvitationHeaderViewWithBtn:)]) {
        [_delegate didSelectInvitationHeaderViewWithBtn:btn];
    }
}

@end
