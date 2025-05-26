//
//  YLHistoryFeedBackController.m
//  beijing
//
//  Created by zhou last on 2018/7/24.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLHistoryFeedBackController.h"
#import "feedBackHistoryCell.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "YLFeedbackDetailController.h"
#import "feedBackHandle.h"

@interface YLHistoryFeedBackController ()
{
    NSMutableArray *feedBackListArray;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end

@implementation YLHistoryFeedBackController

- (void)viewWillAppear:(BOOL)animated
{
    [self historyFeedBackRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}


#pragma mark ---- 请求历史反馈数据
- (void)historyFeedBackRequest
{
    dispatch_queue_t queue = dispatch_queue_create("历史反馈数据", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        self->feedBackListArray = [NSMutableArray array];
        [YLNetworkInterface getFeedBackList:[YLUserDefault userDefault].t_id
                                 page:1
                                block:^(NSMutableArray *listArray)
        {
            self->feedBackListArray = listArray;
            
            [self.listTableView reloadData];
        }];
    });
}


#pragma mark ---- tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return feedBackListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    feedBackHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedBackHistoryCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"feedBackHistoryCell" owner:nil options:nil] firstObject];
    }else{
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    feedBackHandle *handle = feedBackListArray[indexPath.row];
    cell.contentLabel.text = handle.t_content;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    feedBackHandle *handle = feedBackListArray[indexPath.row];

    YLFeedbackDetailController *feedBackDetailVC = [YLFeedbackDetailController new];
    feedBackDetailVC.title                  = @"反馈详情";
    feedBackDetailVC.feedBackId            = handle.t_id;
    [self.navigationController pushViewController:feedBackDetailVC animated:YES];
}


@end
