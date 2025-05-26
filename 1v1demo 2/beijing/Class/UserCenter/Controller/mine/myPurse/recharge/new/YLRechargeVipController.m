//
//  YLRechargeVipController.m
//  beijing
//
//  Created by zhou last on 2018/10/27.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLRechargeVipController.h"
#import "newRechargeCoinView.h"
#import <Masonry.h>
#import "DefineConstants.h"
#import "YLBasicView.h"
#import "YLTapGesture.h"
#import "YLUserDefault.h"
#import "YLNetworkInterface.h"
#import "vipSetMealHandle.h"
#import "apliManager.h"
#import <SVProgressHUD.h>
#import "WXApiManager.h"
#import <WXApi.h>
#import <TencentOpenAPI/TencentOAuth.h>
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
    YLNewPayMethodSDUPPay = -9, //杉德银联
    YLNewPayMethodEasyAliPay = -12, //易支付
    YLNewPayMethodEasyWXPay = -13 //易支付
}YLNewPayMethod;

@interface YLRechargeVipController ()<WXApiManagerDelegate,RechargePayListTableViewCellDelegate>
{
    UIImageView *lastTapView; //上一次点击的充值背景
    UILabel *lastYuanLabel; //上一次点击的元(9，16，28元等不同金额)
    UILabel *lastCoinLabel; //上一次点击的金币(80，160金币等不同金币)
    
    NSMutableArray *rechargeListMuArray;//充值面额
    NSMutableArray *vipListArray;
    vipSetMealHandle *mealhandle;
    
    int myCoinNum; //我的金币数
    
    int rechargeID;//一个月的vip
    
    YLNewPayMethod coin_payMethod;//金币充值页面的支付方式；
    
}

@property (weak, nonatomic) IBOutlet UIView     *navigationView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *rechargeCoinBtn;

@property (weak, nonatomic) IBOutlet UIButton *vipBtn;

@property (weak, nonatomic) IBOutlet UITableView *rechargeTableView;

@property (nonatomic, strong) RechargePayListModel  *payListModel;

//支付类型配置编号
@property (nonatomic, assign) NSInteger     payDeployId;

@end

@implementation YLRechargeVipController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.heightConstraint.constant = SafeAreaTopHeight;
    self.payHeightConstraint.constant = JF_BOTTOM_SPACE + 49;
    [WXApiManager sharedManager].delegate = self;

    
    [_rechargeTableView registerClass:[RechargePayListTableViewCell class] forCellReuseIdentifier:@"coin_rechargeCell"];
    [_rechargeTableView registerClass:[RechargePayListTableViewCell class] forCellReuseIdentifier:@"vip_rechargeCell"];
    
    self.payListModel = [RechargePayListModel new];
    
    // 默认显示更多支付方式
    _payListModel.isOpenMorePay = YES;
    
    [self getDataWithPayType];
    [[SandPayGateService shared] setEnvironment:ProductEnvironment];
    [[SandPayGateService shared] setSandpayGateResultBlock:^(NSString * _Nonnull status, NSDictionary * _Nonnull dataDic) {
        
        if ([dataDic[@"funcCode"]  isEqual: @"02010005"]){
            
            [self upWxPaySDKWith:dataDic[@"tokenId"] programTyp:0 originId:dataDic[@"ghOriId"] funcCode:dataDic[@"funcCode"]];
        }
        
    }];
}

- (void)getDataWithPayType {
    
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    [YLNetworkInterface getPayType:^(NSMutableArray *listArray) {
        if ([listArray count] > 0) {
            self.payListModel.listArray = listArray;
            self.payListModel.selectIndex = 0;
            
            NSDictionary *dic = [self.payListModel.listArray firstObject];

            int type   = [dic[@"payType"] intValue];
            self.payDeployId = [dic[@"t_id"] integerValue];
            self->coin_payMethod = type;
            [self getRechargeDiscount:(int)type];
        }

    }];
}

#pragma mark ---- 请求充值列表数据
- (void)getRechargeDiscount:(int)payType
{
    dispatch_queue_t queue = dispatch_queue_create("请求充值列表数据", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        self->rechargeListMuArray = [NSMutableArray array];
        [YLNetworkInterface getRechargeDiscount:payType block:^(NSMutableArray *listArray) {
            self->rechargeListMuArray = listArray;
            
            [self.rechargeTableView reloadData];
        }];
    });
    
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        [YLNetworkInterface index:[YLUserDefault userDefault].t_id block:^(personalCenterHandle *handle) {
            self->myCoinNum = [handle.amount intValue];
            
            [SVProgressHUD dismiss];
            [self.rechargeTableView reloadData];
        }];
    });
    
    
   
}

