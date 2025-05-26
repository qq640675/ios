//
//  YLMessageController.m
//  beijing
//
//  Created by zhou last on 2018/6/15.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLMessageController.h"
#import "messageCell.h"
#import "YLMessageDetailController.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "msglistHandle.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import "UIAlertCon+Extension.h"
#import "YLConverseHistoryController.h"
#import "DefineConstants.h"
#import "YLJsonExtension.h"
#import "JChatConstants.h"
#import "MessageListTableViewCell.h"
#import "MessageSystemTableViewCell.h"
#import "MessageHeaderView.h"
#import <MJRefresh.h>
#import "TUILocalStorage.h"
#import "GroupChatListViewController.h"

@interface YLMessageController ()
{
    NSMutableArray *msgListArray;//消息列表
    NSString *systemContent;//系统消息最后一条消息
    int systemUnReadCount;//系统消息未读消息数
    
    NSString *groupLastMessage;
    int groupUnreadCount;
    
    MessageHeaderView *headerView;
    NSArray *imgArr;
    NSArray *titleArr;
    NSArray *contentArr;
}

@property (weak, nonatomic) IBOutlet UITableView *msgTableView;

///会话数组
@property (nonatomic, copy)   NSArray            *conversationArray;

@end

@implementation YLMessageController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self getDataWithSystemMsg];
    
    
    if ([[TIMManager sharedInstance] getLoginStatus] != 1) {
        [SLHelper TIMLoginSuccess:^{
            [self getDataWithMsgList];
        } fail:nil];
    } else {
        [self getDataWithMsgList];
    }
    [[TIMGroupManager sharedInstance] getGroupList:nil fail:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    if (@available(iOS 11.0, *)) {
        _msgTableView.frame = CGRectMake(0, SafeAreaTopHeight, App_Frame_Width, APP_Frame_Height-SafeAreaBottomHeight-SafeAreaTopHeight);
    } else {
        _msgTableView.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
    }
    
    headerView = [[MessageHeaderView alloc] init];
    _msgTableView.tableHeaderView = headerView;
    _msgTableView.tableFooterView = [UIView new];
    WEAKSELF;
    _msgTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataWithMsgList];
    }];
    
    [_msgTableView registerClass:[MessageSystemTableViewCell class] forCellReuseIdentifier:@"systemCell"];
    imgArr = @[@"message_top_service", @"message_top_calllog", @"message_top_systrm", @"message_top_group"];
    titleArr = @[@"在线客服", @"我的通话", @"系统消息", @"群消息"];
    contentArr = @[@"在线处理用户充值、投诉、意见反馈等问题", @"全部通话显示", @"", @""];
    groupLastMessage = @"";
    groupUnreadCount = 0;
    
    //删除
    [self delAllMsgSet];
    msgListArray = [NSMutableArray array];
    [self getDataWithMsgList];
    
    //注册通知
    //收到新消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"receive_msg_notification" object:nil];
    
    BOOL isShowedMessageAlert = [[NSUserDefaults standardUserDefaults] boolForKey:@"ISSHOWEDMESSAGEALERT"];
    if (!isShowedMessageAlert) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISSHOWEDMESSAGEALERT"];
        TextAlertView *alert = [[TextAlertView alloc] initWithTitle:@"新游山官方"];
        NSString *content;
        if ([YLUserDefault userDefault].t_sex == 0) {
            content = @"        女神您好,欢迎加入新游山交友!请不要使用过外挂脚本对男用户实行轰炸式拨打视频和发消息,这样会让男用户对您造成反感,而不但不接听您的视频还会把您加入黑名单!请规范的手动发一些正规的招呼和情感话题以此来吸引男用户,效果会更好哦!请不要频繁的发送露骨的招呼,新游山平台祝您月入万元以上!";
            [alert setContentWithString:content];
        } else {
            content = @"        男神你好，本平台是绿色交友平台，倡导文明健康的聊天内容，如你在使用过程中发现有人利用本平台对你发送违规信息，请向客服投诉。特别提醒：任何以【可线下约会见面】为由要求打赏礼物或者添加微信、QQ等第三方工具发红包的均是骗子。严禁未成年人使用本平台，如果你还未满十八周岁，请主动卸载本软件。";
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:content];
            [attri addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(74, 44)];
            [attri addAttribute:NSForegroundColorAttributeName value:UIColor.redColor range:NSMakeRange(74, 44)];
            [alert setContentWithAttibutedString:attri];
        }
    }
}

