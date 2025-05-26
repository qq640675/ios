//
//  MansionInviteListViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/11.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MansionInviteListViewController.h"
#import "MansionInviteListTableViewCell.h"
#import <MJRefresh.h>

@interface MansionInviteListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *inviteTableView;
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation MansionInviteListViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"府邸邀请";
    [self setSubViews];
    [self requestDataIsRefresh:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden: NO animated:YES];
}

#pragma mark - net
- (void)requestDataIsRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        _page = 1;
    } else {
        _page ++;
    }
    [YLNetworkInterface getMansionHouseInviteListWithPage:_page success:^(NSArray *dataArray) {
        [SVProgressHUD dismiss];
        [self.inviteTableView.mj_header endRefreshing];
        [self.inviteTableView.mj_footer endRefreshing];
        if (dataArray == nil) {
            self.page --;
            return ;
        }
        if ([dataArray count] < 10) {
            self.inviteTableView.mj_footer.state = MJRefreshStateNoMoreData;
            [self.inviteTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.page == 1) {
            self.dataList = [NSMutableArray arrayWithArray:dataArray];
        } else {
            [self.dataList addObjectsFromArray:dataArray];
        }
        
        [self.inviteTableView reloadData];
    } fail:^{
        [SVProgressHUD dismiss];
        [self.inviteTableView.mj_header endRefreshing];
        [self.inviteTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - setSubViews
- (void)setSubViews {
    self.inviteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height) style:UITableViewStylePlain];
    self.inviteTableView.backgroundColor = [UIColor whiteColor];
    self.inviteTableView.tableFooterView = [UIView new];
    self.inviteTableView.dataSource = self;
    self.inviteTableView.delegate = self;
    self.inviteTableView.showsVerticalScrollIndicator = NO;
    self.inviteTableView.rowHeight = 60;
    [self.inviteTableView registerClass:[MansionInviteListTableViewCell class] forCellReuseIdentifier:@"inviteCell"];
    [self.view addSubview:self.inviteTableView];
    
    WEAKSELF;
    self.inviteTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestDataIsRefresh:YES];
    }];
    
    self.inviteTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestDataIsRefresh:NO];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MansionInviteListTableViewCell *inviteCell = [tableView dequeueReusableCellWithIdentifier:@"inviteCell"];
    inviteCell.inviteModel = _dataList[indexPath.row];
    WEAKSELF;
    inviteCell.inviteCellButtonClick = ^(NSInteger index) {
        [weakSelf handleAlert:index row:indexPath.row];
    };
    return inviteCell;
}

#pragma mark - func
- (void)handleAlert:(NSInteger)isJoin row:(NSInteger)row {
    NSString *message = @"确定加入府邸？";
    if (isJoin == 2) {
        message = @"确定拒绝府邸？";
    }
    [LXTAlertView alertViewDefaultWithTitle:@"" message:message sureHandle:^{
        [self mansionInviteHandle:isJoin row:row];
    }];
}

- (void)mansionInviteHandle:(NSInteger)isJoin row:(NSInteger)row {
    // 1同意   2拒绝
    if (row > self.dataList.count) {
        [SVProgressHUD showInfoWithStatus:@"未知错误，请返回重试"];
        return;
    }
    MansionInviteListModel *model = self.dataList[row];
    [YLNetworkInterface agreeMansionHouseInviteIsAgree:(int)isJoin mansionId:model.t_mansion_house_id success:^{
        for (MansionInviteListModel *inviteModel in self.dataList.copy) {
            if (model.t_mansion_house_id == inviteModel.t_mansion_house_id) {
                [self.dataList removeObject:inviteModel];
            }
        }
        [self.inviteTableView reloadData];
    }];
}


@end
