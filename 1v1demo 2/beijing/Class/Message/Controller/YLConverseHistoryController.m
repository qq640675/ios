//
//  YLConverseHistoryController.m
//  beijing
//
//  Created by zhou last on 2018/10/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLConverseHistoryController.h"
#import "conversationHistoryCell.h"
#import "YLUserDefault.h"
#import "YLNetworkInterface.h"
#import <MJRefresh.h>
#import "conversationHandle.h"
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import "NSString+Util.h"
#import "DefineConstants.h"
#import "YLPushManager.h"

@interface YLConverseHistoryController ()
{
    int godNessPage;
    NSMutableArray *ConversationArray;
}

@property (weak, nonatomic) IBOutlet UITableView *converseTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstrint;


@end

@implementation YLConverseHistoryController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bottomConstrint.constant = SafeAreaBottomHeight-49;

    self.converseTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        self->godNessPage = 1;
        [self conversationHistoryQuest:self->godNessPage];
    }];
    
    [self.converseTableView.mj_header beginRefreshing];
    self.converseTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark ---- 通话记录
- (void)conversationHistoryQuest:(int)page
{
    dispatch_queue_t queue = dispatch_queue_create("获取主页列表", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        [YLNetworkInterface getCallLog:[YLUserDefault userDefault].t_id
                            page:page
                           block:^(NSMutableArray *listArray)
        {
            if (self->godNessPage == 1) {
                self->ConversationArray = [NSMutableArray array];
                
                self->ConversationArray = listArray;
            }else{
                for (conversationHandle *handle in listArray) {
                    [self->ConversationArray addObject:handle];
                }
            }
            if (self->ConversationArray.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"没有数据"];
            }
            
            [self.converseTableView reloadData];
            [self.converseTableView.mj_header endRefreshing];
            [self.converseTableView.mj_footer endRefreshing];
        }];
    });
}

#pragma mark ---- 加载更多数据
- (void)loadMoreData
{
    if (ConversationArray.count != 0) {
        conversationHandle *handle = ConversationArray[0];
        if (handle.pageCount > godNessPage) {
            godNessPage ++;
            [self conversationHistoryQuest:godNessPage];
        }else{
            if (self.converseTableView.mj_footer.isRefreshing) {
                [self.converseTableView.mj_footer endRefreshing];
                [self.converseTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }else{
        if (self.converseTableView.mj_footer.isRefreshing) {
            [self.converseTableView.mj_footer endRefreshing];
            [self.converseTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

#pragma mark ---- tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ConversationArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    conversationHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"conversationHistoryCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"conversationHistoryCell" owner:nil options:nil] firstObject];
    }else{
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    //头像
    if (ConversationArray.count != 0) {
        conversationHandle *handle = ConversationArray[indexPath.row];
        if (![NSString isNullOrEmpty:handle.t_handImg]) {
            [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:handle.t_handImg] placeholderImage:[UIImage imageNamed:@"default"]];
        }else{
            cell.headImgView.image = [UIImage imageNamed:@"default"];
        }
        
        //昵称
        if (![NSString isNullOrEmpty:handle.t_nickName]) {
            cell.nickNameLabel.text = handle.t_nickName;
        }else{
            cell.nickNameLabel.text = @"昵称：无";
        }
        
        //类型
        if (![handle.t_call_time isEqualToString:@"0"]) {
            if (handle.callType == 1) {
                //1.呼出 2.呼入
                cell.typeImgView.image = [UIImage imageNamed:@"newmessage_callout"];
            }else{
                cell.typeImgView.image = [UIImage imageNamed:@"newmessage_callin"];
            }
            cell.lastTimeLabel.text = [NSString stringWithFormat:@"通话时间:%@分钟",handle.t_call_time];
        }else{
            if (handle.callType == 1) {
                //1.呼出 2.呼入
                cell.typeImgView.image = [UIImage imageNamed:@"newmessage_calloutfail"];
            }else{
                cell.typeImgView.image = [UIImage imageNamed:@"newmessage_callinfail"];
            }
            cell.lastTimeLabel.text = @"未接听";
            cell.lastTimeLabel.textColor = XZRGB(0xfe2947);
        }
        
        //时间
        cell.endTimeLabel.text = handle.t_create_time;
    }
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    conversationHandle *handle = ConversationArray[indexPath.row];
    if (handle.t_role != 1) {
        //用户
        [YLPushManager pushFansDetail:handle.t_id];
    } else {
        //主播
        [YLPushManager pushAnchorDetail:handle.t_id];
    }
}


@end
