//
//  YLWithdrawalController.m
//  beijing
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
#import "YLManageAccountController.h"
#import "YLUserDefault.h"
#import "accountHandle.h"
#import "YLIncomeDetailsController.h"

typedef enum {
    YLCordiusTypeSelPrice = 0,
    YLCordiusTypeNoSelPrice,
    YLCordiusTypeOther,
} YLWithdrawCordiusType;

@interface YLWithdrawalController ()
{
    UIButton *lastButton;  //上一次点击的按钮
    UIView  *lastTapView; //上一次点击的视图
    UILabel *lastdesptLabel;
    UILabel *lasttittleLabel;

    vipSetMealHandle *mealhandle;
    accountHandle *apliHandle;
    accountHandle *wechatHandle;

    NSMutableArray *withdrawlistMuArray;
    NSMutableArray *accountArray;
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
//我的订单
@property (weak, nonatomic) IBOutlet UIView *myListView;
//总计
@property (weak, nonatomic) IBOutlet UILabel *totalCoinsLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

//支付宝
- (IBAction)alipayButtonBeClicked:(id)sender;
//微信
- (IBAction)wechatButtonBeClicked:(id)sender;

@end

@implementation YLWithdrawalController

 - (void)viewWillAppear:(BOOL)animated
{
    if ([WXApi isWXAppInstalled]){
        //安装了微信的处理
    } else {
        //没有安装微信的处理
        self.wechatView.hidden = YES;
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //获取用户可提现金币
    [self getUsableGold];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self withdrawCustomUI];
    //获取提现比例
    [self getPutforwardDiscount];
}

#pragma mark ---- customUI
- (void)withdrawCustomUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.barTintColor = KWHITECOLOR;

    self.bottomConstraint.constant = JF_BOTTOM_SPACE;
    //微信
    [self.exchangeButton.layer setCornerRadius:15.];
    [self lineView];
    
    lastButton = _alipayButton;
    _lineView.frame = CGRectMake((App_Frame_Width/2. - 70)/2., 36, 70, 1);
    [self.view addSubview:_lineView];
    
    //绑定账号
    [YLTapGesture tapGestureTarget:self sel:@selector(bandingAccountView:) view:_bangleAccountView];
    //余额
    self.balanceLabel.text = [NSString stringWithFormat:@"可用金额: %@ 金币",self.balance];
    //我的订单
    [YLTapGesture tapGestureTarget:self sel:@selector(mylistTap:) view:_myListView];
}

#pragma mark ---- 我的订单
- (void)mylistTap:(UITapGestureRecognizer *)tap
{
    YLIncomeDetailsController *incomeDetailsVC = [YLIncomeDetailsController new];
    incomeDetailsVC.title                   = @"提现明细";
    incomeDetailsVC.detailType              = YLDetailsTypeWithdrawal;
    incomeDetailsVC.putforward              = [self.balance intValue];
    [self.navigationController pushViewController:incomeDetailsVC animated:YES];
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
        } t_end_type:1];
    });
}

#pragma mark ---- 获取用户可提现金币(返回支付宝，微信账号等)
- (void)getUsableGold
{
    dispatch_queue_t queue = dispatch_queue_create("请获取用户可提现金币", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        self->accountArray = [NSMutableArray array];
        [YLNetworkInterface getUsableGold:[YLUserDefault userDefault].t_id block:^(NSMutableArray *listArray) {
            self->accountArray = listArray;
            
            for (accountHandle *handle in listArray) {
                if (handle.t_type == 0) {
                    ///支付宝
                    self.accountLabel.text = handle.t_real_name;
                    self->apliHandle = handle;
                    
                    break;
                }
            }
            
        }];
    });
}

