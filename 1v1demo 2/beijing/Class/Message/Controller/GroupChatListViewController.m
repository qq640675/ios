//
//  GroupChatListViewController.m
//  beijing
//
//  Created by 黎 涛 on 2021/6/2.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "GroupChatListViewController.h"
#import <MJRefresh.h>
#import "MessageListModel.h"
#import "MessageListTableViewCell.h"
#import "GroupChatViewController.h"

@interface GroupChatListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *groupTable;
    NSMutableArray *conversations;
}

@end

@implementation GroupChatListViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"群消息";
    conversations = [NSMutableArray array];
    [self setSubViews];
    [self addNot];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if ([[TIMManager sharedInstance] getLoginStatus] != 1) {
        [SLHelper TIMLoginSuccess:^{
            [self getAllGroups];
        } fail:nil];
    } else {
        [self getAllGroups];
    }
}

#pragma mark - not
- (void)addNot {
    //收到新消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllGroups) name:@"receive_msg_notification" object:nil];
}

#pragma mark - get conversations
- (void)getAllGroups {
    [groupTable.mj_header endRefreshing];
    
    [[TIMGroupManager sharedInstance] getGroupList:^(NSArray *groupList) {
        if (groupList.count == 0) return;
            
        [self getGroupConversationsWithGroupList:groupList];
    } fail:^(int code, NSString *msg) {
        NSLog(@"___222_________code:%d, msg:%@", code, msg);
    }];
    
}

- (void)getGroupConversationsWithGroupList:(NSArray *)groupList {
    NSMutableArray *groupIds = [NSMutableArray array];
    for (TIMGroupInfo *groupInfo in groupList) {
        [groupIds addObject:groupInfo.group];
    }
    NSArray *list = [[TIMManager sharedInstance] getConversationList];
    if (list.count == 0) return;
        
    [conversations removeAllObjects];
    for (int i = 0; i < list.count; i ++) {
        TIMConversation *conversation = list[i];
        NSString *identifier = [NSString stringWithFormat:@"%@", [conversation getReceiver]];
        NSString *groupName = [conversation getGroupName];
        
        if (![groupIds containsObject:identifier]) continue;
        
        if (conversation.getType != TIM_GROUP || [identifier containsString:@"null"]) {
            continue;
        } else {
            TIMGroupInfo *groupInfo = [[TIMGroupManager sharedInstance] queryGroupInfo:identifier];
            if (![groupInfo.groupType isEqualToString:@"Public"]) {
                [conversation setReadMessage:nil succ:nil fail:nil];//标记已读
                continue;
            }
            MessageListModel *model = [[MessageListModel alloc] init];
            model.isTextMessage = YES;
            model.dataModel = [[MessageListDataModel alloc] initWithConversation:conversation];
            model.isGroup = YES;
            model.dataModel.nickName = groupName;
            model.group = identifier;
            if (![conversations containsObject:model]) {
                [conversations addObject:model];
            }
        }
    }
    [groupTable reloadData];
}

#pragma mark - subViews
- (void)setSubViews {
    
    groupTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight) style:UITableViewStylePlain];
    groupTable.backgroundColor = [UIColor whiteColor];
    groupTable.tableHeaderView = [UIView new];
    groupTable.tableFooterView = [UIView new];
    groupTable.dataSource = self;
    groupTable.delegate = self;
    groupTable.showsVerticalScrollIndicator = NO;
    [groupTable registerClass:[MessageListTableViewCell class] forCellReuseIdentifier:@"groupCell"];
    groupTable.rowHeight = 70;
    [self.view addSubview:groupTable];
    
    WEAKSELF;
    groupTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getAllGroups];
    }];
    
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 40)];
    topV.backgroundColor = XZRGB(0xf6ebbc);
    [self.view addSubview:topV];
    
    UILabel *tipL = [UIManager initWithLabel:CGRectMake(8, 0, App_Frame_Width-16, topV.height) text:@"严禁发布涉政、涉稳、涉警、涉恐、涉枪、涉暴、涉赌、涉毒、涉黄、涉骗、涉未成年及一切广告内容。违者后果自负。" font:13 textColor:XZRGB(0xf74c31)];
    tipL.textAlignment = NSTextAlignmentLeft;
    tipL.numberOfLines = 2;
    tipL.adjustsFontSizeToFitWidth = YES;
    [topV addSubview:tipL];
    
    groupTable.tableHeaderView = topV;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"];
    [groupCell initWithData:conversations[indexPath.row]];
    return groupCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListModel *model = conversations[indexPath.row];
    GroupChatViewController *chatVC = [[GroupChatViewController alloc] init];
    chatVC.group = model.group;
    [self.navigationController pushViewController:chatVC animated:YES];
    model.dataModel.unReadMsgCount = 0;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
