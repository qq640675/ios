//
//  YLInsufficientManager.m
//  beijing
//
//  Created by zhou last on 2018/10/8.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLInsufficientManager.h"
#import "YLBasicView.h"
#import "YLTapGesture.h"
#import "insufficientView.h"
#import "DefineConstants.h"
#import "YLNetworkInterface.h"
#import "vipSetMealHandle.h"
#import <SVProgressHUD.h>
#import "YLUserDefault.h"
#import <WXApi.h>
#import "WXApiManager.h"
#import "apliManager.h"
#import "YLRechargeVipController.h"
#import "WebPayViewController.h"

#define videoWindow [UIApplication sharedApplication].keyWindow

@interface YLInsufficientManager ()<WXApiManagerDelegate>
{
    UIView *blackView;
    insufficientView *insuffiView;//余额不足弹框
    UIImageView *lastPayMethodImgView; //上一个支付方式 微信 支付宝
    UIImageView *lastRechargeImgView; //上一个充值按钮
    
    YLVideoRechargeType videoRechargeType;//充值列表
    YLVideoPayType videoPayType;//支付方式
    NSMutableArray *rechargeListArray; //充值列表
    
}

//支付类型配置编号
@property (nonatomic, assign) NSInteger     payDeployId;

@end

@implementation YLInsufficientManager


+(id)shareInstance
{
    static YLInsufficientManager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[YLInsufficientManager alloc] init];
    });
    
    return share;
}

- (void)insufficientShow {
    
    [WXApiManager sharedManager].delegate = self;
    
    //黑色遮罩层
    blackView = [YLBasicView blackView];
    [YLTapGesture tapGestureTarget:self sel:@selector(removeInsufficient) view:blackView];
    [videoWindow addSubview:blackView];
    
    //余额不足弹框
    NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"insufficientView" owner:nil options:nil];
    insuffiView = xibArray[0];
    [videoWindow addSubview:insuffiView];
    
    [insuffiView tapBlock:^(YLVideoPayType payType, YLVideoRechargeType rechargeType) {
        
        [self rechargeRequest];
    } getCoinBlock:^(BOOL isGet) {
        [self removeInsufficient];
        
        UIViewController *vc = [SLHelper getCurrentVC];
        
        [YLPushManager pushInvite];
    }];
    WEAKSELF
    insuffiView.changedPayTaype = ^(YLVideoPayType payType) {
        [weakSelf getRechargeDiscount:payType];
    };
    //进入vip充值
    [YLTapGesture tapGestureTarget:self sel:@selector(updateVIP) view:insuffiView.vipUpgrateView];
    //更多充值金额
    [YLTapGesture tapGestureTarget:self sel:@selector(rechargeCoin) view:insuffiView.moreRechargeView];
    
    //位置动画
    insuffiView.frame = CGRectMake(0, APP_Frame_Height, App_Frame_Width, 343);
    [UIView animateWithDuration:.5 animations:^{
        self->insuffiView.frame = CGRectMake(0, APP_Frame_Height - 343, App_Frame_Width, 343);
    } completion:^(BOOL finished) {
        [weakSelf getDataWithPayType];
    }];
}

- (void)rechargeCoin {
    [self removeInsufficient];
    UIViewController *nowVC = [SLHelper getCurrentVC];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        YLRechargeVipController *rechargeVC = [[YLRechargeVipController alloc] init];
        [nowVC.navigationController pushViewController:rechargeVC animated:YES];
    });
}

- (void)updateVIP {
    [self removeInsufficient];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YLPushManager pushVipWithEndTime:nil];
    });
}

