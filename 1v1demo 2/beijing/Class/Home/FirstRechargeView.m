//
//  FirstRechargeView.m
//  beijing
//
//  Created by 黎 涛 on 2021/4/8.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "FirstRechargeView.h"
#import "apliManager.h"
#import <SVProgressHUD.h>
#import "JChatConstants.h"
#import "YLNAccountBalanceController.h"
#import "BaseView.h"
#import "RechargePayListTableViewCell.h"
#import "RechargePayListModel.h"
#import "WebPayViewController.h"
#import "YLPushManager.h"

typedef enum
{
    YLNewPayMethodAply= -1,//支付宝
    YLNewPayMethodWechat = -2,//微信
    YLNewPayMethodAply1 = -3,//第四方支付
    YLNewPayMethodWeb = -4,
    YLNewPayMethodWeMiniP = -5, //微信小程序
    YLNewPayMethodAlipayMIniP = -6, //支付派支付宝
    YLNewPayMethodSDAlipay = -7, //杉德支付宝
    YLNewPayMethodSDWechatPay = -8, //杉德微信
    YLNewPayMethodSDUPPay = -9 //杉德银联
}YLNewPayMethod;

@implementation FirstRechargeView
{
    UIView *bgView;
    UIButton *rechargeBtn;
    NSArray *payList;
    NSArray *rechargeList;
    YLNewPayMethod coin_payMethod;//金币充值页面的支付方式；
    int rechargeID;
    int payDeployId;
}

#pragma mark - vc
- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        self.backgroundColor = UIColor.clearColor;
        rechargeID = -1111;
        payDeployId = -2222;
        [self setSubViews];
        [self requestRechargeList];
        
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

#pragma mark - net
- (void)requestRechargeList {
    [YLNetworkInterface getNewFirstChargeInfoSuccess:^(NSDictionary *dataDic) {
        if ([dataDic[@"payList"] isKindOfClass:[NSArray class]]) {
            self->payList = dataDic[@"payList"];
        } else {
            [SVProgressHUD showInfoWithStatus:@"支付方式为空"];
            return;
        }
        if ([dataDic[@"rechargeList"] isKindOfClass:[NSArray class]]) {
            self->rechargeList = dataDic[@"rechargeList"];
        } else {
            [SVProgressHUD showInfoWithStatus:@"首充套餐列表为空"];
            return;
        }
        [self addContentView];
    }];
}

#pragma makr - sub views
- (void)setSubViews {
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    tapView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
    [self addSubview:tapView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
    [tapView addGestureRecognizer:tap];
    
    CGFloat bgHeight = SafeAreaBottomHeight-49+420;
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height-bgHeight, App_Frame_Width, bgHeight)];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    UIImageView *titleIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgView.width, 55)];
    titleIV.contentMode = UIViewContentModeScaleAspectFill;
    titleIV.image = [UIImage imageNamed:@"first_r_title_img"];
    [bgView addSubview:titleIV];
    
    rechargeBtn = [ToolManager defaultMutableColorButtonWithFrame:CGRectMake((App_Frame_Width-300)/2, 320, 300, 49) title:@"支付" isCycle:YES];
    rechargeBtn.enabled = NO;
    [rechargeBtn addTarget:self action:@selector(rechargeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:rechargeBtn];
}

