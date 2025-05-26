//
//  DynamicCommentListViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/1/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicCommentListViewController.h"

//tool
#import "DynamicListTableViewDataSource.h"

@interface DynamicCommentListViewController ()
<
DynamicCommentListTableViewCellDelegate
>

@property (nonatomic, strong) UILabel   *commentNumLb;

@property (nonatomic, assign) NSInteger  page;

@end

@implementation DynamicCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

#pragma mark -- UI
- (void)setupUI {
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_Frame_Height, 200)];
    blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedBgView)];
    [blackView addGestureRecognizer:tap];
    [self.view addSubview:blackView];
    
    self.bNeedLoadMoreAction = YES;
    [self createTableView];
}

- (void)initTableDatasource {
    
    SLTableViewCellBlock cellBlock = ^(SLBaseTableViewCell *cell, SLBaseListModel *model) {
        [self forCellDelegate:cell listModel:model];
    };
    
    self.dataSource = [[DynamicListTableViewDataSource alloc] initWithCellBlock:cellBlock];
    
    self.baseTableView.dataSource = self.dataSource;
    self.baseTableView.tableFooterView = [UIView new];
    
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, App_Frame_Width, 55)];
    hView.backgroundColor = [UIColor whiteColor];
    [hView addSubview:self.commentNumLb];
    _commentNumLb.text = [NSString stringWithFormat:@"评论%@",_commentNum];
    [self.view addSubview:hView];
    
    [self.view addSubview:self.commentTextView];
    
    __weak typeof(self) weakSelf = self;
    _commentTextView.clickedSendBtnBlock = ^(NSString *content) {
        [weakSelf postDataWithComment:content];
    };
    
    [self setupTableFrame];
    
}

- (void)setupTableFrame {

    self.baseTableView.y = 200;
    self.baseTableView.height = APP_Frame_Height-250;
    
    [self beginRefresh];
}

#pragma mark -- Net
- (void)beginRefresh {
    self.dataSource.sections = [NSMutableArray new];
    SLTableViewSectionModel *secModel = [SLTableViewSectionModel new];
    [self.dataSource.sections addObject:secModel];
    
    _page = 1;
    [self getDataWithList];
}

- (void)loadMoreData {
    _page ++;
    [self getDataWithList];
}

- (void)getDataWithList {
    if (_page > 1) {
        [self.loadMoreView startLoadMore];
    } else {
        [SVProgressHUD showWithStatus:@"努力加载中..."];
    }
    
    [YLNetworkInterface getDynamicCommentList:[YLUserDefault userDefault].t_id page:_page dynamicId:_dynamicId block:^(NSMutableArray *listArray) {
        [SVProgressHUD dismiss];
        if (self.page == 1) {
            [self.baseTableView.mj_header endRefreshing];
        } else {
            [self.loadMoreView stopLoadMore];
        }
        if ([listArray count] < 10) {
            self.baseTableView.tableFooterView = [UIView new];
        } else {
            self.baseTableView.tableFooterView = self.loadMoreView;
        }
        SLTableViewSectionModel *secModel = [self.dataSource.sections firstObject];
        [secModel.listModels addObjectsFromArray:listArray];
        [self.baseTableView reloadData];
    }];
}


- (void)postDataWithComment:(NSString *)content {
    [SVProgressHUD showWithStatus:@"发送中..."];
    
    [YLNetworkInterface addDynamicComment:[YLUserDefault userDefault].t_id coverUserId:_commentedUserId dynamicId:_dynamicId comment:content block:^(int code) {
        if (code == 1) {
            [SVProgressHUD showInfoWithStatus:@"评论成功，等待审核"];
            [self clickedBgView];
        }
    }];
}

- (void)postDataWithDeleteComment:(DynamicCommentListModel *)model {
    
    [YLNetworkInterface deleteDynamicComment:[YLUserDefault userDefault].t_id commentId:model.comId block:^(int code) {
        if (code == 1) {
            [SVProgressHUD showInfoWithStatus:@"删除成功"];
            SLTableViewSectionModel *secModel = [self.dataSource.sections firstObject];
            [secModel.listModels removeObject:model];
            [self.baseTableView reloadData];
        }
    }];
}

- (void)forCellDelegate:(SLBaseTableViewCell *)tableCell listModel:(SLBaseListModel *)listModel {
    if ([tableCell isKindOfClass:[DynamicCommentListTableViewCell class]]) {
        DynamicCommentListTableViewCell *cell = (DynamicCommentListTableViewCell *)tableCell;
        cell.delegate = self;
    }
}

- (void)didSelectDynamicCommentListTableViewCellWithDelete:(DynamicCommentListModel *)model {
    //删除自己的评论
    [self postDataWithDeleteComment:model];
}

#pragma mark -- Action
- (void)clickedBgView {
    [self.view removeFromSuperview];
}

#pragma mark -- Lazy loading
- (UILabel *)commentNumLb {
    if (!_commentNumLb) {
        _commentNumLb = [UIManager initWithLabel:CGRectMake(15, 0, App_Frame_Width-50, 55) text:@"评论0" font:15.0f textColor:XZRGB(0x353535)];
        _commentNumLb.textAlignment = NSTextAlignmentLeft;
        _commentNumLb.font = [UIFont fontWithName:@"MicrosoftYaHei" size:15.0f];
    }
    return _commentNumLb;
}

- (DynamicCommentTextView *)commentTextView {
    if (!_commentTextView) {
        _commentTextView = [[DynamicCommentTextView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height-SafeAreaBottomHeight+49-50, App_Frame_Width, 50)];
    }
    return _commentTextView;
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
