//
//  RankListViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/5/21.
//  Copyright © 2020 zhou last. All rights reserved.
//

// vc
#import "RankListViewController.h"
#import "AwardListViewController.h"
// view
#import "RankHeaderView.h"
#import "rankDetailView.h"
#import "YLBasicView.h"
// other
#import "YLPushManager.h"
#import <MJRefresh.h>
#import "YLTapGesture.h"
#import "MysteriousView.h"


@interface RankListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    RankHeaderView *headerView;
    UITableView *rankTableView;
    int nPage;
    NSMutableArray *rankListArray;
    YLRankBtnType rankBtnType;
    BOOL isFirst;
    rankDetailView *detailView; //收益详情
    UIView *blackCoverView;
    
//    UIButton *awardBtn;
}

@end

@implementation RankListViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    isFirst = YES;
    rankBtnType = YLRankBtnTypeDay;
    nPage = 1;
    rankListArray = [NSMutableArray array];
    
    [self setSubViews];
    [self requestRankListIsRefresh:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - net
- (void)requestRankListIsRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        nPage = 1;
    } else {
        nPage ++;
    }
    if (isFirst) {
        [SVProgressHUD show];
    }
    isFirst = NO;
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
    [YLNetworkInterface getGlamourList:[YLUserDefault userDefault].t_id queryType:rankBtnType block:^(NSMutableArray *listArray, rankingHandle *myHandle) {
        [SVProgressHUD dismiss];
        [self loadViewWithData:listArray];
    }];
}

- (void)rankConsumeList {
    // 土豪榜
    [YLNetworkInterface getConsumeList:[YLUserDefault userDefault].t_id queryType:rankBtnType block:^(NSMutableArray *listArray, rankingHandle *myHandle) {
        [SVProgressHUD dismiss];
        [self loadViewWithData:listArray];
    }];
}

- (void)invitedList {
    // 邀请列表
    [YLNetworkInterface getInvitedListWithQueryType:rankBtnType block:^(NSMutableArray *listArray, rankingHandle *myHandle) {
        [SVProgressHUD dismiss];
        [self loadViewWithData:listArray];
    }];
} 

- (void)guardList {
    // 守护列表
    [YLNetworkInterface getUserGuardListWithQueryType:rankBtnType block:^(NSMutableArray *listArray, rankingHandle *myHandle) {
        [SVProgressHUD dismiss];
        [self loadViewWithData:listArray];
    }];
}

- (void)loadViewWithData:(NSArray *)dataArray {
//    awardBtn.hidden = YES;
//    NSDictionary *awardSetDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANKAWARDSETTING"];
//    if (awardSetDic) {
//        int glamour_week = [[NSString stringWithFormat:@"%@", awardSetDic[@"glamour_week"]] intValue];
//        int glamour_month = [[NSString stringWithFormat:@"%@", awardSetDic[@"glamour_month"]] intValue];
//        int invite_week = [[NSString stringWithFormat:@"%@", awardSetDic[@"invite_week"]] intValue];
//        int inviter_month = [[NSString stringWithFormat:@"%@", awardSetDic[@"inviter_month"]] intValue];
//
//        int wealth_week = [[NSString stringWithFormat:@"%@", awardSetDic[@"wealth_week"]] intValue];
//        int wealth_month = [[NSString stringWithFormat:@"%@", awardSetDic[@"wealth_month"]] intValue];
//        int guard_week = [[NSString stringWithFormat:@"%@", awardSetDic[@"guard_week"]] intValue];
//        int guard_month = [[NSString stringWithFormat:@"%@", awardSetDic[@"guard_month"]] intValue];
//
//        if (self.rankType == RankListTypeGoddess) {
//            if (rankBtnType == YLRankBtnTypeWeek && glamour_week) {
//                awardBtn.hidden = NO;
//                [awardBtn setImage:[UIImage imageNamed:@"last_week_btn"] forState:0];
//            } else if (rankBtnType == YLRankBtnTypeMonth && glamour_month) {
//                awardBtn.hidden = NO;
//                [awardBtn setImage:[UIImage imageNamed:@"last_month_btn"] forState:0];
//            }
//        } else if (self.rankType == RankListTypeInvited) {
//            if (rankBtnType == YLRankBtnTypeWeek && invite_week) {
//                awardBtn.hidden = NO;
//                [awardBtn setImage:[UIImage imageNamed:@"last_week_btn"] forState:0];
//            } else if (rankBtnType == YLRankBtnTypeMonth && inviter_month) {
//                awardBtn.hidden = NO;
//                [awardBtn setImage:[UIImage imageNamed:@"last_month_btn"] forState:0];
//            }
//        } else if (self.rankType == RankListTypeConsume) {
//            if (rankBtnType == YLRankBtnTypeWeek && wealth_week) {
//                awardBtn.hidden = NO;
//                [awardBtn setImage:[UIImage imageNamed:@"last_week_btn"] forState:0];
//            } else if (rankBtnType == YLRankBtnTypeMonth && wealth_month) {
//                awardBtn.hidden = NO;
//                [awardBtn setImage:[UIImage imageNamed:@"last_month_btn"] forState:0];
//            }
//        } else if (self.rankType == RankListTypeGuard) {
//            if (rankBtnType == YLRankBtnTypeWeek && guard_week) {
//                awardBtn.hidden = NO;
//                [awardBtn setImage:[UIImage imageNamed:@"last_week_btn"] forState:0];
//            } else if (rankBtnType == YLRankBtnTypeMonth && guard_month) {
//                awardBtn.hidden = NO;
//                [awardBtn setImage:[UIImage imageNamed:@"last_month_btn"] forState:0];
//            }
//        }
//    }
//
//    if (dataArray == nil) return;

    [headerView setHeaderData:dataArray];
    [rankTableView.mj_header endRefreshing];
    rankListArray = [NSMutableArray arrayWithArray:dataArray];
    [rankTableView reloadData];
}

