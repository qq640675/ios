//
//  GuardRankViewController.m
//  beijing
//
//  Created by 黎 涛 on 2021/3/16.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "GuardRankViewController.h"
#import "RankTableViewCell.h"
#import <MJRefresh.h>

@interface GuardRankViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *rankTableView;
    NSArray *rankListArray;
}

@end

@implementation GuardRankViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"守护榜";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setSubViews];
    [self requestRankList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - net
- (void)requestRankList {
    [SVProgressHUD show];
    [YLNetworkInterface getUserGuardGiftListWithId:self.anchorId Success:^(NSArray *dataArr) {
        self->rankListArray = dataArr;
        [self->rankTableView reloadData];
        [self->rankTableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rankListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = rankListArray[indexPath.row];
    RankTableViewCell *rankCell = [tableView dequeueReusableCellWithIdentifier:@"rankCell"];
    [rankCell setGuardRankData:dic];
    rankCell.rankNum = indexPath.row+1;
    return rankCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - func


#pragma mark - setSubViews
- (void)setSubViews {
    rankTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-SafeAreaBottomHeight) style:UITableViewStylePlain];
    rankTableView.backgroundColor = [UIColor clearColor];
    rankTableView.tableFooterView = [UIView new];
    rankTableView.dataSource = self;
    rankTableView.delegate = self;
    rankTableView.rowHeight = 74;
    rankTableView.separatorColor = XZRGB(0xf5f5f5);
    rankTableView.separatorInset = UIEdgeInsetsMake(0, 7.5, 0, 7.5);
    rankTableView.showsVerticalScrollIndicator = NO;
    [rankTableView registerClass:[RankTableViewCell class] forCellReuseIdentifier:@"rankCell"];
    rankTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    [self.view addSubview:rankTableView];
    
    WEAKSELF;
    rankTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestRankList];
    }];
}






@end