- (void)addContentView {
    rechargeBtn.enabled = YES;
    
    CGFloat gap = (App_Frame_Width-270-20)/2;
    UIScrollView *rechargeScr = [[UIScrollView alloc] initWithFrame:CGRectMake(gap, 75, 290, 100)];
    rechargeScr.contentSize = CGSizeMake(rechargeList.count*90+(rechargeList.count-1)*10, 100);
    [bgView addSubview:rechargeScr];
    
    for (int i = 0; i < rechargeList.count; i ++) {
        FirstMoneyListButton *btn = [[FirstMoneyListButton alloc] initWithFrame:CGRectMake(100*i, 2, 90, 96)];
        [btn setContent:rechargeList[i]];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(moneyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [rechargeScr addSubview:btn];
    }
    
    UILabel *tipL = [UIManager initWithLabel:CGRectMake(gap, 190, 200, 25) text:@"选择充值方式" font:15 textColor:XZRGB(0x333333)];
    tipL.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:tipL];
    
    UIScrollView *payScr = [[UIScrollView alloc] initWithFrame:CGRectMake(gap, 230, 290, 45)];
    payScr.contentSize = CGSizeMake(payList.count*130+(payList.count-1)*30, 45);
    [bgView addSubview:payScr];
    
    for (int i = 0; i < payList.count; i ++) {
        NSDictionary *dic = payList[i];
        PayTypeListButton *btn = [[PayTypeListButton alloc] initWithFrame:CGRectMake(160*i, 1, 130, 43)];
        btn.tag = 200+i;
        [btn setContent:dic];
        [btn addTarget:self action:@selector(payTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [payScr addSubview:btn];
        if ([[NSString stringWithFormat:@"%@", dic[@"isdefault"]] intValue] ==1 ) {
            btn.selected = YES;
            coin_payMethod = [[NSString stringWithFormat:@"%@", dic[@"payType"]] intValue];
            payDeployId = [[NSString stringWithFormat:@"%@", dic[@"t_id"]] intValue];
        }
    }
}

#pragma mark - func
- (void)moneyButtonClick:(UIButton *)sender {
    for (int i = 0; i < 3; i ++) {
        FirstMoneyListButton *btn = [bgView viewWithTag:100+i];
        btn.selected = NO;
    }
    sender.selected = YES;
    
    NSInteger index = sender.tag-100;
    NSDictionary *dic = rechargeList[index];
    rechargeID = [[NSString stringWithFormat:@"%@", dic[@"t_id"]] intValue];
}

- (void)payTypeButtonClick:(UIButton *)sender {
    for (int i = 0; i < 2; i ++) {
        PayTypeListButton *btn = [bgView viewWithTag:200+i];
        btn.selected = NO;
    }
    sender.selected = YES;
    
    NSInteger index = sender.tag-200;
    NSDictionary *dic = payList[index];
    coin_payMethod = [[NSString stringWithFormat:@"%@", dic[@"payType"]] intValue];
    payDeployId = [[NSString stringWithFormat:@"%@", dic[@"t_id"]] intValue];
}

#pragma mark - pay
- (void)rechargeButtonClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    
    if (rechargeID == -1111) {
        [SVProgressHUD showInfoWithStatus:@"请选择充值套餐"];
        return;
    }
    
    if (payDeployId == -2222) {
        [SVProgressHUD showInfoWithStatus:@"请选择支付类型"];
        return;
    }
    
    if (coin_payMethod == YLNewPayMethodAply) {
        //支付宝
        [self apliyPay];
    } else if (coin_payMethod == YLNewPayMethodWechat) {
        //微信
        [self wechatPay];
    } else if (coin_payMethod == -3 || coin_payMethod == -4) {
        //网页
        [self webPay];
    } else if (coin_payMethod == -5) {
        //支付派  微信小程序
        [self weChatMiniProgramPay];
    } else if (coin_payMethod == -6) {
        [self alipayMiniProgramPay];
    }
//    else if (coin_payMethod == -7) {
//        [self newAlipayMiniProgramPay];
//    }
    else if (coin_payMethod == YLNewPayMethodSDAlipay) {
        [self SDAlipay];
    } else if (coin_payMethod == YLNewPayMethodSDWechatPay) {
        [self SDWechatPay];
    } else if (coin_payMethod == YLNewPayMethodSDUPPay) {
        [self SDUPPay];
    } else if (coin_payMethod == -13 || coin_payMethod == -14) {
        //网页
        [self jumpPay];
    } else if (coin_payMethod == -15) {
        [self alipayMiniProgramPay];
    } else if (coin_payMethod == -17 || coin_payMethod == -18 || coin_payMethod == -19 || coin_payMethod == -20) {
        //网页
        [self jumpPay];
     }else if (coin_payMethod == -11 || coin_payMethod == -12) {
        //网页
        [self jumpPay];
    } else if (coin_payMethod == -21 || coin_payMethod == -22)  {
        //网页
        [self jumpPay];
     }
    
    // TODO, add btfpay
    // TODO, add 2th control
}

#pragma mark - 杉德
- (void)SDAlipay {
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:coin_payMethod payDeployId:payDeployId success:^(NSDictionary *payData) {
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

- (void)SDWechatPay {
    
}

- (void)SDUPPay {
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:coin_payMethod payDeployId:payDeployId success:^(NSDictionary *payData) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:payData];
        [dict setValue:@"[{\"sc\":\"testapp://\",\"s\":\"iOS\",\"id\":\"com.pay.paytypetest\",\"n\":\"云闪付\"}]" forKey:@"meta_option"];
                        
        PySdkViewController *paySDK = [[PySdkViewController alloc] init];
                        
        paySDK.UPPayPayBlock = ^(NSString * tn){
            UIViewController *nowVC = [SLHelper getCurrentVC];
            [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"UPPayDemo://" mode:@"00" viewController:nowVC];
        };
                        
        [paySDK UPPay:dict];
        UIViewController *nowVC = [SLHelper getCurrentVC];
        [nowVC.navigationController pushViewController:paySDK animated:YES];
        [paySDK.navigationController setNavigationBarHidden:NO animated:YES];
        [paySDK.navigationItem setTitle:@"支付"];
    }];
    
}

#pragma mark - 支付派 支付宝
- (void)alipayMiniProgramPay {
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:coin_payMethod payDeployId:payDeployId success:^(NSDictionary *payData) {
        NSString *path = payData[@"path"];
        WebPayViewController *vc = [[WebPayViewController alloc] init];
        vc.webUrl = path;
        UIViewController *nowVC = [SLHelper getCurrentVC];
        [nowVC.navigationController pushViewController:vc animated:YES];
        
    }];
}