//- (void)getAnchorProfitDetail:(rankingHandle *)handle {
//    [YLNetworkInterface getAnchorProfitDetail:handle.t_id queryType:self->rankBtnType block:^(NSMutableArray *listArray) {
//        if (listArray.count != 0) {
//            [self reloadDetailView:listArray];
//        }
//    }];
//}
//
//- (void)reloadDetailView:(NSMutableArray *)listArray {
//    //1.文字聊天 2.视频聊天 3.私密照片 4.私密照片 5.查看手机 6.查看微信
//    for (rankingHandle *handle in listArray) {
//        switch (handle.t_change_category) {
//            case 1:
//            { //文字聊天
//                detailView.textchatLabel.text = [NSString stringWithFormat:@"%lld",handle.gold];
//                break;
//            }
//            case 2:
//            { //视频通话
//                detailView.videoChatLabel.text = [NSString stringWithFormat:@"%lld",handle.gold];
//                break;
//            }
//            case 3:
//            { //私密照片
//                detailView.privatePictureLabel.text = [NSString stringWithFormat:@"%lld",handle.gold];
//                break;
//            }
//            case 4:
//            { //私密视频
//                detailView.privateVideoLabel.text = [NSString stringWithFormat:@"%lld",handle.gold];
//                break;
//            }
//            case 5:
//            { //手机号
//                detailView.phoneNumberLabel.text = [NSString stringWithFormat:@"%lld",handle.gold];
//                break;
//            }
//            case 6:
//            { //手机号
//                detailView.wechatNumberLabel.text = [NSString stringWithFormat:@"%lld",handle.gold];
//                break;
//            }
//            default:
//                break;
//        }
//    }
//}

#pragma mark - UITableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (rankListArray.count > 3) {
        return rankListArray.count-3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    rankingHandle *handle = rankListArray[indexPath.row+3];
    RankTableViewCell *rankCell = [tableView dequeueReusableCellWithIdentifier:@"rankCell"];
    [rankCell setRankButtonType:rankBtnType];
    rankCell.rankType = self.rankType;
    rankCell.rankHandle = handle;
    rankCell.rankNum = indexPath.row+4;
    
//    WEAKSELF;
//    rankCell.moreButtonClickBlock = ^{
//        [weakSelf createProfitDetail:handle];
//    };
    return rankCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.rankType == RankListTypeInvited) return;
    rankingHandle *handle = rankListArray[indexPath.row + 3];
    if (handle.t_rank_switch) {
        MysteriousView *view = [[MysteriousView alloc] init];
        [view show];
        return;
    }
    if (handle.t_role == 1) {
        [YLPushManager pushAnchorDetail:handle.t_id];
    } else {
        [YLPushManager pushFansDetail:handle.t_id];
    }
}

