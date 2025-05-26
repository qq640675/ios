//
//  YLNWithDrawController.m
//  beijing
//
//  Created by zhou last on 2018/11/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLNWithDrawController.h"
#import "newWithDrawView.h"
#import "DefineConstants.h"
#import "YLNetworkInterface.h"
#import "YLBasicView.h"
#import "vipSetMealHandle.h"
#import "YLUserDefault.h"
#import "YLTapGesture.h"
#import "newConvertView.h"
#import "YLManageAccountController.h"
#import "accountHandle.h"
#import "YLNWithdrawDetailController.h"
#import "SVProgressHUD.h"
#import "UIManager.h"
#import "YLEditPaypassController.h"

@interface YLNWithDrawController ()
{
    newWithDrawView *nWithDraw;
    newConvertView *convertView;
    NSMutableArray *wxListArray;
    NSMutableArray *zfbListArray;
    
    UIButton *lastClickBtn; //上一次点击的按钮(充值金币,开通vip)
    UIImageView *lastTapView; //上一次点击的充值背景
    UILabel *lastYuanLabel; //上一次点击的元(9，16，28元等不同金额)
    UILabel *lastCoinLabel; //上一次点击的金币(80，160金币等不同金币)
    
    vipSetMealHandle *mealHandle;
//    UIView *lineView;
    NSMutableArray *accountArray;
    
    NSInteger listType;
    BOOL isExtractAuth;
}

@property (weak, nonatomic) IBOutlet UIScrollView *withDrawScrollView;


@end

@implementation YLNWithDrawController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self getUsableGold];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提现";

    isExtractAuth = NO;
    wxListArray = [NSMutableArray array];
    zfbListArray = [NSMutableArray array];
    
    [self nWithDrawCustomUI];
    
    listType = -1;
    [self getWithDrawListPay];
    
    [YLTapGesture tapGestureTarget:self sel:@selector(hideKeyBoard) view:self.view];
    
    nWithDraw.tip1Label.hidden = YES;
    nWithDraw.paypassField.hidden = YES;
    [YLNetworkInterface has_extractauth:[YLUserDefault userDefault].t_id block:^(BOOL isSuccess) {
       if (isSuccess) {
           isExtractAuth = YES;
           
           nWithDraw.tip1Label.hidden = NO;
           nWithDraw.paypassField.hidden = NO;
       }
       else
       {
           isExtractAuth = NO;
       }
   }];
}

- (void)hideKeyBoard
{
    [nWithDraw.paypassField resignFirstResponder];
}