#pragma mark ---- 构建提现比例列表
- (void)buildWithdrawalList
{
    float orighX = 15.;
    float width = (App_Frame_Width - 70)/3.;
    float height = width/7.*3.;
    if (IS_iPhone_5 || IS_iPhone_4S) {
        height = width/7.*3. + 5;
    }
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
        UILabel *yuanLabel = [YLBasicView createLabeltext:[NSString stringWithFormat:@"%@ 元",handle.t_money] size:PingFangSCFont(12) color:KWHITECOLOR textAlignment:NSTextAlignmentCenter];
        [bgVIEW addSubview:yuanLabel];
        yuanLabel.frame = CGRectMake(10, 5, bgVIEW.frame.size.width - 20, 16);
        
        //金币
        UILabel *coinsLabel = [YLBasicView createLabeltext:[NSString stringWithFormat:@"%d 金币",handle.t_gold] size:PingFangSCFont(12) color:KWHITECOLOR textAlignment:NSTextAlignmentCenter];
        [bgVIEW addSubview:coinsLabel];
        coinsLabel.frame = CGRectMake(10, 21, bgVIEW.frame.size.width - 20, 16);
        
        if (index != 0) {
            bgVIEW.backgroundColor = KCLEARCOLOR;
            [bgVIEW.layer setBorderWidth:.5];
            [bgVIEW.layer setBorderColor:IColor(138, 138, 138).CGColor];
            yuanLabel.textColor = IColor(138, 138, 138);
            coinsLabel.textColor = IColor(138, 138, 138);
        }else{
            lastTapView = bgVIEW;
            lastdesptLabel = coinsLabel;
            lasttittleLabel = yuanLabel;
            mealhandle = withdrawlistMuArray[index];
            self.totalCoinsLabel.text = [NSString stringWithFormat:@"总计:%d 金币",mealhandle.t_gold];
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
    
    tittleLabel.textColor = KWHITECOLOR;
    despLabel.textColor = KWHITECOLOR;
    
    tapView.backgroundColor = IColor(225, 78, 170);
    [tapView.layer setBorderWidth:0];
    [tapView.layer setBorderColor:KCLEARCOLOR.CGColor];
    
    self.totalCoinsLabel.text = [NSString stringWithFormat:@"总计:%d 金币",mealhandle.t_gold];
    
    if (lastTapView != tapView) {
        lastTapView.backgroundColor = KCLEARCOLOR;
        [lastTapView.layer setBorderWidth:.5];
        [lastTapView.layer setBorderColor:IColor(138, 138, 138).CGColor];
        lasttittleLabel.textColor = IColor(138, 138, 138);
        lastdesptLabel.textColor = IColor(138, 138, 138);
        
        lastTapView = tapView;
        lasttittleLabel = tittleLabel;
        lastdesptLabel = despLabel;
    }
}

#pragma mark ---- 绑定账号
- (void)bandingAccountView:(UITapGestureRecognizer *)tap
{
    YLManageAccountController *manageAccountVC = [YLManageAccountController new];

    NSString *tittle = @"支付宝";
    manageAccountVC.handle = apliHandle;
    if ([lastButton isEqual:_wechatButton]) {
        //微信
        tittle = @"微信";
        manageAccountVC.handle    = wechatHandle;
    }
    manageAccountVC.tittleName = tittle;
    [self.navigationController pushViewController:manageAccountVC animated:YES];
}

- (UIView *)lineView
{
    if (_lineView == nil) {
        _lineView = [UIView new];
        _lineView.backgroundColor = IColor(219, 0, 149);
    }
    
    return _lineView;
}

#pragma mark ---- 支付宝
- (IBAction)alipayButtonBeClicked:(id)sender {
    [_alipayButton setTitleColor:IColor(225, 79, 169) forState:UIControlStateNormal];
    [lastButton setTitleColor:KBLACKCOLOR forState:UIControlStateNormal];
    
    _payImgView.image = [UIImage imageNamed:@"Mypurse_Alipaytopay"];
    
    lastButton = _alipayButton;
    [UIView animateWithDuration:.5 animations:^{
        CGRect lineFrame = self.lineView.frame;
        lineFrame.origin.x = self.alipayView.center.x - 35.;
        self.lineView.frame = lineFrame;
    }];
    self.accountLabel.text = @"您还未绑定账号";
    
    for (accountHandle *handle in accountArray) {
        if (handle.t_type == 0) {

            ///支付宝
            self.accountLabel.text = handle.t_real_name;
            apliHandle = handle;
            
            break;
        }
    }
}


#pragma mark ---- 微信
- (IBAction)wechatButtonBeClicked:(id)sender {
    [_wechatButton setTitleColor:IColor(225, 79, 169) forState:UIControlStateNormal];
    [lastButton setTitleColor:KBLACKCOLOR forState:UIControlStateNormal];
    _payImgView.image = [UIImage imageNamed:@"Mypurse_Wechatpayment"];
    
    lastButton = _wechatButton;
    [UIView animateWithDuration:.5 animations:^{
        CGRect lineFrame = self.lineView.frame;
        lineFrame.origin.x = self.wechatView.center.x - 35.;
        self.lineView.frame = lineFrame;
    }];
    
    self.accountLabel.text = @"您还未绑定账号";

    for (accountHandle *handle in accountArray) {

        if (handle.t_type == 1) {
            ///微信
            wechatHandle = handle;
            self.accountLabel.text = handle.t_real_name;
            
            break;
        }
    }
}

#pragma mark ---- 提现
- (IBAction)withdrawalBtnClicked:(id)sender {
    if (!apliHandle && !wechatHandle) {
        [SVProgressHUD showInfoWithStatus:@"请选择提现方式！"];
    }
    
    if ([lastButton isEqual:_wechatButton]) {
        //微信
        [self confirmPutforward:wechatHandle];
    }else{
        //支付宝
        [self confirmPutforward:apliHandle];
    }
}

#pragma mark ---- 调用提现接口
- (void)confirmPutforward:(accountHandle *)handle
{
    [YLNetworkInterface confirmPutforward:mealhandle.t_id userId:[YLUserDefault userDefault].t_id putForwardId:handle.t_id withpaypass:@"" block:^(BOOL isSuccess) {
        
    }];
}

@end
