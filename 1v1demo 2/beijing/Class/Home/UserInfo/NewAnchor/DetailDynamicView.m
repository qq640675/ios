//
//  DetailDynamicView.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/10.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "DetailDynamicView.h"
#import "YLNetworkInterface.h"
#import "DynamicCommentListViewController.h"
#import "LXTAlertView.h"
#import "YLInsufficientManager.h"
#import "VideoPlayViewController.h"

@interface DetailDynamicView()
{
    UIViewController *curVC;
}
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) DynamicCommentListViewController  *commentListVC;
@end

@implementation DetailDynamicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViewsWithFrame:frame];
        self.backgroundColor = UIColor.whiteColor;
        curVC = [SLHelper getCurrentVC];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

#pragma mark - subViews
- (void)setSubViewsWithFrame:(CGRect)frame {
    self.dataArray = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollsToTop = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 20)];
    [self.tableView registerClass:[DynamicListTableViewCell class] forCellReuseIdentifier:@"dynamicCell"];
    [self addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicListTableViewCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:@"dynamicCell"];
    DynamicListModel *model = self.dataArray[indexPath.row];
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
            [curVC addChildViewController:self.commentListVC];
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
    [curVC.navigationController pushViewController:videoPlayVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback?:self.scrollCallback(scrollView);
}

#pragma mark - JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listViewLoadDataIfNeeded {
    [self.tableView reloadData];
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
    [YLPushManager pushReportWithId:_anthorId];
}

@end
