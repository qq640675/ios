//
//  ZYGiftRedEnvep.m
//  beijing
//
//  Created by zhou last on 2018/11/1.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "ZYGiftRedEnvep.h"
#import "YLTapGesture.h"
#import "newRedEnvView.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import <Masonry.h>
#import "DefineConstants.h"
#import "YLRechargeVipController.h"
#import <SVProgressHUD.h>
#import "YLInsufficientManager.h"

typedef enum
{
    YLGiftRedEnvTypeGift = 0,//礼物
    YLGiftRedEnvTypeRedEnv,//红包
}YLGiftRedEnvType;

#define newKeyWindow [UIApplication sharedApplication].keyWindow
@interface ZYGiftRedEnvep ()
{
    UIView *blackMaskView;//黑色遮罩层
    newRedEnvView *redEnvView; //红包视图
    UILabel *lastTapLabel; //上一次点击的label
    int giftId; //礼物id
    int gold; //金币
    YLGiftRedEnvType newGiftType;
    int godId;//主播id
    UIViewController *selfVC;
    NSString *nGiftName;
    NSString *giftUrl;
    NSString *gifGiftUrl;
}

@property (nonatomic ,strong) YLSendSuccessBlock sendBlock;

@end

@implementation ZYGiftRedEnvep

+ (id)shareInstance
{
    static ZYGiftRedEnvep *giftRedEnv = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!giftRedEnv) {
            giftRedEnv = [ZYGiftRedEnvep new];
        }
    });
    
    return giftRedEnv;
}


- (void)giftViewTap:(int)godnessId hiddenReward:(BOOL)isHidden target:(id)target block:(YLSendSuccessBlock)block
{
    selfVC = target;
    godId = godnessId;
    self.sendBlock = block;
    
    self->blackMaskView = [UIView new];
    self->blackMaskView.frame = newKeyWindow.bounds;
    self->blackMaskView.userInteractionEnabled = YES;
    [YLTapGesture tapGestureTarget:self sel:@selector(hideBlackMaskView) view:self->blackMaskView];
    [newKeyWindow addSubview:self->blackMaskView];
    
    NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"newRedEnvView" owner:nil options:nil];
    self->redEnvView = xibArray[0];
    [newKeyWindow addSubview:self->redEnvView];
    [self->redEnvView cordius];
    
    //默认礼物
    self->lastTapLabel = self->redEnvView.giftLabel;
    
    newGiftType = YLGiftRedEnvTypeGift;
    //礼物
    [YLTapGesture tapGestureTarget:self sel:@selector(newDetailGiftViewTap:) view:self->redEnvView.giftLabel];
    //红包
    [YLTapGesture tapGestureTarget:self sel:@selector(newRedEnvViewTap:) view:self->redEnvView.redEnvLabel];
    
    giftId = 0;
    dispatch_queue_t queue = dispatch_queue_create("礼物", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        [YLNetworkInterface getGiftList:^(NSMutableArray *listArray) {
            if (listArray.count != 0) {
                [self->redEnvView createGift:listArray block:^(int tag,NSString *giftName,NSString *stillurl,NSString *gifurl,int coins) {
                    self->giftId = tag;
                    self->nGiftName = giftName;
                    self->giftUrl = stillurl;
                    self->gifGiftUrl = gifurl;
                    self->gold = coins;
                }];
            }
        }];
    });
    
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        [YLNetworkInterface getUserMoney:[YLUserDefault userDefault].t_id block:^(myPurseHandle *handle) {
            self->redEnvView.canUseCoinLabel.text = [NSString stringWithFormat:@"可用金币:%@",handle.amount];
        }];
    });
    
    //充值
    [YLTapGesture tapGestureTarget:self sel:@selector(rechargeViewTap) view:self->redEnvView.rechargeLabel];
  
    //打赏
    if (!isHidden){
        //显示
        self->redEnvView.dashangBtn.hidden = NO;
        [YLTapGesture addTaget:self sel:@selector(dashangBtnClick) view:self->redEnvView.dashangBtn];
    }else{
        self->redEnvView.dashangBtn.hidden = YES;
    }
    
    [self->redEnvView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(APP_Frame_Height - 300-SafeAreaBottomHeight+49);
        make.width.mas_equalTo(App_Frame_Width);
        make.height.mas_equalTo(300+SafeAreaBottomHeight-49);
    }];
}