#pragma mark - func
//- (void)createProfitDetail:(rankingHandle *)handle {
//    if (detailView) {
//        [detailView removeFromSuperview];
//    }
//
//    //遮罩层(可以封装)
//    blackCoverView = [YLBasicView blackView];
//    [YLTapGesture tapGestureTarget:self sel:@selector(removeDetailView) view:blackCoverView];
//    [self.view.window addSubview:blackCoverView];
//
//    NSArray *vipxibArray = [[NSBundle mainBundle]loadNibNamed:@"rankDetailView" owner:nil options:nil];
//    detailView = vipxibArray[0];
//    [self.view.window addSubview:detailView];
//
//    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
//        make.top.mas_equalTo(APP_Frame_Height/2. - 145.);
//        make.width.mas_equalTo(App_Frame_Width - 30);
//        make.height.mas_equalTo(290);
//    }];
//    [detailView cordius];
//    //头像
//    if (![NSString isNullOrEmpty:handle.t_handImg]) {
//        [detailView.headImgView sd_setImageWithURL:[NSURL URLWithString:handle.t_handImg] placeholderImage:IChatUImage(@"default")];
//    }
//    //昵称
//    if (![NSString isNullOrEmpty:handle.t_nickName]) {
//        detailView.nicknameLabel.text = handle.t_nickName;
//    }else{
//        detailView.nicknameLabel.text = @"昵称:无";
//    }
//
//    //新游山号
//    detailView.ylnumberLabel.text = [NSString stringWithFormat:@"ID:%d",handle.t_idcard];
//
//    //获取主播收益明细数据
//    [self getAnchorProfitDetail:handle];
//}
//
//- (void)removeDetailView {
//    [detailView removeFromSuperview];
//    [blackCoverView removeFromSuperview];
//}

//- (void)awardButtonClick {
//    AwardListViewController *awardVC = [[AwardListViewController alloc] init];
//    awardVC.rankType = _rankType;
//    if (rankBtnType == YLRankBtnTypeWeek) {
//        awardVC.rankBtnType = YLRankBtnTypeLastWeek;
//    } else if (rankBtnType == YLRankBtnTypeMonth) {
//        awardVC.rankBtnType = YLRankBtnTypeLastMonth;
//    }
//    [self.navigationController pushViewController:awardVC animated:YES];
//}

#pragma mark - setSubViews
- (void)setSubViews {
    WEAKSELF;
    headerView = [[RankHeaderView alloc] initWithType:self.rankType];
    headerView.headerTypeButtonClick = ^(int index) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf->rankBtnType = index;
        [strongSelf->rankTableView.mj_header beginRefreshing];
    };
//    headerView.coinButtonClickBlock = ^(rankingHandle * _Nonnull rankHandle) {
//        [weakSelf createProfitDetail:rankHandle];
//    };
    [self.view addSubview:headerView];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.height-20, App_Frame_Width, APP_Frame_Height-headerView.height+40)];
    whiteView.backgroundColor = UIColor.whiteColor;
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 20;
    [self.view addSubview:whiteView];
    
    rankTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-headerView.height-SafeAreaBottomHeight+18) style:UITableViewStylePlain];
    if (self.isShowBack == YES) {
        rankTableView.height = APP_Frame_Height-headerView.height+18;
    }
    rankTableView.backgroundColor = [UIColor clearColor];
    rankTableView.tableFooterView = [UIView new];
    rankTableView.dataSource = self;
    rankTableView.delegate = self;
    rankTableView.rowHeight = 70;
    rankTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    rankTableView.showsVerticalScrollIndicator = NO;
    [rankTableView registerClass:[RankTableViewCell class] forCellReuseIdentifier:@"rankCell"];
    rankTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    [whiteView addSubview:rankTableView];
    
    rankTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestRankListIsRefresh:YES];
    }];
    
//    awardBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-85, whiteView.height-250, 80, 80) text:@"" font:1 textColor:nil normalImg:@"last_week_btn" highImg:nil selectedImg:nil];
//    awardBtn.hidden = YES;
//    [awardBtn addTarget:self action:@selector(awardButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [whiteView addSubview:awardBtn];
   
}



@end