#pragma mark ---- customUI
- (void)nWithDrawCustomUI
{
    NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"newWithDrawView" owner:nil options:nil];
    nWithDraw = xibArray[0];
    [self.withDrawScrollView addSubview:nWithDraw];
    self.withDrawScrollView.contentSize = CGSizeMake(App_Frame_Width, 711 + 70 + JF_BOTTOM_SPACE);
    [nWithDraw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(App_Frame_Width);
        make.height.mas_equalTo(235+70);
    }];
    
    UIButton *naviRightBtn = [UIManager initWithButton:CGRectMake(0, 0, 44, 44) text:@"明细" font:15.0f textColor:[UIColor blackColor] normalImg:nil highImg:nil selectedImg:nil];
    [naviRightBtn addTarget:self action:@selector(withdrawDetailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:naviRightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    nWithDraw.myWithdrawCoinLabel.text = [NSString stringWithFormat:@"%@",self.balance];
    
    //支付宝
    [YLTapGesture addTaget:self sel:@selector(apliyBtnClicked:) view:nWithDraw.apliyBtn];
    //微信
    [YLTapGesture addTaget:self sel:@selector(wechatBtnClicked:) view:nWithDraw.wechatBtn];
    //绑定
    [YLTapGesture addTaget:self sel:@selector(bandAccountBtnClicked:) view:nWithDraw.bangBtn];

//    lineView = [UIView new];
//    lineView.backgroundColor = XZRGB(0xfe2947);
//    [nWithDraw.withdrawMethodView addSubview:lineView];
//    lineView.frame = CGRectMake(App_Frame_Width/4. - 9., nWithDraw.withdrawMethodView.frame.size.height - 3, 18, 3);
//    lineView.clipsToBounds = YES;
//    lineView.layer.cornerRadius = 1.5f;
    
    
    
}

#pragma mark ---- 绑定
- (void)bandAccountBtnClicked:(UIButton *)sender
{
    YLManageAccountController *manageAccountVC = [YLManageAccountController new];
    
    NSString *tittle = @"支付宝";
    int index = 0;
    if ([nWithDraw.wechatBtn.currentImage isEqual:[UIImage imageNamed:@"nwithDraw_wechat_sel"]]) {
        tittle = @"微信";
        index = 1;
    }
    
    accountHandle *ahandle = nil;
    if (accountArray.count != 0) {
        for (accountHandle *handle in accountArray) {
            if (handle.t_type == index) {
                ahandle = handle;
            }
        }
    }
    manageAccountVC.handle = ahandle;
    manageAccountVC.tittleName = tittle;
    [self.navigationController pushViewController:manageAccountVC animated:YES];
}

#pragma mark ---- 支付宝
- (void)apliyBtnClicked:(UIButton *)sender
{
    [sender setImage:[UIImage imageNamed:@"nwithDraw_apliy_sel"] forState:UIControlStateNormal];
    [nWithDraw.wechatBtn setImage:[UIImage imageNamed:@"nwithDraw_wechat_nosel"] forState:UIControlStateNormal];
//    [UIView animateWithDuration:.5 animations:^{
//        self->lineView.frame = CGRectMake(App_Frame_Width/4. - 9., self->nWithDraw.withdrawMethodView.frame.size.height - 3, 18, 3);
//    }];
    
    NSString *zfb = @"未绑定支付宝提现账号";
    for (accountHandle *handle in self->accountArray) {
        if (handle.t_type == 0) {
            zfb = handle.t_account_number;
        }
    }
    nWithDraw.accountLabel.text = zfb;
    listType = -1;
    [self getWithDrawListPay];
}

#pragma mark ---- 微信
- (void)wechatBtnClicked:(UIButton *)sender
{
    [sender setImage:[UIImage imageNamed:@"nwithDraw_wechat_sel"] forState:UIControlStateNormal];
    [nWithDraw.apliyBtn setImage:[UIImage imageNamed:@"nwithDraw_apliy_nosel"] forState:UIControlStateNormal];
//    [UIView animateWithDuration:.5 animations:^{
//        self->lineView.frame = CGRectMake(App_Frame_Width/4.*3 - 9., self->nWithDraw.withdrawMethodView.frame.size.height - 3, 18, 3);
//    }];
    NSString *wx = @"未绑定微信提现账号";
    for (accountHandle *handle in self->accountArray) {
        if (handle.t_type == 1) {
            wx = handle.t_account_number;
        }
    }
    nWithDraw.accountLabel.text = wx;
    listType = -2;
    [self getWithDrawListPay];
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
            
            for (accountHandle *handle in self->accountArray) {
                if (self->listType == -2) {
                    if (handle.t_type == 1) {
                        self->nWithDraw.accountLabel.text = handle.t_account_number;
                    }
                } else {
                    if (handle.t_type == 0) {
                        self->nWithDraw.accountLabel.text = handle.t_account_number;
                    }
                }
                
            }
        }];
    });
}

#pragma mark ---- 获取提现列表
- (void)getWithDrawListPay
{
    //-2 微信 -1支付宝
    for (UIView *view in self.withDrawScrollView.subviews) {
        if (view.tag > 99) {
            [view removeFromSuperview];
        }
    }
    [YLNetworkInterface getPutforwardDiscount:^(NSMutableArray *listArray) {
        if (listArray.count > 0) {
            if (self->listType == -2) {
                self->wxListArray = listArray;
            } else {
                self->zfbListArray = listArray;
            }
            
            if (listArray.count % 3 == 0) {
                [self buildCovertView:260 + 70 + listArray.count/3 * 70];
            }else{
                [self buildCovertView:260 + 70 + (listArray.count/3 + 1) * 70];
            }
            
        } else {
            [SVProgressHUD showInfoWithStatus:@"提现列表未配置"];
        }
        [self buildWithdrawalList];
    } t_end_type:(int)listType];
    
    [YLNetworkInterface getWithdrawRule:[YLUserDefault userDefault].t_id block:^(NSString *token) {
        [self->convertView.ruleLabel setText:token];
    }];
}



