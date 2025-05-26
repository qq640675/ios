//
//  YLNAccountBalanceController.m
//  beijing
//
//  Created by zhou last on 2018/10/24.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLNAccountBalanceController.h"
#import "newBalanceView.h"
#import <Masonry.h>
#import "DefineConstants.h"
#import "balanceCell.h"
#import "YLTapGesture.h"
#import "PGDatePickManager.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "ZYTimeStamp.h"
#import "newBalanceHandle.h"
#import <UIImageView+WebCache.h>
#import "NSString+Util.h"
#import <SVProgressHUD.h>
#import <MJRefresh.h>

@interface YLNAccountBalanceController ()<PGDatePickerDelegate>
{
    NSMutableArray *balanceArray; //余额列表
    int page;
}

@property (nonatomic ,assign) int year;
@property (nonatomic ,assign) int month;

@property (nonatomic ,assign) int balancePay;
@property (nonatomic ,assign) int balanceProfit;

@property (weak, nonatomic) IBOutlet UITableView *balanceTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation YLNAccountBalanceController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bottomConstraint.constant = SafeAreaBottomHeight-49;
    
    [self balanceCustomUI];
}

#pragma mark ---- customUI
- (void)balanceCustomUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.barTintColor = KWHITECOLOR;
    
    NSString *dateStr = [ZYTimeStamp getDateStrFromeTime];
    
    NSArray *dateArray = [dateStr componentsSeparatedByString:@"-"];
    if (dateArray.count >= 2) {
        self.year = [dateArray[0] intValue];
        self.month = [dateArray[1] intValue];
    }
    
    self.balanceTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        self->page = 1;
        [self getBalanceData:[dateArray[0] intValue] month:[dateArray[1] intValue] page:self->page];
    }];
    [self.balanceTableView.mj_header beginRefreshing];
    self.balanceTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNAttentionData)];
}

#pragma mark ---- 筛选
- (void)filterType
{
}

#pragma mark ---- 获取账号余额数据
- (void)getBalanceData:(int)year month:(int)month page:(int)page
{
    dispatch_queue_t queue = dispatch_queue_create("获取账号余额", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        [YLNetworkInterface getProfitAndPayTotal:[YLUserDefault userDefault].t_id year:year month:month block:^(int pay, int profit) {
            self.balancePay = pay;
            self.balanceProfit = profit;
            self.balance = profit - pay;
            [self.balanceTableView reloadData];
        }];
    });
    
    dispatch_async(queue, ^{
        //queryType 查询类型 -1：全部 0.收入 1.支出
        [YLNetworkInterface getUserGoldDetails:[YLUserDefault userDefault].t_id year:self.year month:self.month queryType:-1 page:page block:^(NSMutableArray *listArray) {
            
            if (self->page== 1) {
                self->balanceArray = [NSMutableArray array];
                self->balanceArray = listArray;
            }else{
                for (newBalanceHandle *handle in listArray) {
                    [self->balanceArray addObject:handle];
                }
            }
            
            if (self->balanceArray.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"没有数据"];
            }
            
            [self.balanceTableView reloadData];
            [self.balanceTableView.mj_footer endRefreshing];
            [self.balanceTableView.mj_header endRefreshing];
        }];
    });
}

- (void)loadNAttentionData 
{
    if (balanceArray.count != 0) {
        newBalanceHandle *handle = balanceArray[0];
        if (handle.pageCount > page) {
            page ++;
            [self getBalanceData:self.year month:self.month page:page];
        }else{
            if (self.balanceTableView.mj_footer.isRefreshing) {
                [self.balanceTableView.mj_footer endRefreshing];
                [self.balanceTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }else{
        if (self.balanceTableView.mj_footer.isRefreshing) {
            [self.balanceTableView.mj_footer endRefreshing];
            [self.balanceTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

#pragma mark ---- tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return balanceArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 ) {
        return 191.;
    }else
    {
        return 80.;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
        if (!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
        }else{
            //删除cell的所有子视图
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"newBalanceView" owner:nil options:nil];
        newBalanceView *balanceView = xibArray[0];
        [cell.contentView addSubview:balanceView];
        [balanceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.width.mas_equalTo(App_Frame_Width);
            make.height.mas_equalTo(191.);
        }];
        
        balanceView.yearLabel.text = [NSString stringWithFormat:@"%d年",self.year];
        balanceView.monthLabel.text = [NSString stringWithFormat:@"%d",self.month];
        
        balanceView.incomeLabel.text = [NSString stringWithFormat:@"%d",self.balanceProfit];
        balanceView.withdrawLabel.text = [NSString stringWithFormat:@"%d",self.balancePay];

        balanceView.coinsLabel.text = [NSString stringWithFormat:@"%d",self.balance];
        //年月选择
        [YLTapGesture tapGestureTarget:self sel:@selector(dateSelectViewTap) view:balanceView.dateSelView];
        
        return cell;
    }else{
        newBalanceHandle *handle = balanceArray[indexPath.row -1];
        
        balanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"balanceCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"balanceCell" owner:nil options:nil] firstObject];
        }else{
            //删除cell的所有子视图
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        //头像
        if (![NSString isNullOrEmpty:handle.t_handImg]) {
            [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:handle.t_handImg] placeholderImage:[UIImage imageNamed:@"default"]];
        }else{
            [cell.headImgView setImage:[UIImage imageNamed:@"default"]];
        }
        [cell.headImgView.layer setCornerRadius:4.];
        [cell.headImgView setClipsToBounds:YES];
        
        //名称
        //0.充值1.聊天2.视频3.私密照片4.私密视频5.查看手机6.查看微信7.红包8.VIP9.礼物10.提现11.推荐分成12.提现失败原路退回13.注册赠送14.公会收入
        cell.nameLabel.text = handle.detail;
        //时间
        cell.timeLabel.text = handle.tTime;
        
        //profitAndPay  -1:支出 1:收益
        if (handle.profitAndPay == -1) {
            cell.coinLabel.text = [NSString stringWithFormat:@"- %d",handle.t_value];
            cell.coinLabel.textColor = KDEFAULTBLACKCOLOR;
        }else{
            cell.coinLabel.text = [NSString stringWithFormat:@"+ %d",handle.t_value];
            cell.coinLabel.textColor = KDEFAULTCOLOR;
        }
        
        
        return cell;
    }
}

#pragma mark ---- 年月选择
- (void)dateSelectViewTap
{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackgroud = true;
    datePickManager.style = PGDatePickManagerStyle3;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerType1;
    datePicker.isHiddenMiddleText = false;
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
    datePickManager.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:datePickManager animated:false completion:nil];
}


- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents
{
    self.year = (int)dateComponents.year;
    if (dateComponents.month < 10) {
        self.month = (int)dateComponents.month;
    }else{
        self.month = (int)dateComponents.month;
    }
    
    page = 1;
    [self getBalanceData:self.year month:self.month page:page];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
