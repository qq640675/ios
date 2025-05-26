//
//  InvitationListViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/3/23.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "InvitationListViewController.h"
#import "PersonCenterTableViewDatasource.h"
#import "SLAlertController.h"
#import "YLRcodeShareController.h"
#import "PopPicViewController.h"

#import "InvitationHeaderView.h"
#import "InvitationMenuView.h"

@interface InvitationListViewController ()
<
InvitationHeaderViewDelegate,
InvitationMenuViewDelegate
>

@property (nonatomic, strong) InvitationHeaderView  *invitationHeaderView;

@property (nonatomic, strong) InvitationMenuView *menuView;

//奖励排行
@property (nonatomic, strong) NSMutableArray   *rewardArray;

//人数排行
@property (nonatomic, strong) NSMutableArray   *numberArray;

//首冲排行
@property (nonatomic, strong) NSMutableArray   *firstCzArray;

//我的徒弟
@property (nonatomic, strong) NSMutableArray   *tudiArray;

//我的徒孙
@property (nonatomic, strong) NSMutableArray   *tusunArray;

@property (nonatomic, copy) NSString    *ruleString;

@property (nonatomic, assign) NSInteger page;

@end

@implementation InvitationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- UI
- (void)setupUI {
    self.navigationItem.title = @"邀请赚钱";
    
    self.bNeedLoadMoreAction = YES;
    
    [self createTableView];
    
    self.baseTableView.tableHeaderView = self.invitationHeaderView;
    self.menuView = [[InvitationMenuView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 100)];
    _menuView.delegate = self;
    self.headerView = _menuView;

}

- (void)initTableDatasource {
    
    self.dataSource = [[PersonCenterTableViewDatasource alloc] initWithCellBlock:nil];
    
    self.baseTableView.dataSource = self.dataSource;
    
    self.dataSource.sections = [NSMutableArray new];
    
    SLTableViewSectionModel *secModel = [SLTableViewSectionModel new];
    [self.dataSource.sections addObject:secModel];
    
    [self getDataWithTotal];
    
    [self getDataWithRule];
    

}

#pragma mark -- Net
- (void)getDataWithTotal {
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    WEAKSELF
    [YLNetworkInterface getShareTotal:[YLUserDefault userDefault].t_id block:^(shareEarnHandle *handle) {

        weakSelf.invitationHeaderView.moneyNumberLb.text = [NSString stringWithFormat:@"%.1f", handle.profitTotal];
        weakSelf.invitationHeaderView.countNumberLb.text = [NSString stringWithFormat:@"%d",handle.oneSpreadCount + handle.twoSpreadCount];
        
        [weakSelf getDataWithReward];
        
    }];
}

- (void)getDataWithReward {
    self.rewardArray = [NSMutableArray new];
    WEAKSELF
    
    NSInteger type = _menuView.selectedSonBtn.tag - 99;
    
    [YLNetworkInterface getSpreadBonuses:[YLUserDefault userDefault].t_id queryType:type block:^(NSMutableArray *listArray) {
        [SVProgressHUD dismiss];
        weakSelf.rewardArray = listArray;
        SLTableViewSectionModel *secModel = [weakSelf.dataSource.sections firstObject];
        [secModel.listModels removeAllObjects];
        [secModel.listModels addObjectsFromArray:weakSelf.rewardArray];
        weakSelf.baseTableView.tableFooterView = [UIView new];
        [weakSelf.baseTableView reloadData];
    }];
}


- (void)getDataWithSpreadUser {
    self.numberArray = [NSMutableArray new];
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    WEAKSELF
    
    NSInteger type = _menuView.selectedSonBtn.tag - 99;
    
    [YLNetworkInterface getSpreadUser:[YLUserDefault userDefault].t_id queryType:type block:^(NSMutableArray *listArray) {
        [SVProgressHUD dismiss];
        weakSelf.numberArray = listArray;
        SLTableViewSectionModel *secModel = [weakSelf.dataSource.sections firstObject];
        [secModel.listModels removeAllObjects];
        [secModel.listModels addObjectsFromArray:weakSelf.numberArray];
        weakSelf.baseTableView.tableFooterView = [UIView new];
        [weakSelf.baseTableView reloadData];
    }];
    
}

- (void)getDataWithFirstCz {
    self.firstCzArray = [NSMutableArray new];
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    WEAKSELF
    
    NSInteger type = _menuView.selectedSonBtn.tag - 99;
    
    [YLNetworkInterface getFirstCharge:[YLUserDefault userDefault].t_id queryType:type block:^(NSMutableArray *listArray) {
        [SVProgressHUD dismiss];
        weakSelf.firstCzArray = listArray;
        SLTableViewSectionModel *secModel = [weakSelf.dataSource.sections firstObject];
        [secModel.listModels removeAllObjects];
        [secModel.listModels addObjectsFromArray:weakSelf.firstCzArray];
        weakSelf.baseTableView.tableFooterView = [UIView new];
        [weakSelf.baseTableView reloadData];
    }];
    
}


