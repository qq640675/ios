//
//  ServiceListViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/8/3.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "ServiceListViewController.h"
#import "ServiceListTableViewCell.h"
#import "ServiceChatViewController.h"
#import <MJRefresh.h>
#import "BaseView.h"
#import "YLNetworkInterface.h"

@interface ServiceListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *serviceTableView;
    NSMutableArray *serviceListArray; //数据
}

@end

@implementation ServiceListViewController

#pragma amrk - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"请选择客服";
    serviceListArray = [NSMutableArray array];
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
    [SVProgressHUD show];
    [YLNetworkInterface getServiceIdSuccess:^(NSArray *idArray) {
        [SVProgressHUD dismiss];
        [self->serviceTableView.mj_header endRefreshing];
        [self->serviceTableView.mj_footer endRefreshing];
        self->serviceTableView.mj_footer.state = MJRefreshStateNoMoreData;
        [self->serviceTableView.mj_footer endRefreshingWithNoMoreData];
        self->serviceListArray = [NSMutableArray arrayWithArray:idArray];
        [self->serviceTableView reloadData];
        
        NSString *ids;
        for (int i = 0; i < idArray.count; i ++) {
            NSDictionary *dic = idArray[i];
            if (i == 0) {
                ids = [NSString stringWithFormat:@"%@", dic[@"t_id"]];
            } else {
                ids = [NSString stringWithFormat:@"%@,%@", ids, dic[@"t_id"]];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:ids forKey:@"serviceids"];
    }];
}

#pragma mark - subViews
- (void)setSubViews {
    serviceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight) style:UITableViewStylePlain];
    serviceTableView.backgroundColor = [UIColor whiteColor];
    serviceTableView.tableFooterView = [UIView new];
    serviceTableView.dataSource = self;
    serviceTableView.delegate = self;
    serviceTableView.rowHeight = 70;
    [serviceTableView registerClass:[ServiceListTableViewCell class] forCellReuseIdentifier:@"serviceCell"];
    [self.view addSubview:serviceTableView];
    
    WEAKSELF;
    serviceTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getBlackListIsRefresh:YES];
    }];
    
    serviceTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getBlackListIsRefresh:NO];
    }];
}

#pragma mark - UITableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return serviceListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceListTableViewCell *serviceCell = [tableView dequeueReusableCellWithIdentifier:@"serviceCell"];
    if (serviceListArray.count > indexPath.row) {
        [serviceCell setData:serviceListArray[indexPath.row]];
    }
    return serviceCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > serviceListArray.count) return;
    NSDictionary *dic = serviceListArray[indexPath.row];
    ServiceChatViewController *chatVC = [[ServiceChatViewController alloc] init];
    chatVC.otherUserId = [[NSString stringWithFormat:@"%@", dic[@"t_id"]] integerValue];
    [self.navigationController pushViewController:chatVC animated:YES];
}



@end
