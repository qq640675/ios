//
//  YLMessageDetailController.m
//  beijing
//
//  Created by zhou last on 2018/6/25.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLMessageDetailController.h"
#import "DefineConstants.h"
#import <Masonry.h>
#import "messageDetailCell.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "sytemMsgHandle.h"
#import <MJRefresh.h>

@interface YLMessageDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *msgDetailArray;
    int messagePage;
}

@property (weak, nonatomic) IBOutlet UITableView *msgDetailTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstrint;


@end

@implementation YLMessageDetailController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.msgDetailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        self->messagePage = 1;
        [self getMessageList:self->messagePage];
    }];
    [self.msgDetailTableView.mj_header beginRefreshing];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [YLNetworkInterface setupReadMessage];
    _bottomConstrint.constant = SafeAreaBottomHeight-49;
    
    self.msgDetailTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSystemMessage)];
}

- (void)viewDidDisappear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnReadMsgNoti" object:nil];
}


#pragma mark ---- 我的消息列表
- (void)getMessageList:(int)page {
    [YLNetworkInterface getMessageList:[YLUserDefault userDefault].t_id
                            page:page
                           block:^(NSMutableArray *listArray)
    {
        if (self->messagePage == 1) {
            self->msgDetailArray = [NSMutableArray array];
            
            self->msgDetailArray = listArray;
        }else{
            for (incomeDetailHandle *handle in listArray) {
                [self->msgDetailArray addObject:handle];
            }
        }
        
        [self.msgDetailTableView reloadData];
        [self.msgDetailTableView.mj_header endRefreshing];
        [self.msgDetailTableView.mj_footer endRefreshing];
    }];
}

#pragma mark ---- 加载更多系统消息
- (void)loadMoreSystemMessage
{
    if (msgDetailArray.count != 0) {
        incomeDetailHandle *handle = msgDetailArray[0];
        if (handle.pageCount > messagePage) {
            messagePage ++;
            [self getMessageList:messagePage];
        }else{
            if (self.msgDetailTableView.mj_footer.isRefreshing) {
                [self.msgDetailTableView.mj_footer endRefreshing];
                [self.msgDetailTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }else{
        if (self.msgDetailTableView.mj_footer.isRefreshing) {
            [self.msgDetailTableView.mj_footer endRefreshing];
            [self.msgDetailTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

#pragma mark ---- tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return msgDetailArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    sytemMsgHandle *handle = msgDetailArray[indexPath.row];
//
//    return [messageDetailCell getCellHeight:@"系统消息" content:handle.t_message_content];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageDetailCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"messageDetailCell" owner:nil options:nil] firstObject];
    }
    
    sytemMsgHandle *handle = msgDetailArray[indexPath.row];
    
    [cell msgDetailModel:handle.t_create_time tittle:@"系统消息" content:handle.t_message_content image:handle.t_message_url];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
