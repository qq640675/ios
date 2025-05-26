//
//  YLUnionController.m
//  beijing
//
//  Created by zhou last on 2018/9/11.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLUnionController.h"
#import "unionCell.h"
#import "YLBasicView.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "ContributionListHandle.h"
#import "NSString+Util.h"
#import <UIImageView+WebCache.h>
#import "YLUnionDetailController.h"

@interface YLUnionController ()
{
    NSMutableArray *ContributionListArray; //主播列表
}

//列表
@property (weak, nonatomic) IBOutlet UITableView *unionTableView;

//主播数
@property (weak, nonatomic) IBOutlet UILabel *anchorCountLabel;
//金币数
@property (weak, nonatomic) IBOutlet UILabel *goldTotalLabel;
//暂无数据
@property (weak, nonatomic) IBOutlet UILabel *nodataLabel;


@end

@implementation YLUnionController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //获取公会贡献列表
    [self getContributionList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark ---- 返回

- (IBAction)backToMyVCClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- 获取公会贡献列表
- (void)getContributionList
{
    
    dispatch_queue_t queue = dispatch_queue_create("公会", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        //获取公会贡献列表
        self->ContributionListArray = [NSMutableArray array];
        [YLNetworkInterface getContributionList:[YLUserDefault userDefault].t_id page:1 block:^(NSMutableArray *listArray) {
            self->ContributionListArray = listArray;
            
            if (listArray.count != 0) {
                self.nodataLabel.hidden = YES;
            }else{
                self.nodataLabel.hidden = NO;
            }
            
            [self.unionTableView reloadData];
        }];
    });
    
    dispatch_async(queue, ^{
        //统计公会主播数和贡献值
        [YLNetworkInterface getGuildCount:[YLUserDefault userDefault].t_id block:^(int anchorCount, int totalGold) {
            self.anchorCountLabel.text = [NSString stringWithFormat:@"%d",anchorCount];
            self.goldTotalLabel.text = [NSString stringWithFormat:@"%d",totalGold];
        }];
    });
}

#pragma mark ---- tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ContributionListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    unionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"unionCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"unionCell" owner:nil options:nil] firstObject];
    }else{
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    //头像
    ContributionListHandle *handle = ContributionListArray[indexPath.row];
    
    if (![NSString isNullOrEmpty:handle.t_handImg]) {
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:handle.t_handImg] placeholderImage:[UIImage imageNamed:@"default"]];
    }else{
        cell.headImgView.image = [UIImage imageNamed:@"default"];
    }
    cell.headImgView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.headImgView setClipsToBounds:YES];
    
    //名字
    if (![NSString isNullOrEmpty:handle.t_nickName]) {
        cell.nickNameLabel.text = handle.t_nickName;
    }else{
        cell.nickNameLabel.text = [NSString stringWithFormat:@"聊友:%d",handle.t_anchor_id];
    }
    
    //贡献金币
    cell.coinsLabel.text = [NSString stringWithFormat:@"贡献值: %d 金币",handle.totalGold];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ContributionListHandle *handle = ContributionListArray[indexPath.row];
    
    YLUnionDetailController *unionDetailVC = [YLUnionDetailController new];
    unionDetailVC.title                = @"主播贡献详情";
    unionDetailVC.anchorId            = handle.t_anchor_id;
    [self.navigationController pushViewController:unionDetailVC animated:NO];
}




@end

