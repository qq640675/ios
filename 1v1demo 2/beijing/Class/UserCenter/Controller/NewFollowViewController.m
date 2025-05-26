//
//  NewFollowViewController.m
//  beijing
//
//  Created by 黎 涛 on 2019/6/27.
//  Copyright © 2019 zhou last. All rights reserved.
//

// vc
#import "NewFollowViewController.h"
// view
#import "NewFollowTableViewCell.h"
// model
#import "attentionInfoHandle.h"
//other
#import "YLPushManager.h"
#import <MJRefresh.h>
#import "LXTAlertView.h"

@interface NewFollowViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *followTableView;
    int nPage; //页码
    NSMutableArray *followListArray; //我的关注数据
}

@end

@implementation NewFollowViewController

#pragma amrk - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    if (self.type == 0) {
        self.navigationItem.title = @"谁喜欢我";
    } else if (self.type == 1) {
        self.navigationItem.title = @"我喜欢谁";
    } else if (self.type == 2) {
        self.navigationItem.title = @"相互喜欢";
    }
    
    followListArray = [NSMutableArray array];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setSubViews];
    [self getMyFollowDataIsRefresh:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isHomePage) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark - net
- (void)getMyFollowDataIsRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        nPage = 1;
    } else {
        nPage ++;
    }
    [SVProgressHUD show];
    [YLNetworkInterface getLikeListWithPage:nPage type:self.type block:^(NSMutableArray *listArray) {
        [SVProgressHUD dismiss];
        [self->followTableView.mj_header endRefreshing];
        [self->followTableView.mj_footer endRefreshing];
        if (listArray == nil) {
            self->nPage --;
            return ;
        }
        if ([listArray count] < 10) {
            self->followTableView.mj_footer.state = MJRefreshStateNoMoreData;
            [self->followTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self->nPage == 1) {
            self->followListArray = [NSMutableArray arrayWithArray:listArray];
        } else {
            [self->followListArray addObjectsFromArray:listArray];
        }
        
        [self->followTableView reloadData];
    }];
}

#pragma mark - subViews
- (void)setSubViews {
    followTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight) style:UITableViewStylePlain];
    if (self.isHomePage == YES) {
        followTableView.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight-SafeAreaBottomHeight);
    }
    followTableView.backgroundColor = [UIColor whiteColor];
    followTableView.tableFooterView = [UIView new];
    followTableView.dataSource = self;
    followTableView.delegate = self;
    followTableView.rowHeight = 70;
    [followTableView registerClass:[NewFollowTableViewCell class] forCellReuseIdentifier:@"followCell"];
    [self.view addSubview:followTableView];
    
    WEAKSELF;
    followTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getMyFollowDataIsRefresh:YES];
    }];
    
    followTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getMyFollowDataIsRefresh:NO];
    }];
}

#pragma mark - UITableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return followListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    attentionInfoHandle *handle = followListArray[indexPath.row];
    NewFollowTableViewCell *followCell = [tableView dequeueReusableCellWithIdentifier:@"followCell"];
    followCell.handle = handle;
    WEAKSELF;
    followCell.followButtonClick = ^{
        [weakSelf cancleFollowWithIndex:indexPath.row];
    };
    return followCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (followListArray.count != 0) {
        attentionInfoHandle *handle = followListArray[indexPath.row];
        if (handle.t_role == 1) {
            [YLPushManager pushAnchorDetail:handle.t_id];
        } else {
            [YLPushManager pushFansDetail:handle.t_id];
        }
    }
}

#pragma mark - func
- (void)cancleFollowWithIndex:(NSInteger)index {
    attentionInfoHandle *handle = followListArray[index];
    if (handle.isFollow) {
        // 取消关注
        [YLNetworkInterface cancelAtttention:[YLUserDefault userDefault].t_id coverFollowUserId:(int)handle.t_id  block:^(BOOL isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            for (int i = 0; i < [self->followListArray count]; i++) {
                WatchedModel *listModel = self->followListArray[i];
                if (handle.t_id == listModel.t_id) {
                    listModel.isFollow = NO;
                }
            }
            [self->followTableView reloadData];
        }];
    } else {
        // 关注
        [YLNetworkInterface addAttention:[YLUserDefault userDefault].t_id coverFollowUserId:(int)handle.t_id block:^(BOOL isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            for (int i = 0; i < [self->followListArray count]; i++) {
                WatchedModel *listModel = self->followListArray[i];
                if (handle.t_id == listModel.t_id) {
                    listModel.isFollow = YES;
                }
            }
            [self->followTableView reloadData];
        }];
    }
}




@end
