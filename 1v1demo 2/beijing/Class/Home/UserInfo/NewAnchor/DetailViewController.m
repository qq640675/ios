//
//  DetailViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/4.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "DetailViewController.h"
#import "GuardView.h"
#import "DetailHeaderView.h"
#import "NewDetailWDLWTableViewCell.h"
#import "YLGiftCabinetController.h"
#import "AnthorDetailNavigationBarView.h"
#import <MJRefresh.h>
#import "JsonToModelTool.h"
#import "ShareManager.h"
#import "NewAnchorDetailBottomView.h"
#import "ChatLiveManager.h"
#import "NewDetailTDZLTableViewCell.h"
#import "NewDetailTDSHTableViewCell.h"
#import "NewDetailGRDTTableViewCell.h"
#import "AnchorDynamicViewController.h"
#import "GuardRankViewController.h"
#import "NewDetailYHYXTableViewCell.h"
#import "UserCommentViewController.h"

@interface DetailViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    DetailHeaderView *headerView;
    NSArray *giftList;
    NSArray *dynamicList;
    NSArray *guardList;
    NSArray *commentList;
}
@property (nonatomic, strong) AnthorDetailNavigationBarView *anthorDetailNavigationBarView;
@property (nonatomic, strong) godnessInfoHandle *infoHandle;

@end

@implementation DetailViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setSubViews];
    [self requestAnchorDetailData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - subViews
- (void)setSubViews {
    [self setTableView];
    [self setNav];
    [self setBottomView];
}

- (void)setTableView {
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-SafeAreaBottomHeight+49-60) style:UITableViewStylePlain];
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    self.detailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 30)];
    self.detailTableView.showsVerticalScrollIndicator = NO;
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTableView.bounces = NO;
    [self.detailTableView registerClass:[NewDetailTDZLTableViewCell class] forCellReuseIdentifier:@"tdzlCell"];
    [self.detailTableView registerClass:[NewDetailWDLWTableViewCell class] forCellReuseIdentifier:@"wdlwCell"];
    [self.detailTableView registerClass:[NewDetailTDSHTableViewCell class] forCellReuseIdentifier:@"tdshCell"];
    [self.detailTableView registerClass:[NewDetailGRDTTableViewCell class] forCellReuseIdentifier:@"grdtCell"];
    [self.detailTableView registerClass:[NewDetailYHYXTableViewCell class] forCellReuseIdentifier:@"yhyxCell"];
    [self.view addSubview:self.detailTableView];
    if (@available(iOS 11.0, *)) {
        self.detailTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        if (@available(iOS 13.0, *)) {
            self.detailTableView.automaticallyAdjustsScrollIndicatorInsets = NO;
        } else {
            // Fallback on earlier versions
        }
    }
    
    headerView = [[DetailHeaderView alloc] init];
    WEAKSELF;
    headerView.followButtonClickBlock = ^(bool isFollow) {
        weakSelf.infoHandle.isFollow = isFollow;
    };
    headerView.guardButtonClickBlock = ^{
        [weakSelf guardButtonClick];
    };
    self.detailTableView.tableHeaderView = headerView;
}

