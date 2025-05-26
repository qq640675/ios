//
//  YLNAttentionController.m
//  beijing
//
//  Created by zhou last on 2018/10/28.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLNAttentionController.h"
#import "newAttentionCell.h"
#import <MJRefresh.h>
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "attentionInfoHandle.h"
#import <UIImageView+WebCache.h>
#import "NSString+Util.h"
#import "DefineConstants.h"
#import "YLPushManager.h"

@interface YLNAttentionController ()
{
    int nPage; //页码
    NSMutableArray *attentionListArray; //我的关注数据
}

@property (weak, nonatomic) IBOutlet UITableView *nAttentionTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation YLNAttentionController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = KWHITECOLOR;

    if (_isHomePage) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bottomConstraint.constant = SafeAreaBottomHeight-49;

    [self newAttentionCustomUI];
}

#pragma mark ---- customUI
- (void)newAttentionCustomUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.nAttentionTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        self->nPage = 1;
        [self getAtttentionList:self->nPage];
    }];
    [self.nAttentionTableView.mj_header beginRefreshing];
    self.nAttentionTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNAttentionData)];
}

#pragma mark ---- 获取我的关注列表
- (void)getAtttentionList:(int)page
{
    dispatch_queue_t queue = dispatch_queue_create("我的关注列表", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        //获取主播个人资料
        [YLNetworkInterface getFollowList:[YLUserDefault userDefault].t_id page:page block:^(NSMutableArray *listArray) {
            if (self->nPage == 1) {
                self->attentionListArray = [NSMutableArray array];
                self->attentionListArray = listArray;
            }else{
                for (attentionInfoHandle *handle in listArray) {
                    [self->attentionListArray addObject:handle];
                }
            }
            
            [self.nAttentionTableView reloadData];
            [self.nAttentionTableView.mj_footer endRefreshing];
            [self.nAttentionTableView.mj_header endRefreshing];
        }];
    });
}

- (void)loadNAttentionData
{
    if (attentionListArray.count != 0) {
        attentionInfoHandle *handle = attentionListArray[0];
        if (handle.pageCount > nPage) {
            nPage ++;
            [self getAtttentionList:nPage];
        }else{
            if (self.nAttentionTableView.mj_footer.isRefreshing) {
                [self.nAttentionTableView.mj_footer endRefreshing];
                [self.nAttentionTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }else{
        if (self.nAttentionTableView.mj_footer.isRefreshing) {
            [self.nAttentionTableView.mj_footer endRefreshing];
            [self.nAttentionTableView.mj_footer endRefreshingWithNoMoreData];
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
    return attentionListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    newAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newAttentionCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"newAttentionCell" owner:nil options:nil] firstObject];
    }else{
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    if (attentionListArray.count != 0) {
        attentionInfoHandle *handle = attentionListArray[indexPath.row];
        
        //头像
        if (![NSString isNullOrEmpty:handle.t_handImg]) {
            [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:handle.t_handImg] placeholderImage:IChatUImage(@"default")];
        }else{
            [cell.headImgView setImage:IChatUImage(@"default")];
        }
        
        //昵称
        if (![NSString isNullOrEmpty:handle.t_nickName]) {
            cell.nickNameLabel.text = handle.t_nickName;
        }else{
            cell.nickNameLabel.text = [NSString stringWithFormat:@"聊友:%d",handle.t_id];
        }
        
        //个性签名
        if (![NSString isNullOrEmpty:handle.t_autograph]) {
            cell.autographLabel.text = handle.t_autograph;
        }else{
            cell.autographLabel.text = @"这个人太忙,忘记签名了";
        }
        
        //在线状态 0.在线1.在聊2.离线
        if (handle.t_state == 0) {
            [cell.statusView.layer setBorderColor:XZRGB(0xbcbcbc).CGColor];
            [cell.statusLabel setTextColor:XZRGB(0x868686)];
            [cell.circleView setBackgroundColor:XZRGB(0x1dec1d)];
            cell.statusLabel.text = @"在线";
        }else if (handle.t_state == 1){
            [cell.statusView.layer setBorderColor:XZRGB(0xbcbcbc).CGColor];
            [cell.statusLabel setTextColor:XZRGB(0x868686)];
            [cell.circleView setBackgroundColor:XZRGB(0xAE4FFD)];
            cell.statusLabel.text = @"在聊";
        }else{
            [cell.statusView.layer setBorderColor:XZRGB(0xbcbcbc).CGColor];
            [cell.statusLabel setTextColor:XZRGB(0x868686)];
            [cell.circleView setBackgroundColor:XZRGB(0xbcbcbc)];
            cell.statusLabel.text = @"离线";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (attentionListArray.count != 0) {
        attentionInfoHandle *Handle = attentionListArray[indexPath.row];
        
        [YLPushManager pushAnchorDetail:Handle.t_id];
    }
   
}


@end
