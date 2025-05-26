//
//  VIPViewController.m
//  beijing
//
//  Created by 黎 涛 on 2021/4/9.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "VIPViewController.h"
#import "VipRechargeTypeAlertView.h"
#import "WebPayViewController.h"
#import "WXApiManager.h"
#import <WXApi.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "apliManager.h"



typedef enum
{
    YLNewPayMethodAply= -1,//支付宝
    YLNewPayMethodWechat = -2,//微信
    YLNewPayMethodAply1 = -3,//第四方支付
    YLNewPayMethodWeb = -4,
    YLNewPayMethodWeMiniP = -5, //微信小程序
    YLNewPayMethodAlipayMIniP = -6, //支付派支付宝
}YLNewPayMethod;

@interface VIPViewController ()
{
    UIScrollView *scrollV;
    UILabel *timeL;
    CGFloat payListTop;
    UIButton *payBtn;
    
    int rechargeID; // 一个月  三个月
    int payDeployId; //支付类型配置编号
    YLNewPayMethod vip_payMethod;//vip充值页面的支付方式；
}
@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, strong) NSArray *payList;

@end

@implementation VIPViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setSubViews];
    [self requestEndTime];
    [self vipPayList];
    [self loadRechargeTypeListIsFirst:YES];
    
    [[SandPayGateService shared] setEnvironment:ProductEnvironment];
    [[SandPayGateService shared] setSandpayGateResultBlock:^(NSString * _Nonnull status, NSDictionary * _Nonnull dataDic) {
        
        if ([dataDic[@"funcCode"]  isEqual: @"02010005"]){
            
            [self upWxPaySDKWith:dataDic[@"tokenId"] programTyp:0 originId:dataDic[@"ghOriId"] funcCode:dataDic[@"funcCode"]];
        }
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - net
- (void)requestEndTime {
    if (self.vipEndTime.length > 0 && ![self.vipEndTime containsString:@"null"]) return;
    [YLNetworkInterface index:[YLUserDefault userDefault].t_id block:^(personalCenterHandle *handle) {
        if (handle.t_is_vip == 0) {
            self->timeL.text = [NSString stringWithFormat:@"%@到期", handle.endTime];
        }
    }];
}

- (void)loadRechargeTypeListIsFirst:(BOOL)isFirst {
    [YLNetworkInterface getPayType:^(NSMutableArray *listArray) {
        if ([listArray count] > 0) {
            self.typeArray = listArray;

            NSDictionary *dic = [listArray firstObject];
            int type   = [dic[@"payType"] intValue];
            self->vip_payMethod = type;
            self->payDeployId = [dic[@"t_id"] intValue];
            if (isFirst == NO) {
                [self showTypeAlert];
            }
        } else {
            [SVProgressHUD showInfoWithStatus:@"获取充值方式列表失败"];
        }
    }];
}

- (void)vipPayList {
    [YLNetworkInterface getVIPSetMealType:0 List:^(NSMutableArray *listArray) {
        [self setPayListViewData:listArray];
    }];
}

#pragma mark - pay list
- (void)setPayListViewData:(NSArray *)array {
    _payList = array;
    CGFloat listHeight = 125*((array.count+2)/3);
    payBtn.y = listHeight+payListTop+25;
    scrollV.contentSize = CGSizeMake(App_Frame_Width, CGRectGetMaxY(payBtn.frame)+SafeAreaBottomHeight);
    
    CGFloat gap = (App_Frame_Width-95*3)/6;
    CGFloat width = 95;
    CGFloat height = 105;
    for (int i = 0; i < array.count; i ++) {
        vipSetMealHandle *handle = array[i];
        PayListItemButton *priceB = [[PayListItemButton alloc] initWithFrame:CGRectMake(gap+(width+gap*2)*(i%3), payListTop+(height+20)*(i/3), width, height)];
        [priceB setContentWithHandle:handle];
        priceB.tag = 2000+i;
        [priceB addTarget:self action:@selector(priceViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollV addSubview:priceB];
    }
}

- (void)priceViewClick:(UIButton *)sender {
    NSInteger index = sender.tag - 2000;
    for (int i = 0; i < _payList.count; i ++) {
        PayListItemButton *priceView = [scrollV viewWithTag:i+2000];
        priceView.selected = NO;
    }
    sender.selected = YES;
    
    if (_payList.count > index) {
        vipSetMealHandle *handle = _payList[index];
        rechargeID = handle.t_id;
        [payBtn setTitle:[NSString stringWithFormat:@"立即支付￥%@元", handle.t_money] forState:0];
    } else {
        [SVProgressHUD showInfoWithStatus:@"未知错误"];
    }
}

#pragma mark - pay
- (void)pay {
    if (self.typeArray.count == 0) {
        [self loadRechargeTypeListIsFirst:NO];
    } else {
        [self showTypeAlert];
    }
}

- (void)showTypeAlert {
    VipRechargeTypeAlertView *alertView = [[VipRechargeTypeAlertView alloc] initWithTypeArray:self.typeArray];
    WEAKSELF;
    alertView.didSelectedType = ^(NSInteger typeId, NSInteger type) {
        [weakSelf payWithType:type typeId:typeId];
    };
    [self.view addSubview:alertView];
}

- (void)payWithType:(NSInteger)type typeId:(NSInteger)typeId {
    vip_payMethod = (int)type;
    payDeployId = (int)typeId;
    if (type == YLNewPayMethodAply) {
        //支付宝
        [self apliyPay];
    } else if (type == YLNewPayMethodWechat) {
        //微信
        [self wechatPay];
    } else if (type == -3 || type == -4) {
        //网页
        [self webPay];
    } else if (type == -5) {
        //支付派  微信小程序
        [self weChatMiniProgramPay];
    } else if (type == -6) {
        // 支付派 支付宝
        [self alipayMiniProgramPay];
    } else if (type == -7) {
        [self SDAlipay];
    } else if (type == -8) {
        [self SDWechatPay];
    } else if (type == -9) {
        [self SDUPPay];
    } else if (type == -11) {
        [self alipayMiniProgramPay];
    } else if (type == -12) {
        [self weChatMiniProgramPay];
    } else if (type == -13) {
        [self jumpPay];
    } else if (type == -14) {
        [self jumpPay];
    } else if (type == -15) {
        [self miniProgramPay];
    } else if (type == -17) {
        [self jumpPay];
    } else if (type == -18) {
        [self jumpPay];
    } else if (type == -19 || type == -20) {
        [self jumpPay];
    } else if (type == -21 || type == -22){
        [self jumpPay];
    }else{
        [self jumpPay];
    }
    // TODO, add btfpay
    // TODO, add 2th control
}

#pragma mark - 杉德
- (void)SDAlipay {
    [YLNetworkInterface vipStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:vip_payMethod payDeployId:payDeployId success:^(NSDictionary *payData) {
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
    [YLNetworkInterface vipStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:vip_payMethod payDeployId:payDeployId success:^(NSDictionary *payData) {
//        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:payData];
        
        [[SandPayGateService shared] queryTradeRecordInfoWith:[payData safeStringForKey:@"payUrl"]];
        
       
        
//        [dict setValue:@"[{\"sc\":\"wzsc://\",\"s\":\"iOS\",\"id\":\"com.tencent.tmgp.sgame\",\"n\":\"微信\"}]" forKey:@"meta_option"];
//
//        PySdkViewController *paySDK = [[PySdkViewController alloc] init];
//        [paySDK weixin:dict];
//        [self.navigationController pushViewController:paySDK animated:YES];
//        [paySDK.navigationController setNavigationBarHidden:NO animated:YES];
//        [paySDK.navigationItem setTitle:@"支付"];
    }];
}
-(void)upWxPaySDKWith:(NSString *)tokenId programTyp:(int)programTyp originId:(NSString *)originId funcCode:(NSString*)funcCode{
    NSString *allPath = [NSString stringWithFormat:@"pages/zf/index?token_id=%@&funcCode=%@",tokenId,funcCode];
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq new];
    launchMiniProgramReq.userName = originId;
    launchMiniProgramReq.path = allPath;
    launchMiniProgramReq.miniProgramType = programTyp;
//    [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult * _Nonnull result) {
//        NSLog(@"step=%ld result=%d\n",(long)step,result.success);
//    }];
    [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
        
    }];
    
}

- (void)SDUPPay {
    [YLNetworkInterface vipStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:vip_payMethod payDeployId:payDeployId success:^(NSDictionary *payData) {
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
- (void)miniProgramPay {
    [YLNetworkInterface vipStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:vip_payMethod payDeployId:payDeployId success:^(NSDictionary *payData) {
        NSString *path = payData[@"path"];
       WebPayViewController *vc = [[WebPayViewController alloc] init];
       vc.webUrl = path;
       [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)alipayMiniProgramPay {
    [YLNetworkInterface vipStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:vip_payMethod payDeployId:payDeployId success:^(NSDictionary *payData) {
        NSString *path = payData[@"path"];
       WebPayViewController *vc = [[WebPayViewController alloc] init];
       vc.webUrl = path;
       [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)newAlipayMiniProgramPay {
    [YLNetworkInterface vipStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:vip_payMethod payDeployId:payDeployId success:^(NSDictionary *payData) {
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
    [YLNetworkInterface vipStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:vip_payMethod payDeployId:payDeployId success:^(NSDictionary *payData) {

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
    [YLNetworkInterface vipStoreValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:vip_payMethod payDeployId:payDeployId  block:^(weixinPayHandle *payHandle,NSString *apliOrderInfo) {

        WebPayViewController *vc = [[WebPayViewController alloc] init];
        vc.webUrl = apliOrderInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)jumpPay {
    [YLNetworkInterface vipStoreValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:vip_payMethod payDeployId:payDeployId  block:^(weixinPayHandle *payHandle,NSString *apliOrderInfo) {

        if (@available(iOS 10.0, *)){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:apliOrderInfo] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:apliOrderInfo]];
        };

    }];
}

#pragma mark ---- 支付宝支付
- (void)apliyPay
{
    [YLNetworkInterface vipStoreValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:vip_payMethod payDeployId:payDeployId  block:^(weixinPayHandle *payHandle,NSString *apliOrderInfo) {
        [[apliManager sharePayManager]handleOrderPayWithParams:apliOrderInfo block:^(BOOL isSuccess) {
        if (isSuccess) {
            [SVProgressHUD showInfoWithStatus:@"充值成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        }];
    }];
}

#pragma mark ---- 微信支付
- (void)wechatPay {
    [YLNetworkInterface vipStoreValue:[YLUserDefault userDefault].t_id setMealId:rechargeID payType:vip_payMethod payDeployId:payDeployId block:^(weixinPayHandle *payHandle,NSString *apliOrderInfo) {
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = payHandle.partnerid;
        req.prepayId            = payHandle.prepayid;
        req.nonceStr            = payHandle.noncestr;
        req.timeStamp           = [payHandle.timestamp intValue];
        req.package             = payHandle.package;
        req.sign                = payHandle.sign;
        [WXApi sendReq:req completion:^(BOOL success) {
            
        }];
    }];
}


- (void)managerDidRecvWechatPayResponse:(PayResp *)response {
    switch (response.errCode) {
        case WXSuccess:
            [SVProgressHUD showInfoWithStatus:@"VIP开通成功"];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            [SVProgressHUD showInfoWithStatus:@"VIP开通失败"];
            break;
    }
}


#pragma mark - subViews
- (void)setSubViews {
    UIImageView *topIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 233)];
    topIV.image = [UIImage imageNamed:@"vip_img_bg"];
    topIV.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:topIV];
    
    UIButton *backBtn = [UIManager initWithButton:CGRectMake(0, SafeAreaTopHeight-44, 44, 44) text:@"" font:1 textColor:nil normalImg:@"AnthorDetail_back_black" highImg:nil selectedImg:nil];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width-50, SafeAreaTopHeight-35-4.5, 35, 35)];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 17.5;
    headImageView.image = [YLUserDefault userDefault].headImage;
    [self.view addSubview:headImageView];
    
    UIImageView *titleIV = [[UIImageView alloc] initWithFrame:CGRectMake(46, 115, 120, 35)];
    titleIV.image = [UIImage imageNamed:@"vip_img_hyzx"];
    [topIV addSubview:titleIV];
    
    timeL = [UIManager initWithLabel:CGRectMake(50, 150, 200, 30) text:@"未开通" font:16 textColor:UIColor.whiteColor];
    timeL.textAlignment = NSTextAlignmentLeft;
    [topIV addSubview:timeL];
    if (self.vipEndTime.length > 0 && ![self.vipEndTime containsString:@"null"]) {
        timeL.text = [NSString stringWithFormat:@"%@到期", self.vipEndTime];
    } else {
        timeL.text = @"未开通";
    }
    
    [self addScrollViewContent];
}

- (void)addScrollViewContent {
    scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 233, App_Frame_Width, APP_FRAME_HEIGHT-233)];
    scrollV.backgroundColor = UIColor.whiteColor;
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollV];
    
    [self titleLabelWithTitle:@"会员专享权益" y:10];
    
    NSArray *imgArr = @[@"vip_item_video", @"vip_item_coin", @"vip_item_recharge", @"vip_item_chat", @"vip_item_voice", @"vip_item_pic", @"vip_item_rank", @"vip_item_gift", @"vip_item_mark"];
    NSArray *titleArr = @[@"每天免费视频五分钟", @"开通赠送金币", @"充值另送金币", @"文字聊天免费", @"发送语音消息", @"发送图片消息", @"榜单隐身", @"屏蔽飘屏", @"尊贵会员标识"];
    NSArray *subTitleArr = @[@"相当于每天送你10元钱", @"开通会员则送金币", @"充值额外赠送金币", @"文字聊天完全免费", @"可以按住说话发送语音", @"拍摄或从相册选择发送图片", @"排行榜中隐身", @"屏蔽所有飘屏", @"专属会员标识，女神更喜欢"];
    for (int i = 0; i < imgArr.count; i ++) {
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width/3*(i%3), 55+105*(i/3), App_Frame_Width/3, 40)];
        icon.image = [UIImage imageNamed:imgArr[i]];
        icon.contentMode = UIViewContentModeCenter;
        [scrollV addSubview:icon];
        
        UILabel *titleL = [UIManager initWithLabel:CGRectMake(icon.x, CGRectGetMaxY(icon.frame), icon.width, 18) text:titleArr[i] font:12 textColor:XZRGB(0x333333)];
        titleL.font = [UIFont boldSystemFontOfSize:12];
        [scrollV addSubview:titleL];
        
        UILabel *subTitleL = [UIManager initWithLabel:CGRectMake(icon.x, CGRectGetMaxY(titleL.frame), icon.width, 20) text:subTitleArr[i] font:10 textColor:XZRGB(0x868686)];
        subTitleL.numberOfLines = 2;
        [scrollV addSubview:subTitleL];
        
    }
    
    CGFloat top = (imgArr.count+2)/3*105+55+20;
    [self titleLabelWithTitle:@"开通会员" y:top];
    payListTop = top+50;
    
    payBtn = [ToolManager defaultMutableColorButtonWithFrame:CGRectMake((App_Frame_Width-300)/2, payListTop+50, 300, 49) title:@"立即支付" isCycle:YES];
    [payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    [scrollV addSubview:payBtn];
    scrollV.contentSize = CGSizeMake(App_Frame_Width, CGRectGetMaxY(payBtn.frame)+SafeAreaBottomHeight);
}

- (void)titleLabelWithTitle:(NSString *)title y:(CGFloat)y {
    UILabel *label = [UIManager initWithLabel:CGRectMake(0, y, 100, 20) text:title font:14 textColor:XZRGB(0x333333)];
    label.font = [UIFont boldSystemFontOfSize:14];
    [label sizeToFit];
    CGFloat width = label.width;
    label.frame = CGRectMake((App_Frame_Width-width)/2, y, width, 20);
    [scrollV addSubview:label];
    
    UIImageView *leftIV = [[UIImageView alloc] initWithFrame:CGRectMake(label.x-20, y, 20, 20)];
    leftIV.image = [UIImage imageNamed:@"vip_img_left"];
    leftIV.contentMode = UIViewContentModeCenter;
    [scrollV addSubview:leftIV];
    
    UIImageView *rightIV = [[UIImageView alloc] initWithFrame:CGRectMake(label.x+width, y, 20, 20)];
    rightIV.image = [UIImage imageNamed:@"vip_img_right"];
    rightIV.contentMode = UIViewContentModeCenter;
    [scrollV addSubview:rightIV];
}

#pragma mark - func
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}


@end


@implementation PayListItemButton
{
    UILabel *recommendL;
    UILabel *monthL;
    UILabel *priceL;
    UILabel *moneyL;
    UILabel *coinL;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1;
        self.layer.borderColor = XZRGB(0xF4F5FB).CGColor;
    }
    return self;
}

- (void)setContentWithHandle:(vipSetMealHandle *)handle {
    if (handle.t_is_recommend) {
        recommendL = [UIManager initWithLabel:CGRectMake(0, 0, self.width, 15) text:@"推荐" font:10 textColor:UIColor.whiteColor];
        recommendL.backgroundColor = XZRGB(0xFC6EF1);
        [self addSubview:recommendL];
    }
    
    monthL = [UIManager initWithLabel:CGRectMake(0, 25, self.width, 17) text:handle.t_setmeal_name font:12 textColor:XZRGB(0x666666)];
    [self addSubview:monthL];
    
    priceL = [UIManager initWithLabel:CGRectMake(0, 42, self.width, 17) text:handle.avgDayMoney font:10 textColor:XZRGB(0x666666)];
    [self addSubview:priceL];
    
    moneyL = [UIManager initWithLabel:CGRectMake(0, 59, self.width, 24) text:[NSString stringWithFormat:@"￥%@", handle.t_money] font:14 textColor:XZRGB(0x333333)];
    moneyL.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:moneyL];
    
    coinL = [UIManager initWithLabel:CGRectMake(0, 83, self.width, 17) text:handle.t_remarks font:10 textColor:XZRGB(0x999999)];
    [self addSubview:coinL];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.layer.borderColor = XZRGB(0xFC6EF1).CGColor;
    } else {
        self.layer.borderColor = XZRGB(0xF4F5FB).CGColor;
    }
}

@end
