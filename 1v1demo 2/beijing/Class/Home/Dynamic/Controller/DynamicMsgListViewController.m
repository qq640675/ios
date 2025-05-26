//
//  DynamicMsgListViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/1/18.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicMsgListViewController.h"
#import "DynamicAddressTableViewDataSource.h"

@interface DynamicMsgListViewController ()

@end

@implementation DynamicMsgListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

#pragma mark -- UI
- (void)setupUI {
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"评论消息";
    
    [self createTableView];
}

- (void)initTableDatasource {
    
    self.dataSource = [[DynamicAddressTableViewDataSource alloc] initWithCellBlock:nil];
    
    self.baseTableView.dataSource = self.dataSource;
    self.baseTableView.tableFooterView = [UIView new];
    
    [self beginRefresh];
    
}


#pragma mark -- Net
- (void)beginRefresh {
    
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [self getDataWithList];
}

- (void)getDataWithList {
    self.dataSource.sections = [NSMutableArray new];
    [YLNetworkInterface getUserNewCommentList:[YLUserDefault userDefault].t_id block:^(NSMutableArray *listArray) {
        [SVProgressHUD dismiss];
        if ([listArray count] > 0) {
            SLTableViewSectionModel *secModel = [SLTableViewSectionModel new];
            [secModel.listModels addObjectsFromArray:listArray];
            [self.dataSource.sections addObject:secModel];
        }
        [self.baseTableView reloadData];
        [self.baseTableView.mj_header endRefreshing];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