#pragma mark ---- 充值
- (void)rechargeViewTap
{
    [self hideBlackMaskView];
    
    YLRechargeVipController *rechageVipVC = [YLRechargeVipController new];
    [selfVC.navigationController pushViewController:rechageVipVC animated:YES];
}

#pragma mark ---- 打赏
- (void)dashangBtnClick
{
    redEnvView.dashangBtn.enabled = NO;
    if (newGiftType == YLGiftRedEnvTypeGift) {
        //礼物
        [self sendGiftToThisBeauty];
    }
}

#pragma mark ---- 发送礼物
- (void)sendGiftToThisBeauty
{
    if (giftId == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择礼物类型"];
        redEnvView.dashangBtn.enabled = YES;
        return;
    }
    
    if (gold > 5000) {
        [LXTAlertView alertViewWithTitle:@"友情提示" message:@"你当前打赏的礼物超过500元，打赏后无法退回，请谨慎。" cancleTitle:@"取消" sureTitle:@"继续打赏" sureHandle:^{
            [self sendGiftRequest];
        }];
    } else {
        [self sendGiftRequest];
    }
}

- (void)sendGiftRequest {
    [YLNetworkInterface userGiveGiftCoverConsumeUserIds:[NSString stringWithFormat:@"%d", self->godId] giftId:self->giftId giftNum:1 block:^(BOOL isSuccess) {
        if (isSuccess) {
            self.sendBlock(YES,self->nGiftName,self->giftUrl,self->gifGiftUrl,self->giftId,self->gold);
        }else{
            //余额不足
            [[YLInsufficientManager shareInstance] insufficientShow];
            self.sendBlock(NO,self->nGiftName,@"",@"",0,0);
        }
        [self hideBlackMaskView];
    }];
}


#pragma mark ---- 发红包


#pragma mark ---- 红包
- (void)newRedEnvViewTap:(UITapGestureRecognizer *)tap
{
    [redEnvView removeScrollViewSubviews];
    newGiftType = YLGiftRedEnvTypeRedEnv;
    gold = 0;
    [redEnvView createRedEnvelop:^(int tag,NSString *name,NSString *gifturl,NSString *gifurl,int coins) {
        self->gold = coins;
    }];
    
    UILabel *redEnvLabel = (UILabel *)tap.view;
    lastTapLabel.textColor = KWHITECOLOR;
    redEnvLabel.textColor = XZRGB(0xAE4FFD);
    lastTapLabel = redEnvLabel;
}

#pragma mark ---- 礼物
- (void)newDetailGiftViewTap:(UITapGestureRecognizer *)tap
{
    UILabel *giftLabel = (UILabel *)tap.view;
    [redEnvView removeScrollViewSubviews];
    
    dispatch_queue_t queue = dispatch_queue_create("礼物", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        [YLNetworkInterface getGiftList:^(NSMutableArray *listArray) {
            if (listArray.count != 0) {
                self->giftId = 0;
                
                [self->redEnvView createGift:listArray block:^(int tag,NSString *giftName,NSString *giftUrl,NSString *gifUrl,int coins) {
                    self->giftId = tag;
                    self->nGiftName = giftName;
                    self->giftUrl = giftUrl;
                    self->gifGiftUrl = gifUrl;
                    self->gold = coins;
                }];
            }
        }];
    });
    
    newGiftType = YLGiftRedEnvTypeGift;
    
    lastTapLabel.textColor = KWHITECOLOR;
    giftLabel.textColor = XZRGB(0xAE4FFD);
    lastTapLabel = giftLabel;
}

#pragma mark ---- 移除礼物框
- (void)hideBlackMaskView
{
    [redEnvView removeFromSuperview];
    [blackMaskView removeFromSuperview];
}

@end
