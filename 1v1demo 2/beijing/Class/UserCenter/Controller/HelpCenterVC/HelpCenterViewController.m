//
//  HelpCenterViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/3/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "PersonCenterTableViewDatasource.h"

@interface HelpCenterViewController ()

@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setupUI {
    self.navigationItem.title = @"帮助中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTableView];
    self.baseTableView.tableFooterView = [UIView new];
    
    self.baseTableView.height = APP_Frame_Height;

}

- (void)initTableDatasource {
    
    self.dataSource = [[PersonCenterTableViewDatasource alloc] initWithCellBlock:nil];
    
    self.baseTableView.dataSource = self.dataSource;
    
    self.dataSource.sections = [NSMutableArray new];
    
    [self getDataWithList];
}

- (void)getDataWithList {
    
    [SVProgressHUD show];
    
    WEAKSELF
    [YLNetworkInterface getHelpCenter:[YLUserDefault userDefault].t_id block:^(NSMutableArray *listArray) {
        [SVProgressHUD dismiss];
        if ([listArray count] > 0) {
            SLTableViewSectionModel *secModel = [SLTableViewSectionModel new];
            [secModel.listModels addObjectsFromArray:listArray];
            [weakSelf.dataSource.sections addObject:secModel];
            
            [weakSelf.baseTableView reloadData];
        }
    }];
}

- (void)clickedTableCell:(SLBaseListModel *)listModel {
    HelpCenterListModel *model = (HelpCenterListModel *)listModel;
    model.isOpen = !model.isOpen;
    model.cellHeight = 0;
    
    [self.baseTableView reloadData];
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
