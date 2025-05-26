//
//  ChatLivingMsgListViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/2/28.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "ChatLivingMsgListViewController.h"


@interface ChatLivingMsgListViewController ()

@end

@implementation ChatLivingMsgListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

#pragma mark -- UI
- (void)setupUI {
    
    self.tableViewCellSeparatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self createTableView];
    
    self.baseTableView.backgroundColor = [UIColor clearColor];
    
    if ([[TIMManager sharedInstance] getLoginStatus] != 1) {
        [SLHelper TIMLoginSuccess:nil fail:nil];
    }
    
}

- (void)initTableDatasource {
    
    self.dataSource = [[ChatLivingMsgListTableViewDatasource alloc] initWithCellBlock:nil];
    
    self.baseTableView.dataSource = self.dataSource;
    self.baseTableView.tableFooterView = [UIView new];
    
    
    [self setupTableFrame];
    
    self.dataSource.sections = [NSMutableArray new];
    SLTableViewSectionModel *secModel = [SLTableViewSectionModel new];
    [self.dataSource.sections addObject:secModel];
    
}

- (void)setupTableFrame {
    self.baseTableView.width  = App_Frame_Width-20;
    self.baseTableView.height = 180;
}

- (void)setListArray:(NSMutableArray *)listArray {
    _listArray = listArray;
    
    SLTableViewSectionModel *secModel = [self.dataSource.sections firstObject];
    [secModel.listModels addObjectsFromArray:listArray];
    
    [self.baseTableView reloadData];
    
    [self scrollTableToFoot:YES];
}

- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [self.baseTableView numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self.baseTableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self.baseTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO]; //滚动到最后一行
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
