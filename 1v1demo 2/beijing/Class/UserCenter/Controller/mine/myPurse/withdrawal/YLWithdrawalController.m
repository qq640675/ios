//
//  YLWithdrawalController.m
//  yiliao
//
//  Created by zhou last on 2018/6/20.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLWithdrawalController.h"
#import "DefineConstants.h"
#import <Masonry.h>
#import "YLTapGesture.h"
#import <WXApi.h>
#import "YLNetworkInterface.h"
#import "WXApiManager.h"
#import <SVProgressHUD.h>
#import "YLBasicView.h"
#import "vipSetMealHandle.h"

#import <WechatAuthSDK.h>
#import "WXApiManager.h"

typedef enum {
    YLCordiusTypeSelPrice = 0,
    YLCordiusTypeNoSelPrice,
    YLCordiusTypeOther,
} YLWithdrawCordiusType;

@interface YLWithdrawalController ()<WechatAuthAPIDelegate,WXApiManagerDelegate>
{
    UIButton *lastButton;  //上一次点击的按钮
    UIView  *lastTapView; //上一次点击的视图
    UILabel *lastdesptLabel;
    UILabel *lasttittleLabel;

    vipSetMealHandle *mealhandle;
    NSMutableArray *withdrawlistMuArray;
}

//提现比例列表
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
#pragma mark ---- 金额
@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;
//线
@property (nonatomic ,strong) UIView *lineView;
//支付宝
@property (weak, nonatomic) IBOutlet UIButton *alipayButton;
//微信
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
//绑定账号
@property (weak, nonatomic) IBOutlet UIView *bangleAccountView;
//账号
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
//支付宝
@property (weak, nonatomic) IBOutlet UIView *alipayView;
//微信
@property (weak, nonatomic) IBOutlet UIView *wechatView;
@property (weak, nonatomic) IBOutlet UIImageView *payImgView;
//余额
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
//提现背景
@property (weak, nonatomic) IBOutlet UIView *withdrawBgView;

//支付宝
- (IBAction)alipayButtonBeClicked:(id)sender;
//微信
- (IBAction)wechatButtonBeClicked:(id)sender;

@end

@implementation YLWithdrawalController

 - (void)viewWillAppear:(BOOL)animated
{
    [self getPutforwardDiscount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self withdrawCustomUI];
}

#pragma mark ---- customUI
- (void)withdrawCustomUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //微信
    [WXApiManager sharedManager].delegate = self;
    [self.exchangeButton.layer setCornerRadius:15.];
    [self lineView];
    
    lastButton = _alipayButton;
    _lineView.frame = CGRectMake((App_Frame_Width/2. - 70)/2., 36, 70, 1);
    [self.view addSubview:_lineView];
    
    //绑定账号
    [YLTapGesture tapGestureTarget:self sel:@selector(bandingAccountView:) view:_bangleAccountView];
    //余额
    self.balanceLabel.text = [NSString stringWithFormat:@"当前余额: %@ 金币",self.balance];
}

#pragma mark ---- 获取提现比例
- (void)getPutforwardDiscount
{
    dispatch_queue_t queue = dispatch_queue_create("请求充值列表数据", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        self->withdrawlistMuArray = [NSMutableArray array];
        [YLNetworkInterface getPutforwardDiscount:^(NSMutableArray *listArray) {
            self->withdrawlistMuArray = listArray;
            
            [self buildWithdrawalList];
        }];
    });
}