//获取默认支付方式
- (void)getDataWithPayType {
    [YLNetworkInterface getPayType:^(NSMutableArray *listArray) {
        if ([listArray count] > 0) {
            
            NSDictionary *dict = [listArray firstObject];
            
            int type = [dict[@"payType"] intValue];
            self->videoPayType = type;
//            self->insuffiView.payIconImageView.image = IChatUImage(@"nwithDraw_apliy_sel");
            [self->insuffiView.payIconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", dict[@"payIcon"]]]];
            self->insuffiView.payNameLb.text = dict[@"payName"];
            self.payDeployId = [dict[@"t_id"] integerValue];
            [self getRechargeDiscount:(int)type];
        }
        
    }];
}

#pragma mark ---- 获取充值列表的第2，4条数据
- (void)getRechargeDiscount:(int)payType
{
    dispatch_queue_t queue = dispatch_queue_create("请求充值列表数据", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        self->rechargeListArray  = [NSMutableArray array];
        [YLNetworkInterface getRechargeDiscount:payType block:^(NSMutableArray *listArray) {
            self->rechargeListArray = listArray;
            if (listArray.count > 1) {
                vipSetMealHandle *handle2 = listArray[0];
                self->insuffiView.firstYuanLabel.text = [NSString stringWithFormat:@"%@元",handle2.t_money];
                self->insuffiView.firstCoinLabel.text = [NSString stringWithFormat:@"%d金币",handle2.t_gold];
                
                vipSetMealHandle *handle4 = listArray[1];
                self->insuffiView.secondYuanLabel.text = [NSString stringWithFormat:@"%@元",handle4.t_money];;
                self->insuffiView.secondCoinLabel.text = [NSString stringWithFormat:@"%d金币",handle4.t_gold];
            }
        }];
    });
}

#pragma mark ---- 充值按钮
- (void)rechargeRequest
{
    if (rechargeListArray.count < 2) {
        [SVProgressHUD showInfoWithStatus:@"请选择充值类型"];
        return;
    }
    
    [self removeInsufficient];
    
    vipSetMealHandle *mealhandle = rechargeListArray[0];
    
    if (videoRechargeType == YLVideoRechargeTypeSecond) {
        mealhandle = rechargeListArray[1];
    }
    
    if (videoPayType == YLVideoPayTypeWechat) {
        [self wechatPayhandle:mealhandle];
    } else if (videoPayType == YLVideoPayTypeApliy){
        
        [self apliyPayhandle:mealhandle];
    } else if (videoPayType == -3 || videoPayType == -4) {
        [self webPay:mealhandle];
    } else if (videoPayType == -5) {
        [self weChatMiniProgramPay:mealhandle];
    } else if (videoPayType == -6) {
        [self alipayMiniProgramPay:mealhandle];
    } else if (videoPayType == -7) {
        [self SDAlipay:mealhandle];
    } else if (videoPayType == -8) {
        [self SDWechatPay:mealhandle];
    } else if (videoPayType == -9) {
        [self SDUPPay:mealhandle];
    } else if (videoPayType == -11) {
        [self alipayMiniProgramPay:mealhandle];
    } else if (videoPayType == -12) {
        [self weChatMiniProgramPay:mealhandle];
    } else if (videoPayType == -13) {
        [self jumpPay:mealhandle];
    } else if (videoPayType == -14) {
        [self jumpPay:mealhandle];
    } else if (videoPayType == -15) {
        [self miniProgramPay:mealhandle];
    } else if (videoPayType == -17) {
        [self jumpPay:mealhandle];
    } else if (videoPayType == -18) {
        [self jumpPay:mealhandle];
    } else if (videoPayType == -19 || videoPayType == -20) {
        [self jumpPay:mealhandle];
    } else if (videoPayType == -21 || videoPayType == -22){
        [self jumpPay:mealhandle];
    }
    // TODO, add btfpay
    // TODO, add 2th control
}