- (void)setNav {
    _anthorDetailNavigationBarView = [[AnthorDetailNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, SafeAreaTopHeight)];
    _anthorDetailNavigationBarView.nickNameLb.text = @"个人资料";
    [_anthorDetailNavigationBarView.moreBtn addTarget:self action:@selector(clickedMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_anthorDetailNavigationBarView];
}

- (void)setBottomView {
    WEAKSELF;
    CGFloat height = SafeAreaBottomHeight-49+60;
    NewAnchorDetailBottomView *bottomView = [[NewAnchorDetailBottomView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height-height, App_Frame_Width, height)];
    bottomView.bottomViewButtonClick = ^(NSInteger index) {
        if (index == 0) {
            //私信
            [weakSelf chat];
        } else if (index == 1) {
            //礼物
            [weakSelf sendGift];
        } else if (index == 2) {
            //视频
            [weakSelf videoChat];
        }
    };
    [self.view addSubview:bottomView];
}

#pragma mark - net
- (void)requestAnchorDetailData {
    [self requestUserInfo];
    [self requestDynamic];
    [self getGiftList];
    [self requestGuardList];
    [self getComment];
}

- (void)requestUserInfo {
    [YLNetworkInterface getGodnessUserData:[YLUserDefault userDefault].t_id coverUserId:(int)_anthorId block:^(godnessInfoHandle *handle) {
        self.infoHandle = handle;
        self->headerView.infoHandle = handle;
        self.anthorDetailNavigationBarView.nickNameLb.text = handle.t_nickName;
        
        NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:3 inSection:0];
        [self.detailTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath0, indexPath3, nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)requestDynamic {
    [YLNetworkInterface getPriDynamicList:[YLUserDefault userDefault].t_id coverUserId:self.anthorId page:1 reqType:0 block:^(NSMutableArray *listArray) {
        
        BOOL isSelf = NO;
        if (self.anthorId == [YLUserDefault userDefault].t_id) {
            isSelf = YES;
        }
        self->dynamicList = [JsonToModelTool DetailDynamicListJsonToModelWithJsonArray:listArray isMine:isSelf];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.detailTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath2, nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)requestGuardList {
    [YLNetworkInterface getUserGuardGiftListWithId:self.anthorId Success:^(NSArray *dataArr) {
        self->guardList = dataArr;
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.detailTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1, nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)getComment {
    [YLNetworkInterface getNewEvaluationListWithId:self.anthorId Success:^(NSArray *dataArr) {
        self->commentList = dataArr;
        NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:3 inSection:0];
        [self.detailTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath3, nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)getGiftList {
    [YLNetworkInterface getIntimateAndGift:(int)_anthorId block:^(NSArray *intimates, NSArray *gifts) {
        self->giftList = gifts;
        NSIndexPath *indexPath4 = [NSIndexPath indexPathForRow:4 inSection:0];
        [self.detailTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath4, nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - guard
- (void)guardButtonClick {
    if (_infoHandle.t_sex == [YLUserDefault userDefault].t_sex) {
        [SVProgressHUD showInfoWithStatus:@"暂未开放同性用户交流"];
        return;
    }
    
    [YLNetworkInterface getGuardWithAnchorId:self.anthorId Success:^(NSDictionary *dataDic) {
        GuardView *alertV = [[GuardView alloc] initWithId:self.anthorId];
        [alertV showWithDataDic:dataDic];
        alertV.sendGuardSuccess = ^{
            [self requestGuardList];
        };
    }];
}

#pragma mark - bottom button click
- (void)chat {
    [YLPushManager pushChatViewController:_anthorId otherSex:_infoHandle.t_sex];
}

- (void)sendGift {
    if (_infoHandle.t_sex == [YLUserDefault userDefault].t_sex) {
        [SVProgressHUD showInfoWithStatus:@"暂未开放同性用户交流"];
        return;
    }
    [[MansionSendGiftView shareView] showWithUserId:self.anthorId isPlayGif:NO];
}

- (void)videoChat {
    if (_infoHandle.t_sex == [YLUserDefault userDefault].t_sex) {
        [SVProgressHUD showInfoWithStatus:@"暂未开放同性用户交流"];
        return;
    }
    
    [[ChatLiveManager shareInstance] getVideoChatAutographWithOtherId:(int)_anthorId type:1 fail:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NewDetailTDZLTableViewCell *tdzlCell = [tableView dequeueReusableCellWithIdentifier:@"tdzlCell"];
        tdzlCell.infoHandle = _infoHandle;
        return tdzlCell;
    } else if (indexPath.row == 1) {
        NewDetailTDSHTableViewCell *tdshCell = [tableView dequeueReusableCellWithIdentifier:@"tdshCell"];
        [tdshCell setContentWithArr:guardList];
        return tdshCell;
    } else if (indexPath.row == 2) {
        NewDetailGRDTTableViewCell *grdtCell = [tableView dequeueReusableCellWithIdentifier:@"grdtCell"];
        [grdtCell setDynamicData:dynamicList];
        return grdtCell;
    }  else if (indexPath.row == 3) {
        NewDetailYHYXTableViewCell *yhyxCell = [tableView dequeueReusableCellWithIdentifier:@"yhyxCell"];
        [yhyxCell setStarNumber:_infoHandle.t_score];
        [yhyxCell setDataWithArray:commentList];
        return yhyxCell;
    }  else if (indexPath.row == 4) {
        NewDetailWDLWTableViewCell *wdlwCell = [tableView dequeueReusableCellWithIdentifier:@"wdlwCell"];
        wdlwCell.cellTitle = @"TA的礼物";
        wdlwCell.giftArray = giftList;
        return wdlwCell;
    }

    UITableViewCell *cell = [UITableViewCell new];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 160;
    } else if (indexPath.row == 1) {
        return 120;
    } else if (indexPath.row == 2) {
        return 140;
    } else if (indexPath.row == 3) {
        return 120;
    } else if (indexPath.row == 4) {
        return 90;
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        UIViewController *nowVC = [SLHelper getCurrentVC];
        GuardRankViewController *rankVC = [[GuardRankViewController alloc] init];
        rankVC.anchorId = self.anthorId;
        [nowVC.navigationController pushViewController:rankVC animated:YES];
    } else if (indexPath.row == 2) {
        UIViewController *nowVC = [SLHelper getCurrentVC];
        AnchorDynamicViewController *dynamicVC = [[AnchorDynamicViewController alloc] init];
        dynamicVC.anthorId = self.anthorId;
        [nowVC.navigationController pushViewController:dynamicVC animated:YES];
    } else if (indexPath.row == 3) {
        UIViewController *nowVC = [SLHelper getCurrentVC];
        UserCommentViewController *vc = [[UserCommentViewController alloc] init];
        vc.anthorId = self.anthorId;
        [nowVC.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 4) {
        UIViewController *nowVC = [SLHelper getCurrentVC];
        YLGiftCabinetController *giftCabinetVC = [YLGiftCabinetController new];
        giftCabinetVC.title = @"礼物柜";
        giftCabinetVC.godId = (int)_anthorId;
        [nowVC.navigationController pushViewController:giftCabinetVC animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 50) {
        self.detailTableView.contentInset = UIEdgeInsetsMake(SafeAreaTopHeight, 0, 0, 0);
    } else {
        self.detailTableView.contentInset = UIEdgeInsetsZero;
    }
    if (offsetY > 0) {
        CGFloat alpha = offsetY/(App_Frame_Width*0.9-SafeAreaTopHeight);

        _anthorDetailNavigationBarView.bgView.alpha = alpha;
        [_anthorDetailNavigationBarView.moreBtn setImage:IChatUImage(@"AnthorDetail_more_black") forState:UIControlStateNormal];
        [_anthorDetailNavigationBarView.backBtn setImage:IChatUImage(@"AnthorDetail_back_black") forState:UIControlStateNormal];
    } else {
        _anthorDetailNavigationBarView.bgView.alpha = 0;
        [_anthorDetailNavigationBarView.moreBtn setImage:IChatUImage(@"AnthorDetail_more") forState:UIControlStateNormal];
        [_anthorDetailNavigationBarView.backBtn setImage:IChatUImage(@"AnthorDetail_back") forState:UIControlStateNormal];
    }
}

#pragma mark - func
- (void)clickedMoreBtn {
    [LXTAlertView alertActionWithTitle:nil message:nil actionArr:@[@"分享", @"举报", @"加入黑名单"] actionHandle:^(int index) {
        if (index == 0) {
            [self share];
        } if (index == 1) {
            [self report];
        } else if (index == 2) {
            [self blackUser];
        }
    }];
}

- (void)share {
    NSString *imageUrl = nil;
    if (_infoHandle.lunbotu.count > 0) {
        NSDictionary *dic = [_infoHandle.lunbotu firstObject];
        imageUrl = dic[@"t_img_url"];
    }
    
    id obj = nil;
    if (imageUrl.length > 0) {
        obj = imageUrl;
    } else {
        obj = [UIImage imageNamed:@"logo60"];
    }
    
    [[ShareManager shareInstance] shareWithTitle:[NSString stringWithFormat:@"您的好友[%@]邀请您——视频私聊",_infoHandle.t_nickName] content:@"请注意查收！" image:obj url:nil];
}

- (void)report {
    [YLPushManager pushReportWithId:self.anthorId];
}

- (void)blackUser {
    // 拉黑用户
    [YLNetworkInterface addBlackUserWithId:[NSString stringWithFormat:@"%ld", (long)self.anthorId] success:^{
        [SVProgressHUD showSuccessWithStatus:@"操作成功"];
    }];
}




@end
