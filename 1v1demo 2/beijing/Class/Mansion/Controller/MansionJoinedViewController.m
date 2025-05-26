//
//  MansionJoinedViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/6.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MansionJoinedViewController.h"
#import "MansionJoinedTableViewCell.h"
#import <MJRefresh.h>
#import "MansionVideoViewController.h"

@interface MansionJoinedViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *mansionTableView;
    int nPage; //页码
    NSMutableArray *mansionListArray; //数据
}

@end

@implementation MansionJoinedViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.whiteColor;
    mansionListArray = [NSMutableArray array];
    [self setSubViews];
    [self requestMyMansionDataIsRefresh:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - net
- (void)requestMyMansionDataIsRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        nPage = 1;
    } else {
        nPage ++;
    }
    [SVProgressHUD show];
    [YLNetworkInterface getMansionHouseListWithPage:nPage success:^(NSArray *dataArray) {
        [SVProgressHUD dismiss];
        [self->mansionTableView.mj_header endRefreshing];
        [self->mansionTableView.mj_footer endRefreshing];
        if (dataArray == nil) {
            self->nPage --;
            return ;
        }
        if ([dataArray count] < 10) {
            self->mansionTableView.mj_footer.state = MJRefreshStateNoMoreData;
            [self->mansionTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self->nPage == 1) {
            self->mansionListArray = [NSMutableArray arrayWithArray:dataArray];
        } else {
            [self->mansionListArray addObjectsFromArray:dataArray];
        }

        [self->mansionTableView reloadData];
    } fail:^{
        [SVProgressHUD dismiss];
        [self->mansionTableView.mj_header endRefreshing];
        [self->mansionTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - sub view
- (void)setSubViews {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, SafeAreaTopHeight)];
    [self.view addSubview:view];
    
    UILabel *titleLabel = [UIManager initWithLabel:CGRectMake(0, SafeAreaTopHeight-44, 180, 44) text:@"我加入的府邸" font:24 textColor:XZRGB(0x3f3b48)];
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [view addSubview:titleLabel];

//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.x+titleLabel.width/2-4, 40, 8, 4)];
//    line.backgroundColor = XZRGB(0x3f3b48);
//    line.layer.masksToBounds = YES;
//    line.layer.cornerRadius = 2;
//    [self.view addSubview:line];
    
    mansionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight-SafeAreaBottomHeight-SafeAreaTopHeight) style:UITableViewStylePlain];
    mansionTableView.backgroundColor = [UIColor whiteColor];
    mansionTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    mansionTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    mansionTableView.dataSource = self;
    mansionTableView.delegate = self;
    mansionTableView.rowHeight = (App_Frame_Width-24)*0.4+12;
    mansionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mansionTableView.showsVerticalScrollIndicator = NO;
    [mansionTableView registerClass:[MansionJoinedTableViewCell class] forCellReuseIdentifier:@"mansionJoinedCell"];
    [self.view addSubview:mansionTableView];
    
    WEAKSELF;
    mansionTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestMyMansionDataIsRefresh:YES];
    }];

    mansionTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestMyMansionDataIsRefresh:NO];
    }];
}

#pragma mark - UITableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mansionListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MansionJoinedTableViewCell *mansionJoinedCell = [tableView dequeueReusableCellWithIdentifier:@"mansionJoinedCell"];
    [mansionJoinedCell setJoinedModel: mansionListArray[indexPath.row]];
    WEAKSELF;
    mansionJoinedCell.deleteButtonClickBlock = ^{
        [weakSelf deleteButtonClick:indexPath.row];
    };
    return mansionJoinedCell;
}

#pragma mark - func
- (void)deleteButtonClick:(NSInteger)index {
    [LXTAlertView alertViewDefaultWithTitle:@"温馨提示" message:@"确定退出府邸？" sureHandle:^{
        MansionJoinedModel *model = self->mansionListArray[index];
        [YLNetworkInterface anchorOutOfMansionHouseWithMansionid:model.t_id success:^{
            [self->mansionListArray removeObject:model];
            [self->mansionTableView reloadData];
        }];
    }];
    
    
}


@end