- (void)SDAlipay:(vipSetMealHandle *)mealhandle {
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:mealhandle.t_id payType:videoPayType payDeployId:self.payDeployId success:^(NSDictionary *payData) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:payData];
        [dict setValue:@"[{\"sc\":\"wzsc://\",\"s\":\"iOS\",\"id\":\"com.tencent.tmgp.sgame\",\"n\":\"支付宝\"}]" forKey:@"meta_option"];
                        
        UIViewController *nowVC = [SLHelper getCurrentVC];
        PySdkViewController *paySDK = [[PySdkViewController alloc] init];
        [paySDK alipay:dict];
        [nowVC.navigationController pushViewController:paySDK animated:YES];
        [paySDK.navigationController setNavigationBarHidden:NO animated:YES];
        [paySDK.navigationItem setTitle:@"支付"];
    }];
}

- (void)SDWechatPay:(vipSetMealHandle *)mealhandle {
    
}

- (void)SDUPPay:(vipSetMealHandle *)mealhandle {
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:mealhandle.t_id payType:videoPayType payDeployId:self.payDeployId success:^(NSDictionary *payData) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:payData];
        [dict setValue:@"[{\"sc\":\"testapp://\",\"s\":\"iOS\",\"id\":\"com.pay.paytypetest\",\"n\":\"云闪付\"}]" forKey:@"meta_option"];
                        
        PySdkViewController *paySDK = [[PySdkViewController alloc] init];
                       
        UIViewController *nowVC = [SLHelper getCurrentVC];
        paySDK.UPPayPayBlock = ^(NSString * tn){
            [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"UPPayDemo://" mode:@"00" viewController:nowVC];
        };
                
        [paySDK UPPay:dict];
        [nowVC.navigationController pushViewController:paySDK animated:YES];
        [paySDK.navigationController setNavigationBarHidden:NO animated:YES];
        [paySDK.navigationItem setTitle:@"支付"];
    }];
    
}

#pragma mark - 支付派 支付宝
- (void)miniProgramPay:(vipSetMealHandle *)mealhandle {
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:mealhandle.t_id payType:videoPayType payDeployId:self.payDeployId success:^(NSDictionary *payData) {
        NSString *path = payData[@"path"];
        WebPayViewController *vc = [[WebPayViewController alloc] init];
        vc.webUrl = path;
        UIViewController *curVC = [SLHelper getCurrentVC];
        [curVC.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)alipayMiniProgramPay:(vipSetMealHandle *)mealhandle {
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:mealhandle.t_id payType:videoPayType payDeployId:self.payDeployId success:^(NSDictionary *payData) {
        NSString *path = payData[@"path"];
        WebPayViewController *vc = [[WebPayViewController alloc] init];
        vc.webUrl = path;
        UIViewController *curVC = [SLHelper getCurrentVC];
        [curVC.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)newAlipayMiniProgramPay:(vipSetMealHandle *)mealhandle {
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:mealhandle.t_id payType:videoPayType payDeployId:self.payDeployId success:^(NSDictionary *payData) {
        [self pushToSafariWithDic:payData];
        
    }];
}

- (void)pushToSafariWithDic:(NSDictionary *)dic {
    NSString *webUrl = [NSString stringWithFormat:@"%@/app/aliH5Pay.html", INTERFACEADDRESS];
    NSString *body = nil;
    for (NSString *key in dic.allKeys) {
        if ([self isEmptyString: body]) {
            body = [NSString stringWithFormat:@"%@=%@",key,dic[key]];
        }else{
            body = [NSString stringWithFormat:@"%@&%@=%@",body,key,dic[key]];
        }
    }
    if (body.length > 0) {
        webUrl = [NSString stringWithFormat:@"%@?%@", webUrl, body];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webUrl]];
}

- (BOOL)isEmptyString:(NSString *)string
{
    if (string == nil || [string isKindOfClass:[NSNull class]] || [string isEqualToString:@"null"] ||
        [string isEqualToString:@"(null)"] || [string isEqualToString:@""] ||
        [string isEqualToString:@" "]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] ==
        0) {
        return YES;
    }
    return NO;
}

#pragma mark - 支付派
- (void)weChatMiniProgramPay:(vipSetMealHandle *)mealhandle {
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:mealhandle.t_id payType:videoPayType payDeployId:self.payDeployId success:^(NSDictionary *payData) {
        [self jumpWeChatMiniProgram:payData];
    }];
}

