//
//  WatchedMeViewController.m
//  beijing
//
//  Created by 黎 涛 on 2019/6/27.
//  Copyright © 2019 zhou last. All rights reserved.
//

//vc
#import "WatchedMeViewController.h"
// view
#import "NewFollowTableViewCell.h"
//other
#import "YLPushManager.h"
#import <MJRefresh.h>

@interface WatchedMeViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *watchedMeTableView;
    int nPage; //页码
    NSMutableArray *watchedMeListArray; //数据
}

@end

@implementation WatchedMeViewController

#pragma amrk - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"谁看过我";
    watchedMeListArray = [NSMutableArray array];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setSubViews];
    [self getMyFollowDataIsRefresh:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - net
- (void)getMyFollowDataIsRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        nPage = 1;
    } else {
        nPage ++;
    }
    [SVProgressHUD show];
    [YLNetworkInterface getCoverBrowseListWithUserId:[NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id] page:nPage Success:^(NSArray *dataArray, NSString *totelNum) {
        [SVProgressHUD dismiss];
        [self->watchedMeTableView.mj_header endRefreshing];
        [self->watchedMeTableView.mj_footer endRefreshing];
        if (dataArray == nil) {
            self->nPage --;
            return ;
        }
        if ([dataArray count] < 10) {
            self->watchedMeTableView.mj_footer.state = MJRefreshStateNoMoreData;
            [self->watchedMeTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self->nPage == 1) {
            self->watchedMeListArray = [NSMutableArray arrayWithArray:dataArray];
        } else {
            [self->watchedMeListArray addObjectsFromArray:dataArray];
        }
        
        [self->watchedMeTableView reloadData];
    } fail:^{
        [SVProgressHUD dismiss];
        [self->watchedMeTableView.mj_header endRefreshing];
        [self->watchedMeTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - subViews
- (void)setSubViews {
    watchedMeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight) style:UITableViewStylePlain];
    watchedMeTableView.backgroundColor = [UIColor whiteColor];
    watchedMeTableView.tableFooterView = [UIView new];
    watchedMeTableView.dataSource = self;
    watchedMeTableView.delegate = self;
    watchedMeTableView.rowHeight = 70;
    [watchedMeTableView registerClass:[NewFollowTableViewCell class] forCellReuseIdentifier:@"watchedMeCell"];
    [self.view addSubview:watchedMeTableView];
    
    WEAKSELF;
    watchedMeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getMyFollowDataIsRefresh:YES];
    }];
    
    watchedMeTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getMyFollowDataIsRefresh:NO];
    }];
}

#pragma mark - UITableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return watchedMeListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WatchedModel *model = watchedMeListArray[indexPath.row];
    NewFollowTableViewCell *watchedMeCell = [tableView dequeueReusableCellWithIdentifier:@"watchedMeCell"];
    watchedMeCell.isFootPoint = NO;
    watchedMeCell.model = model;
//    WEAKSELF;
//    watchedMeCell.followButtonClick = ^{
//        [weakSelf cancleFollowWithIndex:indexPath.row];
//    };
    return watchedMeCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (watchedMeListArray.count != 0) {
        WatchedModel *model = watchedMeListArray[indexPath.row];
        if (model.t_role == 1) {
            [YLPushManager pushAnchorDetail:model.t_id];
        } else {
            [YLPushManager pushFansDetail:model.t_id];
        }
        
    }
}

#pragma mark - func
//- (void)cancleFollowWithIndex:(NSInteger)index {
//    WatchedModel *model = watchedMeListArray[index];
//    if (model.isFollow) {
//        // 取消关注
//        [YLNetworkInterface cancelAtttention:[YLUserDefault userDefault].t_id coverFollowUserId:(int)model.t_id  block:^(BOOL isSuccess) {
//            [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
//            for (int i = 0; i < [self->watchedMeListArray count]; i++) {
//                WatchedModel *listModel = self->watchedMeListArray[i];
//                if (model.t_id == listModel.t_id) {
//                    listModel.isFollow = NO;
//                }
//            }
//            [self->watchedMeTableView reloadData];
//        }];
//    } else {
//        // 关注
//        [YLNetworkInterface addAttention:[YLUserDefault userDefault].t_id coverFollowUserId:(int)model.t_id block:^(BOOL isSuccess) {
//            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
//            for (int i = 0; i < [self->watchedMeListArray count]; i++) {
//                WatchedModel *listModel = self->watchedMeListArray[i];
//                if (model.t_id == listModel.t_id) {
//                    listModel.isFollow = YES;
//                }
//            }
//            [self->watchedMeTableView reloadData];
//        }];
//    }
//}



@end
