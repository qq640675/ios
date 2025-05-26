//
//  MansionInviteAlertView.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/6.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MansionInviteAlertView.h"
#import "MansionInviteTableViewCell.h"
#import <MJRefresh.h>

@implementation MansionInviteAlertView

#pragma mark - init
- (instancetype)initWithType:(InvitiAlertType)type mansionid:(int)mansionId {
    self = [super init];
    if (self) {
        _inviteType = type;
        _mansionId = mansionId;
        _dataList = [NSMutableArray array];
        _isInvited = NO;
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        [self setSubViews];
        [self requestDataIsRefresh:YES];
    }
    return self;
}

- (instancetype)initWithType:(InvitiAlertType)type mansionRoomId:(int)roomid chatType:(int)chatType {
    self = [super init];
    if (self) {
        _inviteType = type;
        _mansionRoomId = roomid;
        _chatType = chatType;
        _dataList = [NSMutableArray array];
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        [self setSubViews];
        [self requestDataIsRefresh:YES];
    }
    return self;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

#pragma mark - subViews
- (void)setSubViews {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height-450, App_Frame_Width, 460)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 10;
    bgView.backgroundColor = UIColor.whiteColor;
    [self addSubview:bgView];
    
    UILabel *titleLabel = [UIManager initWithLabel:CGRectMake(40, 0, bgView.width-80, 40) text:@"邀请好友" font:18 textColor:XZRGB(0x333333)];
    [bgView addSubview:titleLabel];
    
    UIButton *closeBtn = [UIManager initWithButton:CGRectMake(bgView.width-40, 0, 40, 40) text:@"" font:1 textColor:nil normalImg:@"mansion_alert_close" highImg:nil selectedImg:nil];
    [closeBtn addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];
    
    
    UIView *searchBG = [[UIView alloc] initWithFrame:CGRectMake(15, 45, App_Frame_Width-30, 35)];
    searchBG.backgroundColor = XZRGB(0xf2f3f7);
    searchBG.layer.masksToBounds = YES;
    searchBG.layer.cornerRadius = 17.5;
    [bgView addSubview:searchBG];
    
    UIImageView *searchLogo = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 15, 15)];
    searchLogo.image = [UIImage imageNamed:@"Dynamic_search"];
    [searchBG addSubview:searchLogo];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, searchBG.width-60, 35)];
    self.searchTF.placeholder = @"请输入ID或昵称查找";
    self.searchTF.borderStyle = UITextBorderStyleNone;
    self.searchTF.backgroundColor = UIColor.clearColor;
    self.searchTF.font = [UIFont systemFontOfSize:15];
    self.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchTF.delegate = self;
    [searchBG addSubview:self.searchTF];
    
    self.tipLabel = [UIManager initWithLabel:CGRectMake(0, 95, bgView.width, 40) text:@"暂无主播可邀请，赶快去关注主播吧~" font:17 textColor:XZRGB(0x333333)];
    self.tipLabel.hidden = YES;
    [bgView addSubview:self.tipLabel];
    
    self.inviteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, App_Frame_Width, bgView.height-85) style:UITableViewStylePlain];
    self.inviteTableView.backgroundColor = [UIColor whiteColor];
    self.inviteTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    self.inviteTableView.dataSource = self;
    self.inviteTableView.rowHeight = 65;
    self.inviteTableView.showsVerticalScrollIndicator = NO;
    [self.inviteTableView registerClass:[MansionInviteTableViewCell class] forCellReuseIdentifier:@"inviteCell"];
    [bgView addSubview:self.inviteTableView];
    
    WEAKSELF;
//    self.inviteTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf requestDataIsRefresh:YES];
//    }];
    
    self.inviteTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestDataIsRefresh:NO];
    }];
    
    
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-bgView.height)];
    tapView.backgroundColor = UIColor.clearColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeButtonClick)];
    [tapView addGestureRecognizer:tap];
    [self addSubview:tapView];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if (textField.text.length == 0) {
//        [SVProgressHUD showInfoWithStatus:@"搜索条件不能为空"];
//        return NO;
//    }
    [self endEditing:YES];
    [self requestInviteJoinMansionIsRefresh:YES];
    return YES;
}

#pragma mark - net
- (void)requestDataIsRefresh:(BOOL)isRefresh {
    [self requestInviteJoinMansionIsRefresh:isRefresh];
}

- (void)requestInviteJoinMansionIsRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        _page = 1;
    } else {
        _page ++;
    }
    NSString *searchKey = @"";
    if (self.searchTF.text > 0) {
        searchKey = self.searchTF.text;
    }
    [YLNetworkInterface getMansionHouseFollowListWithPage:_page mansionId:_mansionId searchKey:searchKey mansionRoomId:_mansionRoomId type:_inviteType success:^(NSArray *dataArray) {
        [SVProgressHUD dismiss];
        [self.inviteTableView.mj_header endRefreshing];
        [self.inviteTableView.mj_footer endRefreshing];
        if (dataArray == nil) {
            self.page --;
            return ;
        }
        if ([dataArray count] < 10) {
            self.inviteTableView.mj_footer.state = MJRefreshStateNoMoreData;
            [self.inviteTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.page == 1) {
            self.dataList = [NSMutableArray arrayWithArray:dataArray];
        } else {
            [self.dataList addObjectsFromArray:dataArray];
        }
        
        if (self.inviteType == InvitiAlertTypeJoinMansion && self.dataList.count == 0) {
            self.tipLabel.hidden = NO;
        } else {
            self.tipLabel.hidden = YES;
        }
        [self.inviteTableView reloadData];
    } fail:^{
        [SVProgressHUD dismiss];
        [self.inviteTableView.mj_header endRefreshing];
        [self.inviteTableView.mj_footer endRefreshing];
    }];
}

//- (void)requestInviteJoinRoomIsRefresh:(BOOL)isRefresh {
//    
//}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MansionInviteTableViewCell *inviteCell = [tableView dequeueReusableCellWithIdentifier:@"inviteCell"];
    inviteCell.myFollowModel = _dataList[indexPath.row];
    WEAKSELF;
    inviteCell.inviteButtonClickBlock = ^{
        [weakSelf inviteButtonClick:indexPath.row];
    };
    return inviteCell;
}

#pragma mark - func
- (void)closeButtonClick {
    if ([self.searchTF isFirstResponder]) {
        [self endEditing:YES];
        return;
    }
    [self removeFromSuperview];
    if (_inviteType == InvitiAlertTypeJoinMansion && self.removeFromSuperViewBlock && self.isInvited == YES) {
        self.removeFromSuperViewBlock();
    }
}

- (void)inviteButtonClick:(NSInteger)index {
    if (_inviteType == InvitiAlertTypeJoinMansion) {
        // 邀请加入府邸
        [self inviteJoinMansion:index];
    } else if (_inviteType == InvitiAlertTypeJoinRoom) {
        // 邀请进入房间
        [self inviteJoinRoom:index];
    }
}

- (void)inviteJoinMansion:(NSInteger)index {
    MansionMyFollowListModel *model = self.dataList[index];
    [YLNetworkInterface inviteMansionHouseAnchorWithMansionId:_mansionId anchorId:model.t_id];
    self.isInvited = YES;
}

- (void)inviteJoinRoom:(NSInteger)index {
    MansionMyFollowListModel *model = self.dataList[index];
    [YLNetworkInterface launchMansionVideoChatWithRoomId:_mansionRoomId chatType:_chatType anchorId:model.t_id];
}


@end