#pragma mark ---- 构建提现比例列表
- (void)buildWithdrawalList
{
    
    
    mealHandle = nil;
    convertView.canCoinsLabel.text = @"0";
    
    
    float orighX = 15.;
    float width = (App_Frame_Width - 30 - 16)/3.;
    float height = 60;
    float orighY = 10 + 250 + 70;
    
    NSArray *list = wxListArray;
    if (listType == -1) {
        list = zfbListArray;
    }
    
    for (int index = 0; index < list.count; index ++) {
        vipSetMealHandle *handle = list[index];
        
        UIImageView *listImgView = [UIImageView new];
        listImgView.userInteractionEnabled = YES;
        listImgView.tag = 100 + index;
        listImgView.frame = CGRectMake(orighX, orighY, width, height);
        [YLTapGesture tapGestureTarget:self sel:@selector(chargeKindViewTap:) view:listImgView];
        [self.withDrawScrollView addSubview:listImgView];
        
        //元
        UILabel *yuanLabel = [YLBasicView createLabeltext:[NSString stringWithFormat:@"%@元",handle.t_money] size:[UIFont boldSystemFontOfSize:16.0f] color:XZRGB(0x666666) textAlignment:NSTextAlignmentCenter];
        
        [listImgView addSubview:yuanLabel];
        yuanLabel.frame = CGRectMake(0, 4, listImgView.frame.size.width, height/2. - 4);
        
        //金币
        UILabel *coinsLabel = [YLBasicView createLabeltext:[NSString stringWithFormat:@"%d金币",handle.t_gold] size:PingFangSCFont(15) color:IColor(101, 101, 101) textAlignment:NSTextAlignmentCenter];
        [listImgView addSubview:coinsLabel];
        coinsLabel.frame = CGRectMake(10, height/2. + 3, listImgView.frame.size.width - 20, height/2. - 10);
        
        if ((index + 1) % 3 == 0) {
            orighX = 15;
            orighY = (index + 1)/3 * 70  + 260 + 70;
        }else{
            orighX += width + 5;
        }
        
        //默认值是第一中间面额选中状态
        if (index != 1) {
            listImgView.image = [UIImage imageNamed:@"insufficient_coin_nosel"];
            
            yuanLabel.textColor = XZRGB(0x666666);
            coinsLabel.textColor = IColor(101, 101, 101);
        }else{
            listImgView.image = [UIImage imageNamed:@"insufficient_coin_sel"];
            
            yuanLabel.textColor = XZRGB(0xfe2947);
            coinsLabel.textColor = IColor(251, 25, 63);
            
            lastTapView = listImgView;
            lastYuanLabel = yuanLabel;
            lastCoinLabel = coinsLabel;
            mealHandle = list[index];
            convertView.canCoinsLabel.text = [NSString stringWithFormat:@"%d",mealHandle.t_gold];
        }
    }

}

#pragma mark ---- 构建兑换框
- (void)buildCovertView:(float)height
{
    NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"newConvertView" owner:nil options:nil];
    convertView = xibArray[0];
    convertView.tag = 9999;
    [self.withDrawScrollView addSubview:convertView];
    
    self.withDrawScrollView.contentSize = CGSizeMake(App_Frame_Width,height + JF_BOTTOM_SPACE + 300);
    [convertView.withdrawNowBtn.layer setCornerRadius:5.];
    [convertView.withdrawNowBtn setClipsToBounds:YES];
    [convertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(height);
        make.width.mas_equalTo(App_Frame_Width);
        make.height.mas_equalTo(300);
    }];
    
    [YLTapGesture addTaget:self sel:@selector(convertNowBtnClicked:) view:convertView.withdrawNowBtn];
}

