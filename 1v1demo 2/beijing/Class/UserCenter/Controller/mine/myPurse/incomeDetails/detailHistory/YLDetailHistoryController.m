//
//  YLDetailHistoryController.m
//  beijing
//
//  Created by zhou last on 2018/6/21.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLDetailHistoryController.h"
#import "detailHistoryCell.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "incomeDetailHandle.h"
#import "DefineConstants.h"
#import <MJRefresh.h>

@interface YLDetailHistoryController ()
{
    int detailPage;
    NSMutableArray *detailListArray;
}

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;


@end

@implementation YLDetailHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.historyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        self->detailPage = 1;
        [self getwalletDayDetail:self->detailPage];
        
    }];
    [self.historyTableView.mj_header beginRefreshing];
    self.historyTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDetailData)];
}

#pragma mark ---- 钱包日明细
- (void)getwalletDayDetail:(int)page
{
    dispatch_queue_t queue = dispatch_queue_create("钱包日明细", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装一个任务
    dispatch_async(queue, ^{
        [YLNetworkInterface getWalletDateDetailstate:self.searchType userId:[YLUserDefault userDefault].t_id time:self.time page:page block:^(NSMutableArray *listArray) {
            if (self->detailPage == 1) {
                self->detailListArray = [NSMutableArray array];
                
                self->detailListArray = listArray;
            }else{
                for (incomeDetailHandle *handle in listArray) {
                    [self->detailListArray addObject:handle];
                }
            }
            

            [self.historyTableView reloadData];
            [self.historyTableView.mj_header endRefreshing];
            [self.historyTableView.mj_footer endRefreshing];
        }];
    });
}

#pragma mark ---- 上拉加载更多数据
- (void)loadMoreDetailData
{
    if (detailListArray.count != 0) {
        incomeDetailHandle *handle = detailListArray[0];
        if (handle.pageCount > detailPage) {
            detailPage ++;
            [self getwalletDayDetail:detailPage];
        }else{
            if (self.historyTableView.mj_footer.isRefreshing) {
                [self.historyTableView.mj_footer endRefreshing];
                [self.historyTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }else{
        if (self.historyTableView.mj_footer.isRefreshing) {
            [self.historyTableView.mj_footer endRefreshing];
            [self.historyTableView.mj_footer endRefreshingWithNoMoreData];
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
    return detailListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailHistoryCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"detailHistoryCell" owner:nil options:nil] firstObject];
    }
    
    incomeDetailHandle *handle = detailListArray[indexPath.row];
    NSString *category = @"充值"; //category =  0
    if (handle.t_change_category == 1) {
        //聊天
        category = @"聊天";
    }else if (handle.t_change_category == 2)
    {
        category = @"视频聊天";
    }else if (handle.t_change_category == 3)
    {
        category = @"私密照片";
    }else if (handle.t_change_category == 4)
    {
        category = @"私密视频";
    }else if (handle.t_change_category == 5)
    {
        category = @"查看手机";
    }else if (handle.t_change_category == 6){
        category = @"查看微信";
    }else if (handle.t_change_category == 7){
        category = @"红包";
    }else if (handle.t_change_category == 8){
        category = @"VIP";
    }else if (handle.t_change_category == 9){
        category = @"礼物";
    }else if (handle.t_change_category == 10){
        category = @"提现";
    }else if (handle.t_change_category == 11){
        category = @"推荐分成";
    }
    cell.typeLabel.text = category;
    cell.dateLabel.text = handle.tTime;
    
    if (_searchType == YLDetailsTypeIncome || _searchType == YLDetailsTypeRecharge) {
        cell.amountLabel.text = [NSString stringWithFormat:@"+ %@",handle.totalMoney];
        cell.amountLabel.textColor = IColor(134, 207, 216);
    }else if (_searchType == YLDetailsTypeSpending){
        cell.amountLabel.text = [NSString stringWithFormat:@"- %@",handle.totalMoney];
        cell.amountLabel.textColor = IColor(203, 71, 74);
    }
    
    return cell;
}


@end