#pragma mark ---- TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        return 175;
    }
    else if (row == 1) {
        if (_payListModel.isOpenMorePay) {
            return _payListModel.listArray.count*60+30+30+20;
        } else {
            if (_payListModel.listArray.count == 1) {
                return 90 + 20;
            }
            return 120 + 20;
        }
        
    } else {
        if (rechargeListMuArray.count/3 == rechargeListMuArray.count/3.){
            return 80 * (rechargeListMuArray.count/3) + 20;
        } else {
            return 80 * (rechargeListMuArray.count/3 +1) + 20;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //提现
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newRechargeVipCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newRechargeVipCell"];
    }else{
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = indexPath.row;
    if (row == 0) {
        NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"newRechargeCoinView" owner:nil options:nil];
        newRechargeCoinView *rCoinView = xibArray[0];
        [cell.contentView addSubview:rCoinView];
        
        [rCoinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(App_Frame_Width);
            make.height.mas_equalTo(175.);
        }];
        rCoinView.myCoinLabel.text = [NSString stringWithFormat:@"%d",myCoinNum];
        
        [YLTapGesture addTaget:self sel:@selector(accountDetailBtnClicked) view:rCoinView.accountDetailBtn];
        return cell;
    } else if (row == 1) {
        
        RechargePayListTableViewCell *coin_rechargeCell = [tableView dequeueReusableCellWithIdentifier:@"coin_rechargeCell"];
        [coin_rechargeCell initWithData:_payListModel];
        coin_rechargeCell.delegate = self;
        return coin_rechargeCell;
    } else {
        [self buildRechargeList:cell];
        return cell;
    }
}

- (void)clickedOpenBtn:(UIButton *)btn {
    btn.selected = YES;
    vipSetMealHandle *handle = vipListArray[btn.tag];
    rechargeID = handle.t_id;
}

- (void)didSelectRechargePayListTableViewCellWithBtn:(NSInteger)tag {
    if (tag == 101) {
        _payListModel.isOpenMorePay = YES;
        
        [self.rechargeTableView reloadData];
    } else {
        _payListModel.selectIndex = tag - 102;
        
        NSDictionary *dic = self.payListModel.listArray[_payListModel.selectIndex];
        int type   = [dic[@"payType"] intValue];
        self.payDeployId = [dic[@"t_id"] integerValue];
        coin_payMethod = type;
        [SVProgressHUD showWithStatus:@"努力加载中..."];
        rechargeListMuArray = [NSMutableArray array];
        [YLNetworkInterface getRechargeDiscount:(int)type block:^(NSMutableArray *listArray) {
            [SVProgressHUD dismiss];
            self->rechargeListMuArray = listArray;
            
            [self.rechargeTableView reloadData];
        }];
    }
    
}