#pragma mark - 删除按钮
- (void)delAllMsgSet{
    
    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, SafeAreaTopHeight)];
    nav.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:nav];
    
    UILabel *titleLabel = [UIManager initWithLabel:CGRectMake(0, SafeAreaTopHeight-44, 80, 44) text:@"消息" font:24 textColor:XZRGB(0x3f3b48)];
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [nav addSubview:titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.x+titleLabel.width/2-4, nav.height-4, 8, 4)];
    line.backgroundColor = XZRGB(0x3f3b48);
    line.layer.masksToBounds = YES;
    line.layer.cornerRadius = 2;
    [nav addSubview:line];
    
    UIButton *deleteBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-60, SafeAreaTopHeight-44, 60, 44) text:@"清空" font:16 textColor:XZRGB(0xfe2947) normalImg:nil highImg:nil selectedImg:nil];
    [deleteBtn addTarget:self action:@selector(delAllMsgList) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:deleteBtn];
}

#pragma mark - 一键删除
- (void)delAllMsgList
{
    [UIAlertCon_Extension alertViewDel:@"您确定要删除所有的聊天记录吗?" type:UIAlertControllerStyleAlert controller:self delSel:^(UIAlertAction *okSel) {
        for (int index = 0; index < self->msgListArray.count; index ++) {
            MessageListModel *model = self->msgListArray[index];
            [[TIMManager sharedInstance] deleteConversationAndMessages:TIM_C2C receiver:[NSString stringWithFormat:@"%ld",(long)model.userId]];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"MESSAGE_LOCAL_IDENT"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnReadMsgNoti" object:nil];
        [self->msgListArray removeAllObjects];
        [self.msgTableView reloadData];
    }];
}

#pragma mark - 获取系统消息
- (void)getDataWithSystemMsg {
    //系统消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnReadMsgNoti" object:nil];
    [YLNetworkInterface getUnreadMessage:[YLUserDefault userDefault].t_id block:^(int unreadMsg, NSString *content, int mansionCount) {
//        [self->headerView setSystemNum:unreadMsg];
//        [self->headerView setSystemContent:content];
//        [self->headerView setMansionCount:mansionCount];
        self->systemUnReadCount = unreadMsg;
        self->systemContent = content;
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:0];
        [self.msgTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 获取im消息
- (void)getDataWithMsgList {
    _conversationArray = [[TIMManager sharedInstance] getConversationList];
    [_msgTableView.mj_header endRefreshing];
    if ([_conversationArray count] == 0) {
        
        return;
    }
    
    [msgListArray removeAllObjects];
    bool isSetGroupLastMsg = NO;
    groupUnreadCount = 0;
    NSString *serviceids = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"serviceids"]];
    NSArray *ids = [serviceids componentsSeparatedByString:@","];
    
    for (int i = 0; i < [_conversationArray count]; i++) {
        TIMConversation *conversation = _conversationArray[i];
        //获取identifier
        NSString *identifier = [NSString stringWithFormat:@"%@", [conversation getReceiver]];
        //如果小于10001 则不是正确的会话
        if ([identifier integerValue] < 10001 || conversation.getType != 1 || [identifier containsString:@"null"]) {
            if (conversation.getType == 2) {
                TIMGroupInfo *groupInfo = [[TIMGroupManager sharedInstance] queryGroupInfo:identifier];
                if ([groupInfo.groupType isEqualToString:@"Public"]) {
                    MessageListModel *model = [MessageListModel new];
                    model.dataModel = [[MessageListDataModel alloc] initWithConversation:conversation];
                    if (model.dataModel.msgText.length > 0 && !isSetGroupLastMsg) {
                        groupLastMessage = model.dataModel.msgText;
                        isSetGroupLastMsg = YES;
                    }
                    groupUnreadCount += model.dataModel.unReadMsgCount;
                } else {
                    [conversation setReadMessage:nil succ:nil fail:nil];//标记已读
                }
            }
            continue;
        } else {
            [[TIMFriendshipManager sharedInstance] getUsersProfile:@[identifier] forceUpdate:YES succ:nil fail:nil];
            if (![ids containsObject:identifier]) {
                TIMUserProfile *user = [[TIMFriendshipManager sharedInstance] queryUserProfile:identifier];
                if (user.gender == TIM_GENDER_UNKNOWN || (user.gender == TIM_GENDER_MALE && [YLUserDefault userDefault].t_sex == 1) || (user.gender == TIM_GENDER_FEMALE && [YLUserDefault userDefault].t_sex == 0)) {
                    //同性别不展示 标记已读
                    [conversation setReadMessage:nil succ:nil fail:nil];
                    continue;
                }
            }
            
            MessageListModel *model = [MessageListModel new];
            model.isTextMessage = YES;
            model.userId = [identifier integerValue];
            model.dataModel = [[MessageListDataModel alloc] initWithConversation:conversation];
            if (model.dataModel.nickName.length == 0 || [model.dataModel.nickName isEqualToString:@"(null)"]) {
                model.dataModel.nickName = [NSString stringWithFormat:@"聊友:%@",identifier];
            }
            
            if (![msgListArray containsObject:model]) {
                if ([[[TUILocalStorage sharedInstance] topConversationList] containsObject:identifier]) {
                    model.isTop = YES;
                    [msgListArray insertObject:model atIndex:0];
                } else {
                    model.isTop = NO;
                    [msgListArray addObject:model];
                }
            }
        }
    }
    [self.msgTableView reloadData];
}

#pragma mark ---- tableView
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MessageSystemTableViewCell *systemCell = [tableView dequeueReusableCellWithIdentifier:@"systemCell"];
        [systemCell setLogo:imgArr[indexPath.row] title:titleArr[indexPath.row]];
        if (indexPath.row == 2) {
            [systemCell setContent:systemContent];
            [systemCell setCellNubmer:systemUnReadCount];
        } else if (indexPath.row == 3) {
            [systemCell setContent:groupLastMessage];
            [systemCell setCellNubmer:groupUnreadCount];
        } else {
            [systemCell setContent:contentArr[indexPath.row]];
            [systemCell setCellNubmer:0];
        }
        return systemCell;
    }
    MessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageListTableViewCell"];
    if (!cell){
        cell = [[MessageListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageListTableViewCell"];
    }
    MessageListModel *model = msgListArray[indexPath.row];
    [cell initWithData:model];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return @"";
    }
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) return;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [UIAlertCon_Extension alertViewDel:@"您确定要删除聊天记录吗?" type:UIAlertControllerStyleAlert controller:self delSel:^(UIAlertAction *okSel) {
            
            MessageListModel *model = self->msgListArray[indexPath.row];
            [[TIMManager sharedInstance] deleteConversationAndMessages:TIM_C2C receiver:[NSString stringWithFormat:@"%ld",(long)model.userId]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnReadMsgNoti" object:nil];
            [self->msgListArray removeObject:model];
            [self.msgTableView reloadData];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [YLPushManager pushService];
        } else if (indexPath.row == 1) {
            YLConverseHistoryController *coversationVC = [YLConverseHistoryController new];
            coversationVC.title = @"我的通话";
            [self.navigationController pushViewController:coversationVC animated:YES];
        } else if (indexPath.row == 2) {
            systemUnReadCount = 0;
            YLMessageDetailController *msgDetailVC  = [YLMessageDetailController new];
            msgDetailVC.title = @"系统消息";
            [self.navigationController pushViewController:msgDetailVC animated:YES];
        } else if (indexPath.row == 3) {
            //群消息
            GroupChatListViewController *listVC = [[GroupChatListViewController alloc] init];
            [self.navigationController pushViewController:listVC animated:YES];
        }
    } else {
        MessageListModel *model = msgListArray[indexPath.row];
        
        //文字聊天

        [YLPushManager pushChatViewController:model.userId - 10000 otherSex:-1];
//        [self.msgTableView reloadData];
        model.dataModel.unReadMsgCount = 0;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 5)];
    view.backgroundColor = XZRGB(0xf2f3f7);
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return imgArr.count;
    }
    return msgListArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark -
#pragma mark - Notification
- (void)receiveMessage:(NSNotification *)notification {
    msgListArray = [NSMutableArray new];
    [self getDataWithMsgList];
}

@end