- (void)getDataWithMyTudi {
    if (_page > 1) {
        [self.loadMoreView startLoadMore];
    }
    WEAKSELF
    [YLNetworkInterface getShareUserList:[YLUserDefault userDefault].t_id page:(int)_page type:1 block:^(NSMutableArray *listArray) {
        [SVProgressHUD dismiss];
        SLTableViewSectionModel *secModel = [weakSelf.dataSource.sections firstObject];
        if (weakSelf.page == 1) {
            if ([listArray count] == 0) {
                [SVProgressHUD showInfoWithStatus:@"暂无数据"];
            }
            [secModel.listModels removeAllObjects];
            weakSelf.tudiArray = [NSMutableArray new];
        } else {
            [weakSelf.loadMoreView stopLoadMore];
        }
        weakSelf.tudiArray = listArray;
        
        [secModel.listModels addObjectsFromArray:weakSelf.tudiArray];
        
        if ([listArray count] < 10) {
            weakSelf.baseTableView.tableFooterView = [UIView new];
        } else {
            weakSelf.baseTableView.tableFooterView = self.loadMoreView;
            weakSelf.page ++;
        }
        
        [weakSelf.baseTableView reloadData];
        
    }];
}

- (void)getDataWithMyTusun {
    if (_page > 1) {
        [self.loadMoreView startLoadMore];
    }
    WEAKSELF
    [YLNetworkInterface getShareUserList:[YLUserDefault userDefault].t_id page:(int)_page type:2 block:^(NSMutableArray *listArray) {
        [SVProgressHUD dismiss];
        SLTableViewSectionModel *secModel = [weakSelf.dataSource.sections firstObject];
        if (weakSelf.page == 1) {
            if ([listArray count] == 0) {
                [SVProgressHUD showInfoWithStatus:@"暂无数据"];
            }
            [secModel.listModels removeAllObjects];
            weakSelf.tusunArray = [NSMutableArray new];
        } else {
            [weakSelf.loadMoreView stopLoadMore];
        }
        weakSelf.tusunArray = listArray;
        
        [secModel.listModels addObjectsFromArray:weakSelf.tusunArray];
        
        if ([listArray count] < 10) {
            weakSelf.baseTableView.tableFooterView = [UIView new];
        } else {
            weakSelf.baseTableView.tableFooterView = self.loadMoreView;
            weakSelf.page++;
        }
        
        [weakSelf.baseTableView reloadData];
    }];
}


- (void)getDataWithRule {
    WEAKSELF
    [YLNetworkInterface getSpreadAward:[YLUserDefault userDefault].t_id block:^(NSString *t_award_rule) {
        if (![NSString isNullOrEmpty:t_award_rule]) {
            weakSelf.ruleString = t_award_rule;
        }
    }];
}

- (void)loadMoreData {
    if (_menuView.selectedBtn.tag == 2) {
        //徒弟
        [self getDataWithMyTudi];
    } else {
        //徒孙
        [self getDataWithMyTusun];
    }
}

#pragma mark -- Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 100;
}

- (void)didSelectInvitationHeaderViewWithBtn:(UIButton *)btn {
    if (btn.tag == 1) {
        PopPicViewController *vc = [[PopPicViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [SLAlertController alertControllerWithStyle:UIAlertControllerStyleAlert controller:self alertControllerTitle:@"奖励规则" alertControllerMessage:_ruleString alertControllerSheetActionTitles:nil alertControllerSureActionTitle:nil alertControllerCancelActionTitle:@"知道了" alertControllerSheetActionBlock:nil alertControllerAlertSureActionBlock:nil alertControllerAlertCancelActionBlock:nil];
    }
}

- (void)didSelectInvitationMenuViewWithBtn:(UIButton *)btn {
    NSInteger tag = btn.tag;
    if (tag == 0)
    {
        //奖励排行
        [self getDataWithReward];
    }
    else if (tag == 1)
    {
        //人数排行
        [self getDataWithSpreadUser];
    }
    else if (tag == 2)
    {
        //首冲排行
        [self getDataWithFirstCz];
    }
    else if (tag == 3)
    {
        //我的徒弟
        _page = 1;
        [self getDataWithMyTudi];
    }
    
}

#pragma mark -- Lazy load
- (InvitationHeaderView *)invitationHeaderView {
    if (!_invitationHeaderView) {
        _invitationHeaderView = [[InvitationHeaderView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 360)];
        _invitationHeaderView.delegate = self;
    }
    return _invitationHeaderView;
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