#pragma mark ---- 布局cell
- (void)buildRechargeList:(UITableViewCell *)cell {
    float orighX = 18.;
    float width = (App_Frame_Width - 36 - 16)/3.;
    float height = 70;
    float orighY = 10;
    
    for (int index = 0; index < rechargeListMuArray.count; index ++) {
        vipSetMealHandle *handle = rechargeListMuArray[index];
        
        UIImageView *listImgView = [UIImageView new];
        listImgView.userInteractionEnabled = YES;
        listImgView.tag = 100 + index;
        listImgView.frame = CGRectMake(orighX, orighY, width, height);
        [YLTapGesture tapGestureTarget:self sel:@selector(chargeKindViewTap:) view:listImgView];
        [cell.contentView addSubview:listImgView];
        

        //元
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.paddingCharacter = @"?";
        numberFormatter.paddingPosition = NSNumberFormatterPadBeforePrefix;
        numberFormatter.positiveSuffix = @"元";
        // 小数位
        numberFormatter.maximumFractionDigits = 2;
        numberFormatter.minimumFractionDigits = 0;
        
        NSNumber *yuanValue = [NSNumber numberWithDouble:[handle.t_money doubleValue]];
        UILabel *yuanLabel = [YLBasicView createLabeltext:[numberFormatter stringFromNumber:yuanValue] size:[UIFont boldSystemFontOfSize:16.0f] color:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        
        [listImgView addSubview:yuanLabel];
        yuanLabel.frame = CGRectMake(0, 14, listImgView.frame.size.width, height/2. - 4);

        //金币
        UILabel *coinsLabel = [YLBasicView createLabeltext:[NSString stringWithFormat:@"%d金币",handle.t_gold] size:PingFangSCFont(15) color:IColor(101, 101, 101) textAlignment:NSTextAlignmentCenter];
        [listImgView addSubview:coinsLabel];
        
        //描述
        if (handle.t_describe.length > 0) {
            UIImageView *descImageView = [[UIImageView alloc] initWithFrame:CGRectMake((listImgView.frame.size.width-90)/2, 0, 90, 15)];
            descImageView.tag = 10086;
            descImageView.image = IChatUImage(@"insufficient_coin_desc");
            
            UILabel *descLb = [UIManager initWithLabel:CGRectMake(0, 0, 90, 15) text:handle.t_describe font:10.0f textColor:[UIColor whiteColor]];
            descLb.tag = 10087;
            [descImageView addSubview:descLb];
            
            [listImgView addSubview:descImageView];
        }
        
        coinsLabel.frame = CGRectMake(10, height/2. + 3, listImgView.frame.size.width - 20, height/2. - 10);
        
        if ((index + 1) % 3 == 0) {
            orighX = 18;
            orighY = (index + 1)/3 * 80 + 10;
        }else{
            orighX += width + 8;
        }
        
        listImgView.clipsToBounds = YES;
        listImgView.layer.cornerRadius = 5;
        listImgView.layer.borderWidth  = 1;
        
        //默认值是第一中间面额选中状态
        if (index != 1) {
            
            listImgView.layer.borderColor = XZRGB(0xebebeb).CGColor;
            yuanLabel.textColor  = [UIColor blackColor];
            coinsLabel.textColor = IColor(101, 101, 101);
        }else{
            listImgView.image = [UIImage imageNamed:@"insufficient_coin_sel"];
            listImgView.layer.borderColor = XZRGB(0xfe2947).CGColor;
            yuanLabel.textColor = XZRGB(0xfe2947);
            coinsLabel.textColor = IColor(251, 25, 63);
            
            lastTapView = listImgView;
            lastYuanLabel = yuanLabel;
            lastCoinLabel = coinsLabel;
            mealhandle = rechargeListMuArray[index];
        }
    }
}

#pragma mark ---- 账单详情
- (void)accountDetailBtnClicked {
    YLNAccountBalanceController *myPurseVC = [YLNAccountBalanceController new];
    myPurseVC.title             = @"账单详情";
    [self.navigationController pushViewController:myPurseVC animated:YES];
}

#pragma mark ---- 不同充值面额切换
- (void)chargeKindViewTap:(UITapGestureRecognizer *)tap {
    UIImageView *selImgView = (UIImageView *)tap.view;
    UILabel *yuanLabel = (UILabel *)[selImgView subviews][0];
    UILabel *coinLabel = (UILabel *)[selImgView subviews][1];
    
    lastTapView.layer.borderColor = XZRGB(0xebebeb).CGColor;
    lastTapView.image = nil;
    selImgView.layer.borderColor = XZRGB(0xfe2947).CGColor;
    selImgView.image = [UIImage imageNamed:@"insufficient_coin_sel"];
    
    
    [self chageColor:lastTapView isSel:NO];
    [self chageColor:selImgView isSel:YES];
    
    lastTapView = selImgView;
    lastYuanLabel = yuanLabel;
    lastCoinLabel = coinLabel;
    mealhandle = rechargeListMuArray[tap.view.tag - 100];
}

#pragma mark ---- 改变充值面额选中或未选中的颜色
- (void)chageColor:(UIImageView *)selImgView isSel:(BOOL)isSel {
    if (isSel) {
        UILabel *yuanLabel = (UILabel *)[selImgView subviews][0];
        UILabel *coinLabel = (UILabel *)[selImgView subviews][1];
        
        coinLabel.textColor = IColor(251, 25, 63);
        yuanLabel.textColor = XZRGB(0xfe2947);
    }else{
        lastCoinLabel.textColor = IColor(101, 101, 101);
        lastYuanLabel.textColor = [UIColor blackColor];
    }
}

#pragma mark ---- 改变选择与取消选择的状态
- (void)changeStatusSel:(UIView *)bgView sel:(BOOL)sel {
    //边框图
    UIImageView *kuangImgView = (UIImageView *)[bgView subviews][0];
    //皇冠
    UIImageView *guanImgView = (UIImageView *)[bgView subviews][1];
    //月
    UILabel *monthLabel = (UILabel *)[bgView subviews][2];
    //钱
    UILabel *moneyLabel = (UILabel *)[bgView subviews][4];
    if (sel) {
        [kuangImgView setImage:[UIImage imageNamed:@"vip_recharge_sel"]];
        [guanImgView setImage:[UIImage imageNamed:@"vip_member_white"]];
        [monthLabel setTextColor:KWHITECOLOR];
        [moneyLabel setTextColor:KWHITECOLOR];
    }else{
        [kuangImgView setImage:[UIImage imageNamed:@"vip_recharge_unsel"]];
        [guanImgView setImage:[UIImage imageNamed:@"vip_member_yellow"]];
        [monthLabel setTextColor:KBLACKCOLOR];
        [moneyLabel setTextColor:XZRGB(0xfe2947)];
    }
}

#pragma mark ---- 客服
- (IBAction)customerClick:(id)sender {

    [YLPushManager pushService];
}
#pragma mark ---- 开通vip
- (IBAction)vipBtnClicked:(id)sender {
}
#pragma mark ---- 充值金币
- (IBAction)rechargeCoinBtnClicked:(id)sender {
}

#pragma mark ---- 返回
- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- 去支付
- (IBAction)toPayBtnBeClicked:(id)sender {
    
    
    
    if (mealhandle.t_id == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择充值套餐"];
        return;
    }
    
//    if (_payDeployId == -2222) {
//        [SVProgressHUD showInfoWithStatus:@"请选择支付类型"];
//        return;
//    }
    
    
    
    
    if (coin_payMethod == YLNewPayMethodAply) {
        //支付宝
        [self apliyPay];
    } else if (coin_payMethod == YLNewPayMethodWechat) {
        //微信
        [self wechatPay];
    } else if (coin_payMethod == -3 || coin_payMethod == -4) {
        //网页
        [self webPay];
    } else if(coin_payMethod == -12){
        //聚合支付宝支付
        [self jumpPay];
    } else if(coin_payMethod == -13){
        //聚合支付微信
        [self jumpPay];
        
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
    }else if (coin_payMethod == YLNewPayMethodEasyAliPay){
        [self juPayWXAndZFB ];
    }else if (coin_payMethod == YLNewPayMethodEasyWXPay){
        [self juPayWXAndZFB ];
    } else if(coin_payMethod == -14){
        //光辉 支付宝
        [self jumpPay];
    }else if(coin_payMethod == -15){
        //光辉 微信
        [self jumpPay];
        
        
    }else {
        [self jumpPay];
    }
}

#pragma mark - 杉德
- (void)SDAlipay {
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:self->mealhandle.t_id payType:coin_payMethod payDeployId:self.payDeployId success:^(NSDictionary *payData) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:payData];
        [dict setValue:@"[{\"sc\":\"wzsc://\",\"s\":\"iOS\",\"id\":\"com.tencent.tmgp.sgame\",\"n\":\"支付宝\"}]" forKey:@"meta_option"];
                            
        PySdkViewController *paySDK = [[PySdkViewController alloc] init];
        [paySDK alipay:dict];
        [self.navigationController pushViewController:paySDK animated:YES];
        [paySDK.navigationController setNavigationBarHidden:NO animated:YES];
        [paySDK.navigationItem setTitle:@"支付"];
    }];
}

