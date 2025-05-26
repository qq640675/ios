//
//  AwardListViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/12/22.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "AwardListViewController.h"
#import "RankTableViewCell.h"
#import <MJRefresh.h>

@interface AwardListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *rankTableView;
    int nPage;
    NSMutableArray *rankListArray;
    
    UILabel *titleLabel;
}

@end

@implementation AwardListViewController

#pragma mark - VC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    nPage = 1;
    rankListArray = [NSMutableArray array];
    
    [self setSubViews];
    [self getRankAwardData];
    [self requestRankListIsRefresh:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - net
- (void)getRankAwardData {
    [YLNetworkInterface getRankConfigWithBtnType:self.rankBtnType rankType:self.rankType success:^(NSDictionary *dataDic) {
        NSString *rankDesc = [NSString stringWithFormat:@"%@", dataDic[@"rankDesc"]];
        if (rankDesc.length > 0 && ![rankDesc containsString:@"null"]) {
            self->titleLabel.text = rankDesc;
        }
    }];
}
- (void)requestRankListIsRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        nPage = 1;
    } else {
        nPage ++;
    }
    [SVProgressHUD show];
    if (self.rankType == RankListTypeGoddess) {
        [self rankGoddessList];
    } else if (self.rankType == RankListTypeConsume) {
        [self rankConsumeList];
    } else if (self.rankType == RankListTypeInvited) {
        [self invitedList];
    } else if (self.rankType == RankListTypeGuard) {
        [self guardList];
    }
}

- (void)rankGoddessList {
    // 女神榜
    [YLNetworkInterface getGlamourList:[YLUserDefault userDefault].t_id queryType:self.rankBtnType block:^(NSMutableArray *listArray, rankingHandle *myHandle) {
        [SVProgressHUD dismiss];
        [self loadViewWithData:listArray];
    }];
}

- (void)rankConsumeList {
    // 土豪榜
    [YLNetworkInterface getConsumeList:[YLUserDefault userDefault].t_id queryType:self.rankBtnType block:^(NSMutableArray *listArray, rankingHandle *myHandle) {
        [SVProgressHUD dismiss];
        [self loadViewWithData:listArray];
        
    }];
}

- (void)invitedList {
    // 邀请列表
    [YLNetworkInterface getInvitedListWithQueryType:self.rankBtnType block:^(NSMutableArray *listArray, rankingHandle *myHandle) {
        [SVProgressHUD dismiss];
        [self loadViewWithData:listArray];
    }];
}

- (void)guardList {
    // 守护列表
    [YLNetworkInterface getUserGuardListWithQueryType:self.rankBtnType block:^(NSMutableArray *listArray, rankingHandle *myHandle) {
        [SVProgressHUD dismiss];
        [self loadViewWithData:listArray];
    }];
}

- (void)loadViewWithData:(NSArray *)dataArray {
    if (dataArray == nil) {
        return;
    }
    [rankTableView.mj_header endRefreshing];
    rankListArray = [NSMutableArray arrayWithArray:dataArray];
    [rankTableView reloadData];
}

#pragma mark - UITableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rankListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    rankingHandle *handle = rankListArray[indexPath.row];
    RankTableViewCell *rankCell = [tableView dequeueReusableCellWithIdentifier:@"rankCell"];
    rankCell.rankType = self.rankType;
    rankCell.rankHandle = handle;
    rankCell.rankNum = indexPath.row+1;
    [rankCell setRankButtonType:self.rankBtnType];
    return rankCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.rankType == RankListTypeInvited) return;
    rankingHandle *handle = rankListArray[indexPath.row];
    if (handle.t_role == 1) {
        [YLPushManager pushAnchorDetail:handle.t_id];
    } else {
        [YLPushManager pushFansDetail:handle.t_id];
    }
}

#pragma mark - func
- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)awardRuleButtonClick {
    NSDictionary *awardSetDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANKAWARDSETTING"];
    TextAlertView *alert = [[TextAlertView alloc] initWithTitle:@"奖励说明"];
    alert.textAlignment = NSTextAlignmentLeft;
    [alert setContentWithString:[NSString stringWithFormat:@"%@", awardSetDic[@"t_rank_award_rules"]]];
}

#pragma maek - subViews
- (void)setSubViews {
    /*
    UIImageView *bgImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    bgImageV.image = [UIImage imageNamed:@"awardListBG"];
    [self.view addSubview:bgImageV];
    
    UIButton *backBtn = [UIManager initWithButton:CGRectMake(0, SafeAreaTopHeight-44, 44, 44) text:@"" font:1 textColor:nil normalImg:@"AnthorDetail_back" highImg:nil selectedImg:nil];
    [backBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    titleLabel = [UIManager initWithLabel:CGRectMake(50, SafeAreaTopHeight-44, App_Frame_Width-100, 44) text:@"" font:16 textColor:UIColor.whiteColor];
    [self.view addSubview:titleLabel];
    
    UIImageView *tipImageV = [[UIImageView alloc] initWithFrame:CGRectMake(30, SafeAreaTopHeight+30, App_Frame_Width-60, 35)];
    tipImageV.image = [UIImage imageNamed:@"award_tipimg"];
    tipImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:tipImageV];
    if (self.rankBtnType == YLRankBtnTypeLastMonth) {
        tipImageV.image = [UIImage imageNamed:@"award_tipimg_month"];
    }
    
    UIButton *ruleBtn = [UIManager initWithButton:CGRectMake((App_Frame_Width-60)/2, SafeAreaTopHeight+80, 60, 20) text:@"奖励说明" font:11 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
    ruleBtn.backgroundColor = XZRGB(0xCAB6FF);
    ruleBtn.layer.masksToBounds = YES;
    ruleBtn.layer.cornerRadius = 10;
    [ruleBtn addTarget:self action:@selector(awardRuleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ruleBtn];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight+120, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight-100)];
    whiteView.backgroundColor = UIColor.whiteColor;
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 20;
    [self.view addSubview:whiteView];
    
    UILabel *label_1 = [UIManager initWithLabel:CGRectMake(0, 10, 45, 30) text:@"排行" font:15 textColor:XZRGB(0x333333)];
    [whiteView addSubview:label_1];
    
    NSString *text = @"主播";
    if (self.rankType == RankListTypeInvited) {
        text = @"用户";
    }
    UILabel *label_2 = [UIManager initWithLabel:CGRectMake(105, 10, 100, 30) text:@"主播" font:15 textColor:XZRGB(0x333333)];
    label_2.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:label_2];
    
    UILabel *label_3 = [UIManager initWithLabel:CGRectMake(App_Frame_Width-70, 10, 60, 30) text:@"领取状态" font:15 textColor:XZRGB(0x333333)];
    [whiteView addSubview:label_3];
    
    rankTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, App_Frame_Width, whiteView.height-60) style:UITableViewStylePlain];

    rankTableView.backgroundColor = [UIColor clearColor];
    rankTableView.tableFooterView = [UIView new];
    rankTableView.dataSource = self;
    rankTableView.delegate = self;
    rankTableView.rowHeight = 70;
    rankTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    rankTableView.showsVerticalScrollIndicator = NO;
    [rankTableView registerClass:[RankTableViewCell class] forCellReuseIdentifier:@"rankCell"];
    rankTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40+SafeAreaBottomHeight-49)];
    [whiteView addSubview:rankTableView];
    
    WEAKSELF;
    rankTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestRankListIsRefresh:YES];
    }];
    */
}



@end
