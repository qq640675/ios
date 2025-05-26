//
//  MyRankAwardView.m
//  beijing
//
//  Created by 黎 涛 on 2020/12/22.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MyRankAwardView.h"

@implementation MyRankAwardView
{
    UILabel *typeLabel;
    UILabel *rankLabel;
    UILabel *awardLabel;
    UIButton *getBtn;
}

- (instancetype)initWithY:(CGFloat)y {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, y, App_Frame_Width, 40);
        self.backgroundColor = XZRGB(0xF1F2F8);
        [self setSubViews];
    }
    return self;
}

- (void)setMyAwardData:(rankingHandle *)handle {
    self.myHandle = handle;
    
    typeLabel.text = [NSString stringWithFormat:@"%@排名：", handle.t_title];
    rankLabel.text = [NSString stringWithFormat:@"%d", handle.t_rank_sort];
    
    awardLabel.text = [NSString stringWithFormat:@"奖励：%d金币", handle.t_rank_gold];
    if (handle.t_is_receive) {
        getBtn.enabled = NO;
        [getBtn setTitle:@"已领取" forState:0];
        [getBtn setTitleColor:XZRGB(0x999999) forState:0];
        getBtn.backgroundColor = XZRGB(0xE8E7E7);
    } else {
        getBtn.enabled = YES;
        [getBtn setTitle:@"领取" forState:0];
        [getBtn setTitleColor:UIColor.whiteColor forState:0];
        getBtn.backgroundColor = XZRGB(0x7948FB);
    }
}


- (void)getButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
    [YLNetworkInterface receiveRankGoldWithId:_myHandle.rankRewardId btnType:(int)_myHandle.t_rank_time_type rankType:(int)_myHandle.t_rank_reward_type success:^{
        if (self.awardListArray.count > 0) {
            [self.awardListArray removeObjectAtIndex:0];
            [self setMyDataWithRankArray:self.awardListArray];
        }
    }];
}

- (void)setSubViews {
    
    typeLabel = [UIManager initWithLabel:CGRectMake(0, 0, 130, 40) text:@"排名：" font:14 textColor:XZRGB(0x333333)];
    typeLabel.textAlignment = NSTextAlignmentRight;
    typeLabel.numberOfLines = 2;
    [self addSubview:typeLabel];
    
    rankLabel = [UIManager initWithLabel:CGRectMake(130, 0, 30, 40) text:@"10" font:14 textColor:XZRGB(0xAE4FFD)];
    rankLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:rankLabel];
    
    awardLabel = [UIManager initWithLabel:CGRectMake(160, 3, App_Frame_Width-230, 20) text:@"奖励:18888金币" font:14 textColor:XZRGB(0x333333)];
    awardLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:awardLabel];
    
    UILabel *tipL = [UIManager initWithLabel:CGRectMake(awardLabel.x, 23, awardLabel.width, 17) text:@"请在24小时内领取奖励" font:11 textColor:XZRGB(0xAE4FFD)];
    tipL.textAlignment = NSTextAlignmentLeft;
    [self addSubview:tipL];
    
    getBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-70, 10, 50, 20) text:@"领取" font:11 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    getBtn.backgroundColor = XZRGB(0x7948FB);
    getBtn.layer.masksToBounds = YES;
    getBtn.layer.cornerRadius = 10;
    [getBtn addTarget:self action:@selector(getButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:getBtn];
}



- (void)setMyDataWithRankArray:(NSArray *)rankArray {
    self.awardListArray = [NSMutableArray arrayWithArray:rankArray];
    if (self.awardListArray.count > 0) {
        self.myHandle = self.awardListArray.firstObject;
        [self setMyAwardData:self.myHandle];
        
    } else {
        [self removeFromSuperview];
    }
}

@end