#pragma mark -光辉
-(void)ghAliPay{
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:self->mealhandle.t_id payType:coin_payMethod payDeployId:self.payDeployId success:^(NSDictionary *payData) {
        NSString *path = payData[@"return_msg"];
        WebPayViewController *vc = [[WebPayViewController alloc] init];
        vc.webUrl = path;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
}
-(void)ghWXPay{
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:self->mealhandle.t_id payType:coin_payMethod payDeployId:self.payDeployId success:^(NSDictionary *payData) {
        NSString *path = payData[@"return_msg"];
        WebPayViewController *vc = [[WebPayViewController alloc] init];
        vc.webUrl = path;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
}

- (void)jumpPay {
    [YLNetworkInterface goldStoreValue:[YLUserDefault userDefault].t_id setMealId:self->mealhandle.t_id payType:coin_payMethod payDeployId:self.payDeployId block:^(weixinPayHandle *hanle, NSString *apliOrderInfo) {
        
        //apliOrderInfo = @"https://www.baidu.com";
        if (@available(iOS 10.0, *)){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:apliOrderInfo] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:apliOrderInfo]];
        }
       
    }];
}

//杉德微信支付
- (void)SDWechatPay {
    
    
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:self->mealhandle.t_id payType:coin_payMethod payDeployId:self.payDeployId success:^(NSDictionary *payData) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:payData];
        
        [[SandPayGateService shared] queryTradeRecordInfoWith:payData[@"payUrl"]];
        
       
        
