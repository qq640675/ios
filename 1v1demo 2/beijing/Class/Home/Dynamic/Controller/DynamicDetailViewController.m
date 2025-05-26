//
//  DynamicDetailViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/1/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicDetailViewController.h"

#import "DynamicDetailNavigationView.h"
#import "DynamicDetailHeaderView.h"
#import "DynamicDetailTableViewDataSource.h"
#import "DynamicCommentTextView.h"


@interface DynamicDetailViewController ()
<
DynamicDetailNavigationViewDelegate,
DynamicDetailHeaderViewDelegate
>

@property (nonatomic, strong) DynamicDetailNavigationView   *navigationBarView;

@property (nonatomic, strong) DynamicDetailHeaderView       *detailHeaderView;

@property (nonatomic, strong) DynamicCommentTextView        *commentTextView;

@property (nonatomic, strong) UIView                        *commentHederView;

@property (nonatomic, strong) UILabel                       *commentNumLb;

@property (nonatomic, assign) NSInteger                      page;

@end

@implementation DynamicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bNeedLoadMoreAction = YES;
    
    [self createTableView];
    
    [self.view addSubview:self.navigationBarView];
    _navigationBarView.dynamicListModel = _listModel;
    
    [self.view addSubview:self.commentTextView];
    __weak typeof(self) weakSelf = self;
    _commentTextView.clickedSendBtnBlock = ^(NSString *content) {
        [weakSelf postDataWithComment:content];
    };
    
}

- (void)initTableDatasource {
    
    SLTableViewCellBlock cellBlock = ^(SLBaseTableViewCell *cell, SLBaseListModel *model) {
//        [self forCellDelegate:cell listModel:model];
    };
    
    self.dataSource = [[DynamicDetailTableViewDataSource alloc] initWithCellBlock:cellBlock];
    
    self.baseTableView.dataSource = self.dataSource;
    self.baseTableView.tableFooterView = [UIView new];
    
    self.baseTableView.tableHeaderView = self.detailHeaderView;
    
    [self setupTableFrame];
    
}

- (void)setupTableFrame {
    self.baseTableView.y = 0;
    self.baseTableView.height = APP_Frame_Height-50;
    
    [self beginRefresh];
}

#pragma mark -- Net
- (void)beginRefresh {
    _detailHeaderView.listModel = _listModel;
    
    self.dataSource.sections = [NSMutableArray new];
    SLTableViewSectionModel *secModel = [SLTableViewSectionModel new];
    SLTableViewSectionModel *commentSecModel = [SLTableViewSectionModel new];
    [self.dataSource.sections addObject:secModel];
    [self.dataSource.sections addObject:commentSecModel];
    
    DynamicDetailContentModel *contentModel = [DynamicDetailContentModel new];
    contentModel.content = _listModel.t_content;
    [secModel.listModels addObject:contentModel];
    
    self.commentNumLb.text = [NSString stringWithFormat:@"评论%ld",(long)_listModel.t_commentCount];
    
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
    
    [YLNetworkInterface getDynamicCommentList:[YLUserDefault userDefault].t_id page:_page dynamicId:_listModel.t_dynamicId block:^(NSMutableArray *listArray) {
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
        SLTableViewSectionModel *secModel = [self.dataSource.sections lastObject];
        [secModel.listModels addObjectsFromArray:listArray];
        [self.baseTableView reloadData];
    }];
}


- (void)postDataWithComment:(NSString *)content {
    [SVProgressHUD showWithStatus:@"发送中..."];
    
    [YLNetworkInterface addDynamicComment:[YLUserDefault userDefault].t_id coverUserId:0 dynamicId:_listModel.t_dynamicId comment:content block:^(int code) {
        if (code == 1) {
            [SVProgressHUD showInfoWithStatus:@"评论成功，等待审核～"];
        }
    }];
}

- (void)postDataWithLove {

    [YLNetworkInterface dynamicLove:[YLUserDefault userDefault].t_id dynamicId:_listModel.t_dynamicId block:^(BOOL isSuccess) {
        if (isSuccess) {
            [SVProgressHUD showInfoWithStatus:@"点赞成功"];
            self->_listModel.isPraise = YES;
            self->_listModel.t_praiseCount ++;
            self->_detailHeaderView.listModel = self->_listModel;
            
        }
    }];
}


#pragma mark -- Delegate
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        [self.commentHederView addSubview:_commentNumLb];
        return _commentHederView;
    }
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }
    return 0;
}

- (void)didSelectDynamicDetailNavigationViewWithBtn:(NSInteger)tag {
    if (tag == 1) {
        //返回
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        //聊天
        
    }
}

- (void)didSelectDynamicDetailHeaderViewWithBtn:(NSInteger)tag {
    if (tag == 1) {
        //点赞
        if (_listModel.isPraise) {
            [SVProgressHUD showInfoWithStatus:@"你已经赞过了～"];
            return;
        }
        [self postDataWithLove];
    } else {
        //评论
    }
}

#pragma mark - Keyboard notification
- (void)keyboardShow:(NSNotification *)note {
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.commentTextView.y = APP_Frame_Height-50-deltaY;
    }];
    
}

- (void)keyboardHide:(NSNotification *)note {
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.commentTextView.y = APP_Frame_Height-50;
    }];
    
}


#pragma mark -- Lazy loading
- (DynamicDetailNavigationView *)navigationBarView {
    if (!_navigationBarView) {
        _navigationBarView = [[DynamicDetailNavigationView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, SafeAreaTopHeight)];
        _navigationBarView.backgroundColor = [UIColor whiteColor];
        _navigationBarView.delegate = self;
    }
    return _navigationBarView;
}

- (DynamicDetailHeaderView *)detailHeaderView {
    if (!_detailHeaderView) {
        CGFloat fHeight = ((App_Frame_Width-32)*545)/343;
        if (_listModel.fileArrays.count == 0) {
            fHeight = 0;
        }
        _detailHeaderView = [[DynamicDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, fHeight+67)];
        _detailHeaderView.delegate = self;
    }
    return _detailHeaderView;
}

- (UIView *)commentHederView {
    if (!_commentHederView) {
        _commentHederView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 40)];
        _commentHederView.backgroundColor = [UIColor whiteColor];
    }
    return _commentHederView;
}

- (UILabel *)commentNumLb {
    if (!_commentNumLb) {
        _commentNumLb = [UIManager initWithLabel:CGRectMake(15, 0, App_Frame_Width-50, 40) text:@"评论0" font:15.0f textColor:XZRGB(0xfc2947)];
        _commentNumLb.textAlignment = NSTextAlignmentLeft;
        _commentNumLb.font = [UIFont fontWithName:@"MicrosoftYaHei" size:15.0f];
    }
    return _commentNumLb;
}

- (DynamicCommentTextView *)commentTextView {
    if (!_commentTextView) {
        _commentTextView = [[DynamicCommentTextView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height-50, App_Frame_Width, 50)];
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
