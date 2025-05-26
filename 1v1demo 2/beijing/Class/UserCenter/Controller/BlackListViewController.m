//
//  BlackListViewController.m
//  beijing
//
//  Created by 黎 涛 on 2019/7/13.
//  Copyright © 2019 zhou last. All rights reserved.
//

// vc
#import "BlackListViewController.h"
// view
#import "NewFollowTableViewCell.h"
// other
#import "YLPushManager.h"
#import <MJRefresh.h>

@interface BlackListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *blackTableView;
    int nPage; //页码
    NSMutableArray *blackListArray; //数据
}

@end

@implementation BlackListViewController

#pragma amrk - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"黑名单";
    blackListArray = [NSMutableArray array];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setSubViews];
    [self getBlackListIsRefresh:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - net
- (void)getBlackListIsRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        nPage = 1;
    } else {
        nPage ++;
    }
    [SVProgressHUD show];
    [YLNetworkInterface getBlackUserListWithPage:nPage Success:^(NSArray *dataArray) {
        [SVProgressHUD dismiss];
        [self->blackTableView.mj_header endRefreshing];
        [self->blackTableView.mj_footer endRefreshing];
        if (dataArray == nil) {
            self->nPage --;
            return ;
        }
        if ([dataArray count] < 10) {
            self->blackTableView.mj_footer.state = MJRefreshStateNoMoreData;
            [self->blackTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self->nPage == 1) {
            self->blackListArray = [NSMutableArray arrayWithArray:dataArray];
        } else {
            [self->blackListArray addObjectsFromArray:dataArray];
        }
        
        [self->blackTableView reloadData];
    } fail:^{
        [SVProgressHUD dismiss];
        [self->blackTableView.mj_header endRefreshing];
        [self->blackTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - subViews
- (void)setSubViews {
    blackTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight) style:UITableViewStylePlain];
    blackTableView.backgroundColor = [UIColor whiteColor];
    blackTableView.tableFooterView = [UIView new];
    blackTableView.dataSource = self;
    blackTableView.delegate = self;
    blackTableView.rowHeight = 70;
    [blackTableView registerClass:[NewFollowTableViewCell class] forCellReuseIdentifier:@"footprintCell"];
    [self.view addSubview:blackTableView];
    
    WEAKSELF;
    blackTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getBlackListIsRefresh:YES];
    }];
    
    blackTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getBlackListIsRefresh:NO];
    }];
}

#pragma mark - UITableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return blackListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WatchedModel *model = blackListArray[indexPath.row];
    NewFollowTableViewCell *footprintCell = [tableView dequeueReusableCellWithIdentifier:@"footprintCell"];
    footprintCell.isBlackUser = YES;
    footprintCell.model = model;
    WEAKSELF;
    footprintCell.followButtonClick = ^{
        [weakSelf cancleFollowWithIndex:indexPath.row];
    };
    return footprintCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (blackListArray.count > indexPath.row) {
        WatchedModel *handle = blackListArray[indexPath.row];
        if (handle.t_role == 1) {
            [YLPushManager pushAnchorDetail:handle.t_cover_user_id];
        } else {
            [YLPushManager pushFansDetail:handle.t_cover_user_id];
        }
    }
}

#pragma mark - func
- (void)cancleFollowWithIndex:(NSInteger)index {
    //取消拉黑
    WatchedModel *model = blackListArray[index];
    [SVProgressHUD show];
    [YLNetworkInterface delBlackUserWithId:[NSString stringWithFormat:@"%ld", model.t_id] success:^{
        [SVProgressHUD showSuccessWithStatus:@"操作成功"];
        [self->blackListArray removeObjectAtIndex:index];
        [self->blackTableView reloadData];
    }];
}

@end