//        [dict setValue:@"[{\"sc\":\"wzsc://\",\"s\":\"iOS\",\"id\":\"com.tencent.tmgp.sgame\",\"n\":\"微信\"}]" forKey:@"meta_option"];
//
//        PySdkViewController *paySDK = [[PySdkViewController alloc] init];
//        [paySDK weixin:dict];
//        [self.navigationController pushViewController:paySDK animated:YES];
//        [paySDK.navigationController setNavigationBarHidden:NO animated:YES];
//        [paySDK.navigationItem setTitle:@"支付"];
    }];
    
   
    
//    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:self->mealhandle.t_id payType:coin_payMethod payDeployId:self.payDeployId success:^(NSDictionary *payData) {
//        NSString *path = payData[@"payUrl"];
//        WebPayViewController *vc = [[WebPayViewController alloc] init];
//        vc.webUrl = path;
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }];
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
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:self->mealhandle.t_id payType:coin_payMethod payDeployId:self.payDeployId success:^(NSDictionary *payData) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:payData];
        [dict setValue:@"[{\"sc\":\"testapp://\",\"s\":\"iOS\",\"id\":\"com.pay.paytypetest\",\"n\":\"云闪付\"}]" forKey:@"meta_option"];
                        
        PySdkViewController *paySDK = [[PySdkViewController alloc] init];
                        
        paySDK.UPPayPayBlock = ^(NSString * tn){
            [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"UPPayDemo://" mode:@"00" viewController:self];
        };
                        
        [paySDK UPPay:dict];
        [self.navigationController pushViewController:paySDK animated:YES];
        [paySDK.navigationController setNavigationBarHidden:NO animated:YES];
        [paySDK.navigationItem setTitle:@"支付"];
    }];
    
}

#pragma mark - 支付派 支付宝
- (void)alipayMiniProgramPay {
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:self->mealhandle.t_id payType:coin_payMethod payDeployId:self.payDeployId success:^(NSDictionary *payData) {
        NSString *path = payData[@"path"];
        WebPayViewController *vc = [[WebPayViewController alloc] init];
        vc.webUrl = path;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
}

//聚合支付网页支付
-(void)juPayWXAndZFB {
    
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:self->mealhandle.t_id payType:coin_payMethod payDeployId:self.payDeployId success:^(NSDictionary *payData) {
        NSString *path = payData[@"return_msg"];
        WebPayViewController *vc = [[WebPayViewController alloc] init];
        vc.webUrl = path;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
}


- (void)newAlipayMiniProgramPay {
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:self->mealhandle.t_id payType:coin_payMethod payDeployId:self.payDeployId success:^(NSDictionary *payData) {
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
    [YLNetworkInterface goldStoreWeMiniPPayValue:[YLUserDefault userDefault].t_id setMealId:self->mealhandle.t_id payType:coin_payMethod payDeployId:self.payDeployId success:^(NSDictionary *payData) {
        
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
    [YLNetworkInterface goldStoreValue:[YLUserDefault userDefault].t_id setMealId:self->mealhandle.t_id payType:coin_payMethod payDeployId:self.payDeployId block:^(weixinPayHandle *hanle, NSString *apliOrderInfo) {
        WebPayViewController *vc = [[WebPayViewController alloc] init];
        vc.webUrl = apliOrderInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark ---- 支付宝支付
- (void)apliyPay {
    [YLNetworkInterface goldStoreValue:[YLUserDefault userDefault].t_id setMealId:self->mealhandle.t_id payType:coin_payMethod payDeployId:self.payDeployId block:^(weixinPayHandle *hanle, NSString *apliOrderInfo) {
        [[apliManager sharePayManager]handleOrderPayWithParams:apliOrderInfo block:^(BOOL isSuccess) {
            if (isSuccess) {
                [SVProgressHUD showInfoWithStatus:@"金币充值成功"];
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
        }];
    }];
}

#pragma mark ---- 微信支付
- (void)wechatPay {
    [YLNetworkInterface goldStoreValue:[YLUserDefault userDefault].t_id setMealId:self->mealhandle.t_id payType:coin_payMethod payDeployId:self.payDeployId block:^(weixinPayHandle *hanle, NSString *apliOrderInfo) {
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = hanle.partnerid;
        req.prepayId            = hanle.prepayid;
        req.nonceStr            = hanle.noncestr;
        req.timeStamp           = [hanle.timestamp intValue];
        req.package             = hanle.package;
        req.sign                = hanle.sign;
        [WXApi sendReq:req completion:^(BOOL success) {
            NSLog(@"");
        }];
    }];
}

- (void)managerDidRecvWechatPayResponse:(PayResp *)response {
    switch (response.errCode) {
        case WXSuccess:
            [SVProgressHUD showInfoWithStatus:@"充值成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
        default:
            [SVProgressHUD showInfoWithStatus:@"充值失败"];
            
            break;
    }
}

@end
