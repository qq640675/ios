//
//  YLStarRateController.m
//  beijing
//
//  Created by zhou last on 2018/8/22.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLStarRateController.h"
#import "XHStarRateView.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "DefineConstants.h"
#import "imageLabelHandle.h"
#import "YLBasicView.h"
#import "YLTapGesture.h"

@interface YLStarRateController ()
{
    NSMutableArray *labelArray;
    NSMutableArray *buttonArray;
    NSMutableArray *idArray;
    int commScore;
}
//星星背景
@property (weak, nonatomic) IBOutlet UIView *starBgView;
//标签评论背景
@property (weak, nonatomic) IBOutlet UIView *labelsRateBgView;

//返回
@property (weak, nonatomic) IBOutlet UIView *navBackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navViewHeight;


@end

@implementation YLStarRateController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navViewHeight.constant = SafeAreaTopHeight;

    [self starRateCustomUI];

}

#pragma mark ---- 获取标签列表
- (void)getlabelsList
{
    
    labelArray = [NSMutableArray array];
    buttonArray = [NSMutableArray array];
    idArray = [NSMutableArray array];
    [YLNetworkInterface getLabelList:self.godNessUserId block:^(NSMutableArray *listArray) {
        self->labelArray = listArray;
        
        [self createImageLabel];
        [self createDistributeBtnSet];
    }];
}

#pragma mark ---- customUI
- (void)starRateCustomUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self starRateSet];
    [self getlabelsList];
    [YLTapGesture tapGestureTarget:self sel:@selector(backNavTap:) view:self.navBackView];
}

#pragma mark ---- 返回
- (void)backNavTap:(UITapGestureRecognizer *)tap
{
//    [self dismissViewControllerAnimated:NO completion:^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"starRateFinishNoti" object:nil];
//    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---- 构建评论标签列表
- (void)createImageLabel
{
    float width = 70;
    float height = 30;
    float x = (App_Frame_Width - 280)/5.;
    float y = 15;
    float blank = (App_Frame_Width -280)/5.;
    int  first_rand = arc4random() % (labelArray.count/2);
    
    for (int j= 0; j< labelArray.count; j++) {
        imageLabelHandle *handle = labelArray[j];
        
        UIButton *imageLButton = [YLBasicView createButton:IColor(38, 38, 38) text:handle.t_label_name backColor:IColor(220, 220, 220) cordius:3. font:[UIFont systemFontOfSize:13]];
        imageLButton.frame = CGRectMake(x, y, width, height);
        imageLButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        imageLButton.tag = j;
        [imageLButton addTarget:self action:@selector(labelBtnBeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.labelsRateBgView addSubview:imageLButton];
        
        if (j == first_rand || j == (first_rand + labelArray.count/2)){
            //随机数
            [imageLButton setBackgroundColor:IColor(220, 80, 169)];
            [imageLButton setTitleColor:KWHITECOLOR forState:UIControlStateNormal];
            [buttonArray addObject:imageLButton];
            
            [idArray addObject:[NSString stringWithFormat:@"%@",handle.t_id]];
        }
        
        if ((j+1) % 4 == 0){
            y += height + 10;
            x = blank;
        }else{
            x += width + blank;
        }
    }
}

- (void)labelBtnBeClicked:(UIButton *)sender
{
    if ([sender.backgroundColor isEqual:IColor(220, 80, 169)]) {
        [sender setTitleColor:IColor(38, 38, 38) forState:UIControlStateNormal];
        [sender setBackgroundColor:IColor(220, 220, 220)];
        //取消选中
        
        for (int j= 0; j< buttonArray.count; j++) {
            UIButton *button = buttonArray[j];
            
            if ([button.currentTitle isEqualToString:sender.currentTitle]) {
                [buttonArray removeObjectAtIndex:j];
                [idArray removeObjectAtIndex:j];
            }
        }
    }else{
        imageLabelHandle *handle = labelArray[sender.tag];
        
        [sender setBackgroundColor:IColor(220, 80, 169)];
        [sender setTitleColor:KWHITECOLOR forState:UIControlStateNormal];
        //选中
        
        if (buttonArray.count < 2) {
            [buttonArray addObject:sender];
            
            [idArray addObject:[NSString stringWithFormat:@"%@",handle.t_id]];
        }else{
            UIButton *button = buttonArray[0];
            [button setTitleColor:IColor(38, 38, 38) forState:UIControlStateNormal];
            [button setBackgroundColor:IColor(220, 220, 220)];
            
            [buttonArray removeObjectAtIndex:0];
            [idArray removeObjectAtIndex:0];
            
            [buttonArray addObject:sender];
            [idArray addObject:[NSString stringWithFormat:@"%@",handle.t_id]];
        }
    }
}

#pragma mark ---- 发布按钮
- (void)createDistributeBtnSet
{
    float height = 0.;
    if (labelArray.count % 4 == 0) {
        height = 40  * (labelArray.count / 4) + 65;
    }else{
        height = 40  * (labelArray.count / 4 + 1) + 65;
    }
    
    UIButton *admitBtn = [YLBasicView createButton:KWHITECOLOR text:@"发布" backColor:IColor(220, 81, 171) cordius:17.5 font:PingFangSCFont(15)];
    admitBtn.frame = CGRectMake(App_Frame_Width/2. - 60., height, 120, 35);
    [YLTapGesture addTaget:self sel:@selector(admitBtnClicked:) view:admitBtn];
    [self.labelsRateBgView addSubview:admitBtn];
    
    //投诉按钮
    UIButton *tsBtn = [YLBasicView createButton:KWHITECOLOR text:@"投诉" backColor:IColor(220, 81, 171) cordius:17.5 font:PingFangSCFont(15)];
    tsBtn.frame = CGRectMake(App_Frame_Width/2. - 60., height+50, 120, 35);
    [YLTapGesture addTaget:self sel:@selector(tsBtnClicked:) view:tsBtn];
    [self.labelsRateBgView addSubview:tsBtn];
    
}

- (void)tsBtnClicked:(UIButton *)sender {
    [YLPushManager pushReportWithId:_godNessUserId];
}

- (void)admitBtnClicked:(UIButton *)sender
{
    NSString *labelStr = @"";
    if (idArray.count != 0) {
        for (NSString *ID  in idArray) {
            if (labelStr.length == 0) {
                labelStr = ID;
            }else{
                labelStr = [labelStr stringByAppendingString:[NSString stringWithFormat:@",%@",ID]];
            }
        }
    }
    
    
    dispatch_queue_t queue = dispatch_queue_create("评星", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        
        [YLNetworkInterface saveCommentUserId:[YLUserDefault userDefault].t_id coverCommUserId:self.godNessUserId commScore:self->commScore comment:@"" lables:labelStr block:^(BOOL isSuccess) {
            if (isSuccess) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self dismissViewControllerAnimated:NO completion:^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"starRateFinishNoti" object:nil];
//                    }];
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }
        }];
    });
}

#pragma mark ---- 评星
- (void)starRateSet
{
    XHStarRateView *starRateView3 = [[XHStarRateView alloc] initWithFrame:CGRectMake(20, 15, 200, 30) finish:^(CGFloat currentScore) {
        self->commScore = currentScore;
    }];
    starRateView3.currentScore = 5;
    commScore = 5;
    [self.starBgView addSubview:starRateView3];
}




@end
