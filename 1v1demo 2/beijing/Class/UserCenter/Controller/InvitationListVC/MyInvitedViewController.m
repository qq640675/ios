//
//  MyInvitedViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/12/22.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MyInvitedViewController.h"
#import "InvitationTudiListTableViewCell.h"
#import <MJRefresh.h>

@interface MyInvitedViewController ()<UITableViewDataSource>
{
    UITableView *invitedTableView;
    int nPage; //页码
    NSMutableArray *invitedListArray; //数据
}

@end

@implementation MyInvitedViewController

#pragma mark - func
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"我的邀请";
    
    invitedListArray = [NSMutableArray array];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setSubViews];
    [self getMyInvitedListIsRefresh:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - net
- (void)getMyInvitedListIsRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        nPage = 1;
    } else {
        nPage ++;
    }
    [SVProgressHUD show];
    [YLNetworkInterface getShareUserList:[YLUserDefault userDefault].t_id page:(int)nPage type:1 block:^(NSMutableArray *dataArray) {
        [SVProgressHUD dismiss];
        [self->invitedTableView.mj_header endRefreshing];
        [self->invitedTableView.mj_footer endRefreshing];
        if (dataArray == nil) {
            self->nPage --;
            return ;
        }
        if ([dataArray count] < 10) {
            self->invitedTableView.mj_footer.state = MJRefreshStateNoMoreData;
            [self->invitedTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self->nPage == 1) {
            self->invitedListArray = [NSMutableArray arrayWithArray:dataArray];
        } else {
            [self->invitedListArray addObjectsFromArray:dataArray];
        }
        
        [self->invitedTableView reloadData];
    }];
}

#pragma mark - subViews
- (void)setSubViews {
    invitedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight) style:UITableViewStylePlain];
    invitedTableView.backgroundColor = [UIColor whiteColor];
    invitedTableView.tableFooterView = [UIView new];
    invitedTableView.dataSource = self;
    invitedTableView.rowHeight = 80;
    [invitedTableView registerClass:[InvitationTudiListTableViewCell class] forCellReuseIdentifier:@"invitedCell"];
    [self.view addSubview:invitedTableView];
    
    WEAKSELF;
    invitedTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getMyInvitedListIsRefresh:YES];
    }];
    
    invitedTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getMyInvitedListIsRefresh:NO];
    }];
}

#pragma mark - UITableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return invitedListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InvitationTudiListTableViewCell *invitedCell = [tableView dequeueReusableCellWithIdentifier:@"invitedCell"];
    [invitedCell initWithData:invitedListArray[indexPath.row]];
    return invitedCell;
}


@end
