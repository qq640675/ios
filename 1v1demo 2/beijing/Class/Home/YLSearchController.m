//
//  YLSearchController.m
//  beijing
//
//  Created by zhou last on 2018/8/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLSearchController.h"
#import "searchListCell.h"
#import "DefineConstants.h"
#import "YLBasicView.h"
#import <Masonry.h>
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "searchListHandle.h"
#import <UIImageView+WebCache.h>
#import "NSString+Extension.h"
#import "YLTapGesture.h"
#import <AVFoundation/AVFoundation.h>
#import "UIAlertCon+Extension.h"
#import "YLRechargeVipController.h"
#import <SVProgressHUD.h>
#import "ChatLiveManager.h"
#import "YLPushManager.h"
#import "LXTAlertView.h"

@interface YLSearchController ()
{
    NSMutableArray *searchListArray;
}

@property (weak, nonatomic) IBOutlet UITableView *seachTableView;
//导航栏
@property (weak, nonatomic) IBOutlet UIView *navBgView;
@property (weak, nonatomic) IBOutlet UIView *rectView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeightConstraint;

@end

@implementation YLSearchController

- (instancetype)init
{
    if (self == [super init]) {
        [_inputTextField becomeFirstResponder];
        [YLTapGesture tapGestureTarget:self sel:@selector(hideKeyBoard) view:self.view];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navHeightConstraint.constant = SafeAreaTopHeight+6;

    [self searchCustomUI];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
  
    [self getSearchList];
    
    return YES;
}

#pragma mark --- 获取搜索列表
- (void)getSearchList
{
    if ([NSString isNullOrEmpty:self.inputTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"输入框不能为空"];
        return;
    }
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    NSString *text = self.inputTextField.text;
    dispatch_queue_t queue = dispatch_queue_create("获取搜索列表", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        self->searchListArray = [NSMutableArray array];
        [YLNetworkInterface getSearchList:[YLUserDefault userDefault].t_id
                                     page:1
                                condition:text
                                    block:^(NSMutableArray *listArray)
         {
             [SVProgressHUD dismiss];
             self->searchListArray = listArray;
             if ([listArray count] > 0) {
                 [self.seachTableView reloadData];
             } else {
                 [SVProgressHUD showInfoWithStatus:@"没有找到该用户"];
             }
             
             
         }];
    });
   
}

#pragma mark ---- customUI
- (void)searchCustomUI
{
    [self.rectView.layer setCornerRadius:4.];
    [self.rectView setClipsToBounds:YES];
}

#pragma mark ---- 隐藏键盘
- (void)hideKeyBoard
{
    [self.inputTextField resignFirstResponder];
}

