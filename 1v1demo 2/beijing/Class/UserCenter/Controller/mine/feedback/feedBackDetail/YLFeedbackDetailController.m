//
//  YLFeedbackDetailController.m
//  beijing
//
//  Created by zhou last on 2018/7/24.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLFeedbackDetailController.h"
#import "feedBackDetailCell.h"
#import "YLNetworkInterface.h"
#import "feedbackDetailHandle.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "DefineConstants.h"

@interface YLFeedbackDetailController ()
{
    feedbackDetailHandle *detailHandle;
}

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@end

@implementation YLFeedbackDetailController

- (void)viewWillAppear:(BOOL)animated
{
    [self feedBackDetailRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark ----
- (void)feedBackDetailRequest
{
    
    dispatch_queue_t queue = dispatch_queue_create("历史反馈详情", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        [YLNetworkInterface getFeedBackById:self.feedBackId block:^(feedbackDetailHandle *handle) {
            self->detailHandle = handle;
            
            [self.detailTableView reloadData];
        }];
    });
}


#pragma mark ---- tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (detailHandle.t_is_handle == 0) {
        return 1;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    feedBackDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    //因为服务器返回数据不一致，这里判断比较麻烦
    if (indexPath.row == 0) {
        CGSize contentSize = [detailHandle.t_content sizeWithMaxWidth:App_Frame_Width - 30 andFont:PingFangSCFont(16)];
        
        float sizeHeight = contentSize.height;
        if (sizeHeight < 20) {
            sizeHeight = 20;
        }
        
        float imageHeight = 0;
        if (![NSString isNullOrEmpty:detailHandle.t_img_url]) {
            cell.imageConstraintHeight.constant = 50;
            imageHeight = 50;
        }else{
            cell.imageConstraintHeight.constant = 0;
        }
        
        cell.cellHeight.constant = 61 + sizeHeight + imageHeight + 20;
        return 61 + sizeHeight + imageHeight + 22;
    }else{
        CGSize contentSize = [detailHandle.t_handle_res sizeWithMaxWidth:App_Frame_Width - 30 andFont:PingFangSCFont(16)];
        
        
        float imageHeight = 0;

        if (![NSString isNullOrEmpty:detailHandle.t_handle_img]) {
            cell.imageConstraintHeight.constant = 50;
            imageHeight = 50;
        }else{
            cell.imageConstraintHeight.constant = 0;
        }
        
        cell.cellHeight.constant = 61 + contentSize.height + imageHeight + 10;
        return 61 + contentSize.height + imageHeight + 11;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    feedBackDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedBackDetailCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"feedBackDetailCell" owner:nil options:nil] firstObject];
    }else{
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    if (indexPath.row == 0) {
        cell.tittleLabel.text = @"反馈内容";
        cell.contentLabel.text = detailHandle.t_content;
        
        if (![NSString isNullOrEmpty:detailHandle.t_img_url]) {
            cell.ImgBackView.hidden = NO;
            NSArray *imgArray = [detailHandle.t_img_url componentsSeparatedByString:@","];
            for (int j= 0; j< imgArray.count; j++) {
                UIImageView *feedImgView = [UIImageView new];
                feedImgView.frame = CGRectMake(j * 65, 0, 50, 50);
                [feedImgView sd_setImageWithURL:[NSURL URLWithString:imgArray[j]]];
                [feedImgView.layer setCornerRadius:5.];
                [feedImgView setClipsToBounds:YES];
                [cell.ImgBackView addSubview:feedImgView];
            }
        }else{
            cell.imageConstraintHeight.constant = 0;
            cell.ImgBackView.hidden = YES;
        }
    }else{
        cell.tittleLabel.text = @"反馈结果";
        cell.contentLabel.text = detailHandle.t_handle_res;
        if (![NSString isNullOrEmpty:detailHandle.t_handle_img]) {
            cell.ImgBackView.hidden = NO;
            NSArray *imgArray = [detailHandle.t_handle_img componentsSeparatedByString:@","];
            for (int j= 0; j< imgArray.count; j++) {
                UIImageView *feedImgView = [UIImageView new];
                feedImgView.frame = CGRectMake(j * 65, 0, 50, 50);
                [feedImgView sd_setImageWithURL:[NSURL URLWithString:imgArray[j]]];
                [feedImgView.layer setCornerRadius:5.];
                [feedImgView setClipsToBounds:YES];
                [cell.ImgBackView addSubview:feedImgView];
            }
        }else{
            cell.imageConstraintHeight.constant = 0;
            cell.ImgBackView.hidden = YES;
        }
    }
    
    return cell;
}



@end