- (void)jumpWeChatMiniProgram:(NSDictionary *)dic {
    WXLaunchMiniProgramReq * req = [WXLaunchMiniProgramReq object];
    req.userName = dic[@"userName"];
    req.path = dic[@"path"];
    req.miniProgramType = 0;
    [WXApi sendReq:req completion:nil];
}

#pragma mark - webPay
- (void)webPay:(vipSetMealHandle *)mealhandle {
    [YLNetworkInterface goldStoreValue:[YLUserDefault userDefault].t_id setMealId:mealhandle.t_id payType:videoPayType payDeployId:self.payDeployId block:^(weixinPayHandle *hanle, NSString *apliOrderInfo) {


        WebPayViewController *vc = [[WebPayViewController alloc] init];
        vc.webUrl = apliOrderInfo;
        UIViewController *curVC = [SLHelper getCurrentVC];
        [curVC.navigationController pushViewController:vc animated:YES];

    }];
}

- (void)jumpPay:(vipSetMealHandle *)mealhandle {
    [YLNetworkInterface goldStoreValue:[YLUserDefault userDefault].t_id setMealId:mealhandle.t_id payType:videoPayType payDeployId:self.payDeployId block:^(weixinPayHandle *hanle, NSString *apliOrderInfo) {

        if (@available(iOS 10.0, *)){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:apliOrderInfo] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:apliOrderInfo]];
        }
    }];
}

- (void)wechatPayhandle:(vipSetMealHandle *)mealhandle
{
//    [YLNetworkInterface getVIPSetMealList:^(NSMutableArray *listArray) {
//        
//    }];
    [YLNetworkInterface goldStoreValue:[YLUserDefault userDefault].t_id setMealId:mealhandle.t_id payType:self->videoPayType payDeployId:self.payDeployId block:^(weixinPayHandle *hanle, NSString *apliOrderInfo) {
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = hanle.partnerid;
        req.prepayId            = hanle.prepayid;
        req.nonceStr            = hanle.noncestr;
        req.timeStamp           = [hanle.timestamp intValue];
        req.package             = hanle.package;
        req.sign                = hanle.sign;
        [WXApi sendReq:req completion:^(BOOL success) {
            
        }];
    }];
}

#pragma mark ---- 微信支付

- (void)managerDidRecvWechatPayResponse:(PayResp *)response
{
    switch (response.errCode) {
        case WXSuccess:
            [SVProgressHUD showInfoWithStatus:@"充值成功"];

            break;
        default:
            [SVProgressHUD showInfoWithStatus:@"充值失败"];

            break;
    }
}

#pragma mark ---- 支付宝支付
- (void)apliyPayhandle:(vipSetMealHandle *)mealhandle
{
    [YLNetworkInterface goldStoreValue:[YLUserDefault userDefault].t_id setMealId:mealhandle.t_id payType:self->videoPayType payDeployId:self.payDeployId block:^(weixinPayHandle *hanle, NSString *apliOrderInfo) {
        [[apliManager sharePayManager]handleOrderPayWithParams:apliOrderInfo block:^(BOOL isSuccess) {
            if (isSuccess){
                [SVProgressHUD showInfoWithStatus:@"支付成功！"];
            }
        }];
    }];
}

#pragma mark ---- 移除金币不足弹框
- (void)removeInsufficient
{
    [UIView animateWithDuration:.5 animations:^{
        self->insuffiView.frame = CGRectMake(0, APP_Frame_Height, App_Frame_Width, 343);
    } completion:^(BOOL finished) {
        [self->insuffiView removeFromSuperview];
        [self->blackView removeFromSuperview];
    }];
}

@end
