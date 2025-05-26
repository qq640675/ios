//
//  AnchorDynamicViewController.m
//  beijing
//
//  Created by 黎 涛 on 2021/3/15.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "AnchorDynamicViewController.h"
#import "YLNetworkInterface.h"
#import "DynamicCommentListViewController.h"
#import "LXTAlertView.h"
#import "YLReportController.h"
#import "YLInsufficientManager.h"
#import "VideoPlayViewController.h"
#import "DynamicListTableViewCell.h"

@interface AnchorDynamicViewController ()<UITableViewDataSource, UITableViewDelegate, DynamicListTableViewCellDelegate>

{
    NSInteger dynamicPage;
}
@property (nonatomic, strong) DynamicCommentListViewController  *commentListVC;

@end

@implementation AnchorDynamicViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"动态";
    [self setSubViews];
    [self requestDynamicIsRefresh:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - net
- (void)requestDynamicIsRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        dynamicPage = 1;
    } else {
        dynamicPage ++;
    }
    [YLNetworkInterface getPriDynamicList:[YLUserDefault userDefault].t_id coverUserId:self.anthorId page:dynamicPage reqType:0 block:^(NSMutableArray *listArray) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (listArray == nil) {
            self->dynamicPage --;
            return ;
        }
        BOOL isSelf = NO;
        if (self.anthorId == [YLUserDefault userDefault].t_id) {
            isSelf = YES;
        }
        NSArray *modelArray = [JsonToModelTool DetailDynamicListJsonToModelWithJsonArray:listArray isMine:isSelf];
        if (self->dynamicPage == 1) {
            self.dataArray = [NSMutableArray arrayWithArray:modelArray];
        } else {
            [self.dataArray addObjectsFromArray:modelArray];
        }
        if ([listArray count] < 10) {
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    }];
}

#pragma mark - subViews
- (void)setSubViews {
    self.dataArray = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 20)];
    [self.tableView registerClass:[DynamicListTableViewCell class] forCellReuseIdentifier:@"dynamicCell"];
    [self.view addSubview:self.tableView];
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestDynamicIsRefresh:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestDynamicIsRefresh:NO];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicListTableViewCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:@"dynamicCell"];
    DynamicListModel *model = self.dataArray[indexPath.row];
    if (self.anthorId == [YLUserDefault userDefault].t_id) {
        model.isMine = YES;
    }
    [dynamicCell setData:model];
    dynamicCell.delegate = self;
    return dynamicCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicListModel *model = self.dataArray[indexPath.row];
    return [DynamicListTableViewCell cellHeight:model];
    return 0;
}

#pragma mark - DynamicListTableViewCellDelegate
- (void)didSelectDynamicListTableViewCellWithBtn:(NSInteger)btnTag curActionModel:(DynamicListModel *)curActionModel {
    switch (btnTag) {
        case 101:
        {
            //全文
            curActionModel.isOpen = !curActionModel.isOpen;
            curActionModel.cellHeight = 0.0f;
            [self.tableView reloadData];
        }
            break;
        case 102:
        {
            //点赞
            if (curActionModel.isPraise) {
                [SVProgressHUD showInfoWithStatus:@"你已经赞过了～"];
                return;
            }
            [self postDataWithLove:curActionModel];
        }
            break;
        case 103:
        {
            //评论
            self.commentListVC = [[DynamicCommentListViewController alloc] init];
            self.commentListVC.dynamicId  = curActionModel.t_dynamicId;
            self.commentListVC.commentedUserId = curActionModel.t_id;
            self.commentListVC.commentNum = [NSString stringWithFormat:@"%ld",(long)curActionModel.t_commentCount];
            self.commentListVC.view.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
            [[UIApplication sharedApplication].keyWindow addSubview:self.commentListVC.view];
            [self addChildViewController:self.commentListVC];
        }
            break;
        case 104:
        {
            //更多
            [self presentAlertController];
        }
            break;
            
        default:
            break;
    }
}

- (void)lookPrivateFile:(DynamicFileModel *)model {
    [YLNetworkInterface postDynamicPay:[YLUserDefault userDefault].t_id fileId:model.t_id
    block:^(int code) {
        //0315
        if (code > 0) {
            model.isPrivate = NO;
            model.isConsume = YES;
            [self.tableView reloadData];
        }else if (code == -1){
            //余额不足
            [[YLInsufficientManager shareInstance] insufficientShow];
        }
    }];
}

- (void)updateVip {
    [YLPushManager pushVipWithEndTime:nil];
}

- (void)playVideo:(DynamicListModel *)handle {
    VideoPlayViewController *videoPlayVC = [[VideoPlayViewController alloc] init];
    videoPlayVC.godId = (int)handle.t_id;
    DynamicFileModel *fileModel = [handle.fileArrays firstObject];
    videoPlayVC.videoUrl = fileModel.t_file_url;
    videoPlayVC.coverImageUrl = fileModel.t_cover_img_url;
    videoPlayVC.videoId  = (int)fileModel.t_id;
    videoPlayVC.queryType = 1;
    [self.navigationController pushViewController:videoPlayVC animated:YES];
}

#pragma mark - func
- (void)postDataWithLove:(DynamicListModel *)model {
    [SVProgressHUD showWithStatus:@"点赞中..."];
    [YLNetworkInterface dynamicLove:[YLUserDefault userDefault].t_id dynamicId:model.t_dynamicId block:^(BOOL isSuccess) {
        if (isSuccess) {
            [SVProgressHUD showInfoWithStatus:@"点赞成功"];
            model.isPraise = YES;
            model.t_praiseCount ++;
            [self.tableView reloadData];
        }
    }];
}

- (void)presentAlertController {
    [LXTAlertView alertActionWithTitle:@"请选择" message:nil actionArr:@[@"举报"] actionHandle:^(int index) {
        [self pushReportVC];
    }];
}

- (void)pushReportVC {
    YLReportController *reportVC = [YLReportController new];
    reportVC.title = @"举报";
    reportVC.godId = (int)_anthorId;
    [self.navigationController pushViewController:reportVC animated:YES];
}




@end
