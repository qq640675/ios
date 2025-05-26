//
//  InviteSonItemView.m
//  Qiaqia
//
//  Created by 刘森林 on 2020/12/15.
//  Copyright © 2020 yiliaogaoke. All rights reserved.
//

#import "InviteSonItemView.h"
#import "GetRedPacketSuccessView.h"

@implementation InviteSonItemView


#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

#pragma mark - setData
- (void)setRedPacketData:(NSDictionary *)dataDic {
    self.redPacketDic = dataDic;
    self.moneyLb.text = [NSString stringWithFormat:@"%@元",dataDic[@"t_share_rmb"]];
    
    /*
     isReceived  是否已领取
     isReceiving  是否可以领取
     */
    BOOL isReceived = [[NSString stringWithFormat:@"%@", dataDic[@"isReceived"]] boolValue];
    BOOL isReceiving = [[NSString stringWithFormat:@"%@", dataDic[@"isReceiving"]] boolValue];
    if (isReceived) {
        self.titleLb.text = @"已领取";
        [self setRedPacketStatus:RedPacketStatusGeted];
    } else if (isReceiving) {
        self.titleLb.text = @"待领取";
        [self setRedPacketStatus:RedPacketStatusCanGet];
    } else {
        int needNum = [[NSString stringWithFormat:@"%@", dataDic[@"t_share_people"]] intValue];
        self.titleLb.text = [NSString stringWithFormat:@"差%d人", needNum-(int)self.myInvitedNum];
        [self setRedPacketStatus:RedPacketStatusCant];
    }
}

- (void)setRedPacketStatus:(RedPacketStatus)status {
    [_tempImageView.layer removeAllAnimations];
    if (status == RedPacketStatusGeted) {
        // 已领取
        self.imageView.image = [UIImage imageNamed:@"PersonCenter_invite_gray"];
        self.imageView.userInteractionEnabled = NO;
        self.tempImageView.hidden = YES;
        self.moneyLb.textColor = XZRGB(0x999999);
        self.lb.textColor = XZRGB(0x999999);
        self.titleLb.textColor = XZRGB(0x999999);
        
    } else if (status == RedPacketStatusCanGet) {
        // 可领取
        self.imageView.image = [UIImage imageNamed:@"PersonCenter_invite_red"];
        self.imageView.userInteractionEnabled = YES;
        self.tempImageView.hidden = NO;
        self.moneyLb.textColor = UIColor.whiteColor;
        self.lb.textColor = UIColor.whiteColor;
        self.titleLb.textColor = XZRGB(0xFF1437);
        [self addAnimation];
    } else if (status == RedPacketStatusCant) {
        // 不能领取  还差人
        self.imageView.image = [UIImage imageNamed:@"PersonCenter_invite_red"];
        self.imageView.userInteractionEnabled = NO;
        self.tempImageView.hidden = NO;
        self.moneyLb.textColor = UIColor.whiteColor;
        self.lb.textColor = UIColor.whiteColor;
        self.titleLb.textColor = XZRGB(0x333333);
    }
}

- (void)addAnimation {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.8;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.3)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.repeatCount = MAXFLOAT;
    [_tempImageView.layer addAnimation:animation forKey:nil];
//    CABasicAnimation *scaleAnimate = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    scaleAnimate.duration = 0.8;
//    scaleAnimate.repeatCount = MAXFLOAT;
//    scaleAnimate.fromValue = [NSNumber numberWithFloat:1.0];
//    scaleAnimate.toValue = [NSNumber numberWithFloat:1.3];
//    scaleAnimate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    [_tempImageView.layer addAnimation:scaleAnimate forKey:@"scale-layer"];
}

#pragma mark - func
- (void)requestRedPacket:(UITapGestureRecognizer *)tap {
    tap.view.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tap.view.userInteractionEnabled = YES;
    });
    [YLNetworkInterface receiveShareRewardGoldWithId:self.redPacketDic[@"t_reward_id"] success:^{
        [self setRedPacketStatus:RedPacketStatusGeted];
        GetRedPacketSuccessView *view = [[GetRedPacketSuccessView alloc] initWithRedPacketData:self.redPacketDic];
        [view show];
        if (self.getRedPacketSuccess) {
            self.getRedPacketSuccess();
        }
    }];
}

#pragma mark - UI
- (void)setupUI {

    self.imageView = [[UIImageView alloc] initWithImage:SLImageName(@"PersonCenter_invite_red")];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-10);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestRedPacket:)];
    [self.imageView addGestureRecognizer:tap];
    
    self.tempImageView = [[UIImageView alloc] initWithImage:SLImageName(@"PersonCenter_invite_red_ling")];
    self.tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_tempImageView];
    [_tempImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView).offset(-5);
        make.top.equalTo(self.imageView).offset(18.5);
    }];
    
    
    self.moneyLb = [UIManager initWithLabel:CGRectZero text:@"0元" font:15 textColor:UIColor.whiteColor];
    [_imageView addSubview:_moneyLb];
    [_moneyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imageView);
        make.centerX.equalTo(self.imageView).offset(-5);
    }];
    
    _lb = [UIManager initWithLabel:CGRectZero text:@"邀请好友领取" font:11 textColor:UIColor.whiteColor];
    [_imageView addSubview:_lb];
    [_lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView).offset(-5);
        make.bottom.mas_equalTo(-30);
    }];
    
    self.titleLb = [UIManager initWithLabel:CGRectZero text:@"差0人" font:14 textColor:XZRGB(0x333333)];
    [self addSubview:_titleLb];
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView).offset(-5);
        make.bottom.mas_equalTo(-12);
    }];
    
    
}

@end