- (void)newAlipayMiniProgramPay {
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:coin_payMethod payDeployId:payDeployId success:^(NSDictionary *payData) {
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

#pragma mark - 支付派 微信
- (void)weChatMiniProgramPay {
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:coin_payMethod payDeployId:payDeployId success:^(NSDictionary *payData) {
        
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
- (void)webPay {
    [YLNetworkInterface goldStoreValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:coin_payMethod payDeployId:payDeployId block:^(weixinPayHandle *hanle, NSString *apliOrderInfo) {
        WebPayViewController *vc = [[WebPayViewController alloc] init];
        vc.webUrl = apliOrderInfo;
        UIViewController *nowVC = [SLHelper getCurrentVC];
        [nowVC.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)jumpPay {
    [YLNetworkInterface goldStoreValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:coin_payMethod payDeployId:payDeployId block:^(weixinPayHandle *hanle, NSString *apliOrderInfo) {
   
        if (@available(iOS 10.0, *)){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:apliOrderInfo] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:apliOrderInfo]];
        }
    }];
}

#pragma mark ---- 支付宝支付
- (void)apliyPay {
    [YLNetworkInterface goldStoreValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:coin_payMethod payDeployId:payDeployId block:^(weixinPayHandle *hanle, NSString *apliOrderInfo) {
        [[apliManager sharePayManager]handleOrderPayWithParams:apliOrderInfo block:^(BOOL isSuccess) {
            if (isSuccess) {
                [SVProgressHUD showInfoWithStatus:@"金币充值成功"];
                UIViewController *nowVC = [SLHelper getCurrentVC];
                [nowVC.navigationController popToRootViewControllerAnimated:NO];
            }
        }];
    }];
}

#pragma mark ---- 微信支付
- (void)wechatPay {
    [YLNetworkInterface goldStoreValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:coin_payMethod payDeployId:payDeployId block:^(weixinPayHandle *hanle, NSString *apliOrderInfo) {
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = hanle.partnerid;
        req.prepayId            = hanle.prepayid;
        req.nonceStr            = hanle.noncestr;
        req.timeStamp           = [hanle.timestamp intValue];
        req.package             = hanle.package;
        req.sign                = hanle.sign;
        [WXApi sendReq:req completion:nil];
    }];
}

- (void)managerDidRecvWechatPayResponse:(PayResp *)response {
    switch (response.errCode) {
        case WXSuccess:
            [SVProgressHUD showInfoWithStatus:@"充值成功"];
            
            break;
        default:
            [SVProgressHUD showInfoWithStatus:@"充值失败"];
            
            break;
    }
}


@end

@implementation FirstMoneyListButton
{
    UILabel *moneyL;
    UILabel *tipL;
    UILabel *coinL;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 7;
        self.layer.borderWidth = 1;
        self.layer.borderColor = XZRGB(0xebebeb).CGColor;
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = XZRGB(0xAE4FFD);
        self.layer.borderColor = UIColor.clearColor.CGColor;
        moneyL.textColor = UIColor.whiteColor;
        tipL.textColor = UIColor.whiteColor;
        coinL.textColor = UIColor.whiteColor;
    } else {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.borderColor = XZRGB(0xebebeb).CGColor;
        moneyL.textColor = XZRGB(0x333333);
        tipL.textColor = XZRGB(0x666666);
        coinL.textColor = XZRGB(0x666666);
    }
}

- (void)setContent:(NSDictionary *)dic {
    CGFloat height = (self.height-20)/3;
    moneyL = [UIManager initWithLabel:CGRectMake(0, 10, self.width, height) text:[NSString stringWithFormat:@"充值%@元", dic[@"t_money"]] font:13 textColor:XZRGB(0x333333)];
    moneyL.adjustsFontSizeToFitWidth = YES;
    [self addSubview:moneyL];
    
    coinL = [UIManager initWithLabel:CGRectMake(0, 10+height, self.width, height) text:[NSString stringWithFormat:@"%@金币", dic[@"t_gold"]] font:16 textColor:XZRGB(0x666666)];
    [self addSubview:coinL];
    
    tipL = [UIManager initWithLabel:CGRectMake(0, 10+height*2, self.width, height) text:[NSString stringWithFormat:@"赠送%@金币", dic[@"t_give_gold"]] font:10 textColor:XZRGB(0x999999)];
    [self addSubview:tipL];
    
}


@end

@implementation PayTypeListButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1;
        self.layer.borderColor = XZRGB(0xebebeb).CGColor;
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.layer.borderColor = XZRGB(0xAE4FFD).CGColor;
    } else {
        self.layer.borderColor = XZRGB(0xebebeb).CGColor;
    }
}

- (void)setContent:(NSDictionary *)dic {
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, (self.height-20)/2, 20, 20)];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", dic[@"payIcon"]]]];
    [self addSubview:icon];
    
    UILabel *lb = [UIManager initWithLabel:CGRectMake(50, 0, self.width-50, self.height) text:dic[@"payName"] font:15 textColor:XZRGB(0x333333)];
    lb.textAlignment = NSTextAlignmentLeft;
    lb.numberOfLines = 2;
    [self addSubview:lb];
}

@end
