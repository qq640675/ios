//
//  insufficientView.m
//  beijing
//
//  Created by zhou last on 2018/10/7.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "insufficientView.h"
#import "YLTapGesture.h"
#import "DefineConstants.h"
#import "YLRechargeVipController.h"
#import "SLHelper.h"

@interface insufficientView ()
{
    UIImageView *lastPayMethodImgView; //上一个支付方式 微信 支付宝
    UIImageView *lastRechargeImgView; //上一个充值按钮
    UIViewController *selfVC;
    
    YLVideoRechargeType rechargeType;//充值列表
    YLVideoPayType payType;//支付方式
}

@property (nonatomic ,strong) YLInsufficientBlock insuffyblock;
@property (nonatomic ,strong) YLGetCoinFreeBlock coinblock;

@end

@implementation insufficientView


- (void)tapBlock:(YLInsufficientBlock)block getCoinBlock:(nonnull YLGetCoinFreeBlock)getCoinBlock
{
    self.insuffyblock = block;
    selfVC = [SLHelper getCurrentVC];
    self.coinblock = getCoinBlock;
    
    lastRechargeImgView = self.firstSelImgView;
    lastPayMethodImgView = self.apliySelImgView;
    rechargeType = YLVideoRechargeTypeFirst;
    payType = YLVideoPayTypeApliy;
    
    //微信选择
    [YLTapGesture tapGestureTarget:self sel:@selector(wechatSelTap:) view:self.wechatBgView];
    //支付宝选择
    [YLTapGesture tapGestureTarget:self sel:@selector(apliySelTap:) view:self.apliyBgView];
    //充值
    [YLTapGesture tapGestureTarget:self sel:@selector(rechargeBtnBeClicked:) view:self.rechargeButton];
    //第一个充值按钮
    [YLTapGesture tapGestureTarget:self sel:@selector(firstRechargeTap:) view:self.firstRechargeBgView];
    //第二个充值按钮
    [YLTapGesture tapGestureTarget:self sel:@selector(secondRechargeTap:) view:self.secondRechargeBgView];
    //免费领取金币
    [YLTapGesture tapGestureTarget:self sel:@selector(getCoinFreeTap:) view:self.getCoinLabel];
}

#pragma mark ---- 免费领取金币
- (void)getCoinFreeTap:(UITapGestureRecognizer *)tap
{
    self.coinblock(YES);
}

#pragma mark ---- 第一个充值按钮
- (void)firstRechargeTap:(UITapGestureRecognizer *)tap
{
    rechargeType = YLVideoRechargeTypeFirst;

    [lastRechargeImgView setImage:[UIImage imageNamed:@"insufficient_coin_nosel"]];
    [self.firstSelImgView setImage:[UIImage imageNamed:@"insufficient_coin_sel"]];
    
    lastRechargeImgView = self.firstSelImgView;
}

#pragma mark ---- 第二个充值按钮
- (void)secondRechargeTap:(UITapGestureRecognizer *)tap
{
    rechargeType = YLVideoRechargeTypeSecond;

    [lastRechargeImgView setImage:[UIImage imageNamed:@"insufficient_coin_nosel"]];
    [self.secondSelImgView setImage:[UIImage imageNamed:@"insufficient_coin_sel"]];
    
    lastRechargeImgView = self.secondSelImgView;
}

#pragma mark ---- 微信选择
- (void)wechatSelTap:(UITapGestureRecognizer *)tap
{
    payType = YLVideoPayTypeWechat;

    [lastPayMethodImgView setImage:[UIImage imageNamed:@"insufficient_btn_nosel"]];
    [self.wechatSelImgView setImage:[UIImage imageNamed:@"insufficient_btn_sel"]];
    
    lastPayMethodImgView = self.wechatSelImgView;
    if (self.changedPayTaype) {
        self.changedPayTaype(payType);
    }
}

#pragma mark ---- 支付宝选择
- (void)apliySelTap:(UITapGestureRecognizer *)tap
{
    payType = YLVideoPayTypeApliy;

    [lastPayMethodImgView setImage:[UIImage imageNamed:@"insufficient_btn_nosel"]];
    [self.apliySelImgView setImage:[UIImage imageNamed:@"insufficient_btn_sel"]];
    
    lastPayMethodImgView = self.apliySelImgView;
    if (self.changedPayTaype) {
        self.changedPayTaype(payType);
    }
}

#pragma mark ---- 充值按钮
- (void)rechargeBtnBeClicked:(UIButton *)sender
{
    self.insuffyblock(payType,rechargeType);
}

@end