#pragma mark ---- tableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = KWHITECOLOR;
    
    UILabel *titleLabel = [YLBasicView createLabeltext:@"热搜主播" size:PingFangSCFont(14) color:XZRGB(0x999999) textAlignment:NSTextAlignmentLeft];
    [view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(21);
    }];
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    searchListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"searchListCell" owner:nil options:nil] firstObject];
    }else{
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
  
    searchListHandle *handle = searchListArray[indexPath.row];
    
    //头像
    if (![NSString isNullOrEmpty:handle.t_handImg]) {
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:handle.t_handImg] placeholderImage:[UIImage imageNamed:@"default"]];
    }else{
        cell.headImgView.image = [UIImage imageNamed:@"default"];
    }
    [cell.headImgView.layer setCornerRadius:4.];
    cell.headImgView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.headImgView setClipsToBounds:YES];
    cell.headImgView.userInteractionEnabled = YES;
    cell.headImgView.tag = 100 + indexPath.row;
    [YLTapGesture tapGestureTarget:self sel:@selector(headViewTap:) view:cell.headImgView];

    
    if (searchListArray.count != 0) {
        //状态
        if (handle.t_onLine == 0) {
            cell.statusLabel.text = @"在线";
            cell.statusLabel.backgroundColor = XZRGB(0xFD49AA);
        }else if (handle.t_onLine == 1){
            cell.statusLabel.text = @"在聊";
            cell.statusLabel.backgroundColor = IColor(194, 166, 44);
        }else{
            cell.statusLabel.text = @"离线";
            cell.statusLabel.backgroundColor = XZRGB(0xdcdcdc);
        }
        [YLBasicView angleCorner:cell.statusLabel firstCorner:UIRectCornerBottomLeft radius:7.];
        
        //昵称
        if (![NSString isNullOrEmpty:handle.t_nickName]) {
            cell.nameLabel.text = handle.t_nickName;
        }else{
            cell.nameLabel.text = [NSString stringWithFormat:@"聊友:%d",handle.t_id];
        }
        
        //粉丝
        cell.fansLabel.text = [NSString stringWithFormat:@"粉丝:%d",handle.fansCount];
        
        //关注主播
        cell.attentionView.tag = 100 + indexPath.row;
        [YLTapGesture tapGestureTarget:self sel:@selector(atttentionBtnClicked:) view:cell.attentionView];
        cell.attentionView.hidden = YES;
        //视频聊天
        cell.videoChatView.hidden = YES;

        cell.videoChatView.tag = 100 + indexPath.row;
        [YLTapGesture tapGestureTarget:self sel:@selector(searchVideoChatBtnClicked:) view:cell.videoChatView];
     
        //关注状态
        if (handle.isFollow == 0) {
            cell.attentionLabel.text = @"关注";
        }else{
            cell.attentionLabel.text = @"已关注";
        }
    }
    
    return cell;
}

- (void)headViewTap:(UITapGestureRecognizer *)tap
{
    searchListHandle *handle = searchListArray[tap.view.tag - 100];
    
    if (handle.t_role != 1) {
        //用户
        [YLPushManager pushFansDetail:handle.t_id];
    } else {
        //主播
        if (handle.t_is_public == 1) {
            //存在免费视频
            [YLPushManager pushUserInfo:handle.t_id];
        }else{
            //不存在免费视频
            [YLPushManager pushAnchorDetail:handle.t_id];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ---- 关注主播
- (void)atttentionBtnClicked:(UITapGestureRecognizer *)tap
{
    searchListHandle *handle = searchListArray[tap.view.tag - 100];

    if (handle.isFollow == 0) {
        //未关注的关注
        dispatch_queue_t queue = dispatch_queue_create("添加关注", DISPATCH_QUEUE_CONCURRENT);
        //使用异步函数封装三个任务
        dispatch_async(queue, ^{
            [YLNetworkInterface addAttention:[YLUserDefault userDefault].t_id
                           coverFollowUserId:handle.t_id
                                       block:^(BOOL isSuccess)
             {
                 if (isSuccess) {
                     [self getSearchList];
                 }
             }];
        });
    }else{
        //已关注的取消关注
        dispatch_queue_t queue = dispatch_queue_create("取消关注", DISPATCH_QUEUE_CONCURRENT);
        //使用异步函数封装三个任务
        dispatch_async(queue, ^{
            [YLNetworkInterface cancelAtttention:[YLUserDefault userDefault].t_id
                               coverFollowUserId:handle.t_id
                                           block:^(BOOL isSuccess)
             {
                 if (isSuccess) {
                     [self getSearchList];
                 }
             }];
        });
    }
}

#pragma mark ---- 视频聊天
- (void)searchVideoChatBtnClicked:(UITapGestureRecognizer *)tap
{
    searchListHandle *handle = searchListArray[tap.view.tag - 100];
    
    [self getVideoChatAutograph:handle];
}

- (void)getVideoChatAutograph:(searchListHandle *)handle {
    [self goVideoVC:handle.t_id];
}

- (void)goVideoVC:(int)otherId {
    [self clickedVideo:otherId];
}

- (void)clickedVideo:(int)otherId {
    [[ChatLiveManager shareInstance] getVideoChatAutographWithOtherId:otherId type:1 fail:nil];
}

#pragma mark ---- 返回
- (IBAction)backBtnBeClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
