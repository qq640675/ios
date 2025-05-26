//
//  YLUnionDetailController.m
//  beijing
//
//  Created by zhou last on 2018/9/15.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLUnionDetailController.h"
#import "unionDetailCell.h"
#import "YLNetworkInterface.h"
#import <UIImageView+WebCache.h>
#import "YLUserDefault.h"
#import "NSString+Util.h"
#import "YLBasicView.h"
#import <MJRefresh.h>
#import <SVProgressHUD.h>

@interface YLUnionDetailController ()
{
    NSMutableArray *detailListArray; //公会贡献列表数组
    int detailPage; //页码
}

//主播头像
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

//主播昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
//贡献值
@property (weak, nonatomic) IBOutlet UILabel *contributeLabel;
//今日贡献值
@property (weak, nonatomic) IBOutlet UILabel *todayContributeLabel;

@property (weak, nonatomic) IBOutlet UITableView *unionDetailTableView;

@end

@implementation YLUnionDetailController

- (instancetype)init
{
    if (self == [super init]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self getAnthorTotalData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self detailCustomUI];
}

#pragma mark ----- CustomUI
- (void)detailCustomUI
{
    [self.headImgView setClipsToBounds:YES];
    [self.headImgView.layer setCornerRadius:25.];
    
    self.unionDetailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        self->detailPage = 1;
        [self getContributionDetail:self->detailPage];
        
    }];
    [self.unionDetailTableView.mj_header beginRefreshing];
    self.unionDetailTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDetailData)];
}

#pragma mark ---- 获取贡献列表数据
- (void)getAnthorTotalData
{
    dispatch_queue_t queue = dispatch_queue_create(" 获取贡献列表数据", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        [YLNetworkInterface getAnthorTotal:[YLUserDefault userDefault].t_id anchorId:self.anchorId block:^(anchorAddGuildHandle *handle) {
            [self detailAssignment:handle];
        }];
    });
}

#pragma mark ---- 公会主播贡献明细列表
- (void)getContributionDetail:(int)page
{
    dispatch_queue_t queue = dispatch_queue_create("公会主播贡献明细列表", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(queue, ^{
        [YLNetworkInterface getContributionDetail:[YLUserDefault userDefault].t_id anchorId:self.anchorId page:page block:^(NSMutableArray *listArray) {
            if (self->detailPage == 1) {
                self->detailListArray = [NSMutableArray array];
                
                self->detailListArray = listArray;
            }else{
                for (anchorAddGuildHandle *handle in listArray) {
                    [self->detailListArray addObject:handle];
                }
            }
            
            if (listArray.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"没有数据"];
            }
            
            [self.unionDetailTableView reloadData];
            [self.unionDetailTableView.mj_header endRefreshing];
            [self.unionDetailTableView.mj_footer endRefreshing];
        }];
    });
}

#pragma mark ---- 加载更多数据
- (void)loadMoreDetailData
{
    if (detailListArray.count != 0) {
        anchorAddGuildHandle *handle = detailListArray[0];
        if (handle.pageCount > detailPage) {
            detailPage ++;
            [self getContributionDetail:detailPage];
        }else{
            if (self.unionDetailTableView.mj_footer.isRefreshing) {
                [self.unionDetailTableView.mj_footer endRefreshing];
                [self.unionDetailTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }else{
        if (self.unionDetailTableView.mj_footer.isRefreshing) {
            [self.unionDetailTableView.mj_footer endRefreshing];
            [self.unionDetailTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

#pragma mark ---- 赋值
- (void)detailAssignment:(anchorAddGuildHandle *)handle
{
    //头像
    if (![NSString isNullOrEmpty:handle.t_handImg]) {
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:handle.t_handImg] placeholderImage:[UIImage imageNamed:@"default"]];
    }else{
        self.headImgView.image = [UIImage imageNamed:@"default"];
    }
    self.headImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headImgView setClipsToBounds:YES];
    
    //昵称
    if (![NSString isNullOrEmpty:handle.t_nickName]) {
        self.nickNameLabel.text = handle.t_nickName;
    }
    
    //贡献值
    self.contributeLabel.text = [NSString stringWithFormat:@"贡献值: %d 金币",handle.t_devote_value];
    //今日贡献值
    self.todayContributeLabel.text = [NSString stringWithFormat:@"今日贡献值: %d 金币",handle.toDay];
}

#pragma mark ---- tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return detailListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    unionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"unionDetailCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"unionDetailCell" owner:nil options:nil] firstObject];
    }else{
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    anchorAddGuildHandle *handle = detailListArray[indexPath.row];
    //时间
    cell.dateLabel.text = handle.t_change_time;
    //金币
    cell.coinsLabel.text = [NSString stringWithFormat:@"%d 金币",handle.totalGold];
    
    return cell;
}





@end