#pragma mark ---- 构建提现比例列表
- (void)buildWithdrawalList
{
    float orighX = 15.;
    float width = (App_Frame_Width - 70)/3.;
    float height = width/7.*3.;
    float orighY = 40 +15. - height - 10;
    
    if (withdrawlistMuArray.count % 3 == 0) {
        _heightConstraint.constant = withdrawlistMuArray.count / 3  * (height + 10) +50+ 25;
    }else{
        _heightConstraint.constant = withdrawlistMuArray.count / 3  * (height + 10) +50+ 25;
    }
    
    for (int index = 0; index < withdrawlistMuArray.count; index ++) {
        vipSetMealHandle *handle = withdrawlistMuArray[index];
        
        UIView *bgVIEW = [YLBasicView createView:IColor(225, 78, 170) alpha:1.];
        [bgVIEW.layer setCornerRadius:height/2.];
        bgVIEW.userInteractionEnabled = YES;
        bgVIEW.tag = 100 + index;
        [YLTapGesture tapGestureTarget:self sel:@selector(selWithdrawalKind:) view:bgVIEW];
        [self.withdrawBgView addSubview:bgVIEW];
        
        if (index % 3 == 0) {
            orighX = 15;
            orighY += height + 10;
        }else{
            if (index % 3 == 0) {
                orighX = 15;
            }else if (index % 3 == 1){
                orighX = App_Frame_Width/2. - width/2.;
            }else{
                orighX = App_Frame_Width - width - 15;
            }
        }
        bgVIEW.frame = CGRectMake(orighX, orighY, width, height);
        
        //元
        UILabel *yuanLabel = [YLBasicView createLabeltext:[NSString stringWithFormat:@"%@ 元",handle.t_money] size:PingFangSCFont(14) color:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        [bgVIEW addSubview:yuanLabel];
        yuanLabel.frame = CGRectMake(10, 5, bgVIEW.frame.size.width - 20, 16);
        
        //金币
        UILabel *coinsLabel = [YLBasicView createLabeltext:[NSString stringWithFormat:@"%d 金币",handle.t_gold] size:PingFangSCFont(14) color:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        [bgVIEW addSubview:coinsLabel];
        coinsLabel.frame = CGRectMake(10, 21, bgVIEW.frame.size.width - 20, 16);
        
        if (index != 0) {
            bgVIEW.backgroundColor = [UIColor clearColor];
            [bgVIEW.layer setBorderWidth:.5];
            [bgVIEW.layer setBorderColor:IColor(138, 138, 138).CGColor];
            yuanLabel.textColor = IColor(138, 138, 138);
            coinsLabel.textColor = IColor(138, 138, 138);
        }else{
            lastTapView = bgVIEW;
            lastdesptLabel = coinsLabel;
            lasttittleLabel = yuanLabel;
            mealhandle = withdrawlistMuArray[index];
        }
    }
}

- (void)selWithdrawalKind:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    int index = (int)tap.view.tag - 100;
    
    mealhandle = withdrawlistMuArray[index];
    
    UILabel *tittleLabel = [tapView subviews][0];
    UILabel *despLabel = [tapView subviews][1];
    
    tittleLabel.textColor = [UIColor whiteColor];
    despLabel.textColor = [UIColor whiteColor];
    
    tapView.backgroundColor = IColor(225, 78, 170);
    [tapView.layer setBorderWidth:0];
    [tapView.layer setBorderColor:[UIColor clearColor].CGColor];
    
    lastTapView.backgroundColor = [UIColor clearColor];
    [lastTapView.layer setBorderWidth:.5];
    [lastTapView.layer setBorderColor:IColor(138, 138, 138).CGColor];
    lasttittleLabel.textColor = IColor(138, 138, 138);
    lastdesptLabel.textColor = IColor(138, 138, 138);
    
    lastTapView = tapView;
    lasttittleLabel = tittleLabel;
    lastdesptLabel = despLabel;
}

#pragma mark ---- 绑定账号
- (void)bandingAccountView:(UITapGestureRecognizer *)tap
{
    if ([WXApi isWXAppInstalled])
    {
        //        [self sendAuthRequest];
        [self sendAuthRequestScope:@"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"@"" State:@"xxx" OpenID:@"" InViewController:self];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您的手机未安装微信"];
    }
}

- (BOOL)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
            InViewController:(UIViewController *)viewController {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = scope; // @"post_timeline,sns"
    req.state = state;
    //    req.openID = openID;
    
    return [WXApi sendAuthReq:req
               viewController:viewController
                     delegate:[WXApiManager sharedManager]];
    
    return YES;
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response
{
    NSLog(@"____reson:%@",response.code);
    [self getAccessToken:response.code];
}

#pragma mark ----获取oppenid token
- (void)getAccessToken:(NSString *)code
{
    dispatch_queue_t queue = dispatch_queue_create("获取oppenid token", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        [YLNetworkInterface getAccess_token:code wechatBlock:^(NSString *access_token, NSString *openid, NSString *refresh_token) {
            [self checkToken:access_token openId:openid];
            NSLog(@"_____freshToken:%@",refresh_token);
        }];
    });
    // [YLNetworkInterface refreshAccess_token:refresh_token]; //刷新token
}

#pragma mark ----检验token是否可用
- (void)checkToken:(NSString*)accessToken openId:(NSString *)opendId
{
    dispatch_queue_t queue = dispatch_queue_create("检验token是否可用", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        [YLNetworkInterface checkAccess_token:accessToken oppenId:opendId block:^(BOOL isSuccess) {
            if (isSuccess) {
                [self getWechatUserInfo:accessToken openId:opendId];
            }
        }];
    });
}

#pragma mark ----获取微信个人信息
- (void)getWechatUserInfo:(NSString *)accessToken openId:(NSString *)openId
{
    dispatch_queue_t queue = dispatch_queue_create("我的个人资料", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        [YLNetworkInterface getWechatInfoOpenId:openId acesstoken:accessToken block:^(NSString *nickname, NSString *headimgurl, NSString *province, int sex, NSString *city) {
            NSLog(@"_____oper:%@",nickname);
            self.accountLabel.text = nickname;
        }];
    });
}

- (UIView *)lineView
{
    if (_lineView == nil) {
        _lineView = [UIView new];
        _lineView.backgroundColor = IColor(219, 0, 149);
    }
    
    return _lineView;
}

- (IBAction)alipayButtonBeClicked:(id)sender {
    [_alipayButton setTitleColor:IColor(225, 79, 169) forState:UIControlStateNormal];
    [lastButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _payImgView.image = [UIImage imageNamed:@"Mypurse_Alipaytopay"];
    
    lastButton = _alipayButton;
    [UIView animateWithDuration:.5 animations:^{
        CGRect lineFrame = self.lineView.frame;
        lineFrame.origin.x = self.alipayView.center.x - 35.;
        self.lineView.frame = lineFrame;
    }];
}

- (IBAction)wechatButtonBeClicked:(id)sender {
    [_wechatButton setTitleColor:IColor(225, 79, 169) forState:UIControlStateNormal];
    [lastButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _payImgView.image = [UIImage imageNamed:@"Mypurse_Wechatpayment"];
    
    lastButton = _wechatButton;
    [UIView animateWithDuration:.5 animations:^{
        CGRect lineFrame = self.lineView.frame;
        lineFrame.origin.x = self.wechatView.center.x - 35.;
        self.lineView.frame = lineFrame;
    }];
}
@end