#pragma mark ---- 不同充值面额切换
- (void)chargeKindViewTap:(UITapGestureRecognizer *)tap
{
    UIImageView *selImgView = (UIImageView *)tap.view;
    UILabel *yuanLabel = (UILabel *)[selImgView subviews][0];
    UILabel *coinLabel = (UILabel *)[selImgView subviews][1];
    
    lastTapView.image = [UIImage imageNamed:@"insufficient_coin_nosel"];
    selImgView.image = [UIImage imageNamed:@"insufficient_coin_sel"];
    
    
    [self chageColor:lastTapView isSel:NO];
    [self chageColor:selImgView isSel:YES];
    
    lastTapView = selImgView;
    lastYuanLabel = yuanLabel;
    lastCoinLabel = coinLabel;
    NSArray *list = wxListArray;
    if (listType == -1) {
        list = zfbListArray;
    }
    mealHandle = list[tap.view.tag - 100];
    convertView.canCoinsLabel.text = [NSString stringWithFormat:@"%d",mealHandle.t_gold];

}

#pragma mark ---- 改变充值面额选中或未选中的颜色
- (void)chageColor:(UIImageView *)selImgView isSel:(BOOL)isSel
{
    if (isSel) {
        selImgView.image = [UIImage imageNamed:@"insufficient_coin_sel"];
        UILabel *yuanLabel = (UILabel *)[selImgView subviews][0];
        UILabel *coinLabel = (UILabel *)[selImgView subviews][1];
        
        coinLabel.textColor = IColor(251, 25, 63);
        yuanLabel.textColor = XZRGB(0xfe2947);
    }else{
        [lastTapView setImage:[UIImage imageNamed:@"insufficient_coin_nosel"]];
        lastCoinLabel.textColor = IColor(101, 101, 101);
        lastYuanLabel.textColor = XZRGB(0x666666);
    }
}

#pragma mark ---- 立即兑换
- (void)convertNowBtnClicked:(UIButton *)sender
{
    int index = 0;
    if ([nWithDraw.wechatBtn.currentImage isEqual:[UIImage imageNamed:@"nwithDraw_wechat_sel"]]) {
        index = 1;
    }
    
    accountHandle *ahandle = nil;
    if (accountArray.count != 0) {
        for (accountHandle *handle in accountArray) {
            if (handle.t_type == index) {
                ahandle = handle;
            }
        }
    }
    
//    if ([YLUserDefault userDefault].t_role != 1) {
//        [SVProgressHUD showInfoWithStatus:@"暂未开通用户提现功能"];
//        return;
//    }
    
    if (isExtractAuth == YES)
    {
        if (nWithDraw.paypassField.text == nil ||
            [nWithDraw.paypassField.text isEqualToString:@""]) {
            [SVProgressHUD showInfoWithStatus:@"请输入支付密码"];
            return;
        }
    }
    
    if (mealHandle == nil) {
        [SVProgressHUD showInfoWithStatus:@"请选择提现金额"];
        return;
    }
    
    if (self.balance.intValue < mealHandle.t_gold) {
        [SVProgressHUD showInfoWithStatus:@"金币不足"];
        return;
    }
    
    if (ahandle == nil) {
        [SVProgressHUD showInfoWithStatus:@"请绑定账号"];
        return;
    }
    
    [self confirmPutforward:ahandle withpaypass:nWithDraw.paypassField.text];
}

#pragma mark ---- 调用提现接口
- (void)confirmPutforward:(accountHandle *)handle withpaypass:(NSString *)paypass
{
    
    [YLNetworkInterface confirmPutforward:mealHandle.t_id userId:[YLUserDefault userDefault].t_id putForwardId:handle.t_id withpaypass:paypass block:^(BOOL isSuccess) {
        if (isSuccess == NO)
        {
            YLEditPaypassController *vc = [YLEditPaypassController new];
            vc.title = @"修改支付密码";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

#pragma mark ---- 提现明细
- (IBAction)withdrawDetailBtnClicked:(id)sender {
    YLNWithdrawDetailController *withdrawDetailVC = [YLNWithdrawDetailController new];
    withdrawDetailVC.title = @"提现明细";
    [self.navigationController pushViewController:withdrawDetailVC animated:YES];
}

#pragma mark ---- 返回
- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
