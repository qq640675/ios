//
//  YLNWithdrawDetailController.m
//  beijing
//
//  Created by zhou last on 2018/11/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLNWithdrawDetailController.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import <MJRefresh.h>
#import "ZYTimeStamp.h"
#import <SVProgressHUD.h>
#import "incomeDetailHandle.h"
#import "nWithdrawDetail.h"
#import "DefineConstants.h"
#import <Masonry.h>
#import "YLTapGesture.h"
#import "balanceCell.h"
#import <UIImageView+WebCache.h>
#import "YLBasicView.h"
#import "PGDatePickManager.h"

@interface YLNWithdrawDetailController ()<PGDatePickerDelegate>
{
    NSMutableArray *dListArray;
    int year;
    int month;
    int page;
}
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@end

@implementation YLNWithdrawDetailController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *dateStr = [ZYTimeStamp getDateStrFromeTime];
    
    NSArray *dateArray = [dateStr componentsSeparatedByString:@"-"];
    if (dateArray.count >= 2) {
        year = [dateArray[0] intValue];
        month = [dateArray[1] intValue];
    }
    
    self.detailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        self->page = 1;
        [self getWithDrawList:self->page];
    }];
    [self.detailTableView.mj_header beginRefreshing];
    self.detailTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNAttentionData)];
}


- (void)getWithDrawList:(int)page
{
    dispatch_queue_t queue = dispatch_queue_create("收入支出充值提现明细", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = [NSMutableDictionary dictionaryWithDictionary:@{@"year":[NSNumber numberWithInt:self->year],@"month":[NSNumber numberWithInt:self->month],@"page":[NSNumber numberWithInt:page],@"userId":[NSNumber numberWithInt:[YLUserDefault userDefault].t_id],@"queyType":@"4"}];
        
        [dic setValue:[NSNumber numberWithInt:-1] forKey:@"state"];
        
        self->dListArray = [NSMutableArray array];
        [YLNetworkInterface getWalletDetailType:dic block:^(NSMutableArray *listArray) {
            self->dListArray = listArray;
            
            
            if (listArray.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"暂无数据"];
            }
            
            [self.detailTableView.mj_footer endRefreshing];
            [self.detailTableView.mj_header endRefreshing];
            [self.detailTableView reloadData];
        }];
    });
}

- (void)loadNAttentionData
{
    if (dListArray.count != 0) {
        incomeDetailHandle *handle = dListArray[0];
        if (handle.pageCount > page) {
            page ++;
            [self getWithDrawList:page];
        }else{
            if (self.detailTableView.mj_footer.isRefreshing) {
                [self.detailTableView.mj_footer endRefreshing];
                [self.detailTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }else{
        if (self.detailTableView.mj_footer.isRefreshing) {
            [self.detailTableView.mj_footer endRefreshing];
            [self.detailTableView.mj_footer endRefreshingWithNoMoreData];
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
    return dListArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 ) {
        return 129.;
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
        
        NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"nWithdrawDetail" owner:nil options:nil];
        nWithdrawDetail *balanceView = xibArray[0];
        [cell.contentView addSubview:balanceView];
        [balanceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.width.mas_equalTo(App_Frame_Width);
            make.height.mas_equalTo(129.);
        }];
        
        balanceView.yearLabel.text = [NSString stringWithFormat:@"%d年",year];
        balanceView.monthLabel.text = [NSString stringWithFormat:@"%d",month];
        
        if (dListArray.count != 0) {
            incomeDetailHandle *handle = dListArray[0];
            balanceView.coinsLabel.text = [NSString stringWithFormat:@"%d",handle.monthTotal];
        }
        
        //年月选择
        [YLTapGesture tapGestureTarget:self sel:@selector(dateSelectViewTap) view:balanceView.dateSelView];
        
        return cell;
    }else{
        incomeDetailHandle *handle = dListArray[indexPath.row -1];

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

        //时间
        cell.timeLabel.text = handle.tTime;
        
        int orighX = 160;
        
        if (handle.t_type == 0) {
            cell.nameLabel.text = @"支付宝提现";
            cell.coinLabel.text = [NSString stringWithFormat:@"¥ %.0f",handle.t_money];
            cell.coinLabel.textColor = KDEFAULTBLACKCOLOR;
            cell.headImgView.image = [UIImage imageNamed:@"newWith_apliy"];
        }else{
            cell.nameLabel.text = @"微信提现";
            orighX = 150;
            cell.coinLabel.text = [NSString stringWithFormat:@"¥ %.0f",handle.t_money];
            cell.coinLabel.textColor = XZRGB(0xAE4FFD);
            cell.headImgView.image = [UIImage imageNamed:@"newWith_wechat"];
        }
        
        UILabel *statusLabel = [YLBasicView createLabeltext:@"" size:PingFangSCFont(12) color:KWHITECOLOR textAlignment:NSTextAlignmentCenter];
        //状态 0.待审核1.已审核待打款 2.已打款，3.打款失败
        if (handle.t_order_state == 0 && handle.t_order_state == 1) {
            statusLabel.backgroundColor = XZRGB(0xffaa20);
            statusLabel.text = @"提现中";
        }else if (handle.t_order_state == 2){
            statusLabel.text = @"提现成功";
            statusLabel.backgroundColor = XZRGB(0x0bcae9);
        }else if (handle.t_order_state == 3){
            statusLabel.text = @"提现失败";
            statusLabel.backgroundColor = XZRGB(0xAE4FFD);
        }
        statusLabel.frame = CGRectMake(orighX, 18, 55, 15);
        [statusLabel.layer setCornerRadius:7.5];
        [statusLabel setClipsToBounds:YES];
        [cell.contentView addSubview:statusLabel];

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
    year = (int)dateComponents.year;
    if (dateComponents.month < 10) {
        month = (int)dateComponents.month;
    }else{
        month = (int)dateComponents.month;
    }
    
    page = 1;
    [self getWithDrawList:page];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
