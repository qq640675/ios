//
//  VisitorViewController.m
//  beijing
//
//  Created by 黎 涛 on 2019/9/18.
//  Copyright © 2019 zhou last. All rights reserved.
//

// vc
#import "VisitorViewController.h"
#import "YLRechargeVipController.h"
// model
#import "WatchedModel.h"
// other
#import "ToolManager.h"
#import "LXTAlertView.h"
#import "UIButton+WebCache.h"

@interface VisitorViewController ()

@property (nonatomic, strong) UILabel *totelNumLabel;

@end

@implementation VisitorViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"谁看过我";
    self.view.backgroundColor = UIColor.whiteColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setSubViews];
    [self loadVisitorData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UI
- (void)setSubViews {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight)];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((App_Frame_Width-60)/2, 30, 60, 60)];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:_heagImageUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 30;
    [scrollView addSubview:headImageView];
    
    NSString *title = @"0人访问过你";
    self.totelNumLabel = [UIManager initWithLabel:CGRectMake(30, 95, App_Frame_Width-60, 30) text:title font:15 textColor:XZRGB(0x3f3b48)];
    [scrollView addSubview:self.totelNumLabel];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:XZRGB(0xff697c) range:NSMakeRange(0, title.length-5)];
    self.totelNumLabel.attributedText = attributedStr;
    
    
    CGFloat gap = (App_Frame_Width-150)/4;
    for (int i = 0; i < 9; i ++) {
//        UIButton *button = [UIManager initWithButton:CGRectMake(i%3*(App_Frame_Width/3), 160+(i/3)*110, App_Frame_Width/3, 100) text:@"" font:1 textColor:nil normalImg:nil highImg:nil selectedImg:nil];
        UIButton *button = [UIManager initWithButton:CGRectMake(gap+(gap+50)*(i%3), 160+(i/3)*90, 50, 50) text:@"" font:1 textColor:nil normalImg:nil highImg:nil selectedImg:nil];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 25;
        button.tag = 1000+i;
        [button setImage:[ToolManager blurImageWithImage:[UIImage imageNamed:@"default"]] forState:0];
        [button addTarget:self action:@selector(userHeadClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        button.hidden = YES;
        
//        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(gap, 0, 50, 50)];
//        headImageView.layer.masksToBounds = YES;
//        headImageView.layer.cornerRadius = 25;
//        headImageView.tag = 2000+i;
//        headImageView.image = [ToolManager blurImageWithImage:[UIImage imageNamed:@"default"]];
//        [button addSubview:headImageView];
        
        UILabel *timeLabel = [UIManager initWithLabel:CGRectMake(button.x-gap/2, button.y+50, button.width+gap, 30) text:@"2019-09-17" font:13 textColor:XZRGB(0x666666)];
        timeLabel.tag = 3000+i;
        [scrollView addSubview:timeLabel];
        timeLabel.hidden = YES;
        
        if (i == 8) {
            button.backgroundColor = XZRGB(0xebebeb);
            [button setImage:[UIImage imageNamed:@"AnthorDetail_more_black"] forState:0];
            timeLabel.text = @"更多...";
        }
    }
    
    UILabel *tipLabel_1 = [UIManager initWithLabel:CGRectMake(0, 470, App_Frame_Width, 20) text:@"开通VIP会员查看你访问的人" font:14 textColor:XZRGB(0x3f3b48)];
    [scrollView addSubview:tipLabel_1];
    
    UIButton *vipBtn = [UIManager initWithButton:CGRectMake(30, CGRectGetMaxY(tipLabel_1.frame)+15, App_Frame_Width-60, 55) text:@"立即开通" font:16 textColor:UIColor.whiteColor normalBackGroudImg:@"insufficient_coin_pay" highBackGroudImg:nil selectedBackGroudImg:nil];
    [vipBtn addTarget:self action:@selector(upgradeVIP) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:vipBtn];
    
    UILabel *tipLabel_2 = [UIManager initWithLabel:CGRectMake(0, CGRectGetMaxY(vipBtn.frame), App_Frame_Width, 20) text:@"自动反垃圾系统已为你清除部分不良用户" font:11 textColor:XZRGB(0x999999)];
    [scrollView addSubview:tipLabel_2];
    
    scrollView.contentSize = CGSizeMake(App_Frame_Width, CGRectGetMaxY(tipLabel_2.frame)+10);
}

#pragma mark - net
- (void)loadVisitorData {
    [SVProgressHUD show];
    [YLNetworkInterface getCoverBrowseListWithUserId:[NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id] page:1 Success:^(NSArray *dataArray, NSString *totelNum) {
        [SVProgressHUD dismiss];
        
        if (dataArray.count == 0) {
            return ;
        }
        NSString *title = [NSString stringWithFormat:@"%@人访问过你", totelNum];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:title];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:XZRGB(0xff697c) range:NSMakeRange(0, title.length-5)];
        self.totelNumLabel.attributedText = attributedStr;
        
        NSInteger number = 8;
        if (dataArray.count < 8) {
            number = dataArray.count;
        }
        for (int i = 0; i < number; i ++) {
            WatchedModel *model = dataArray[i];
            UIButton *button = [self.view viewWithTag:1000+i];
            button.hidden = NO;
            if (model.t_handImg.length > 0 && ![model.t_handImg containsString:@"null"]) {
                [button sd_setImageWithURL:[NSURL URLWithString:model.t_handImg] forState:0 placeholderImage:[ToolManager blurImageWithImage:[UIImage imageNamed:@"default"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [button setImage:[ToolManager blurImageWithImage:image] forState:0];
                }];
            }
           
            UILabel *label = [self.view viewWithTag:3000+i];
            label.hidden = NO;
            label.text = [ToolManager getTimeFromTimestamp:model.t_create_time formatStr:@"YYYY-MM-dd"];
        }
        if (dataArray.count > 8) {
            UIButton *button = [self.view viewWithTag:1008];
            button.hidden = NO;
            UILabel *label = [self.view viewWithTag:3008];
            label.hidden = NO;
        }
    } fail:^{
        [SVProgressHUD dismiss];
        
    }];
}

#pragma mark - func
- (void)userHeadClick:(UIButton *)sender {
    [LXTAlertView alertViewWithTitle:@"提示" message:@"开通VIP会员查看你访问的人" cancleTitle:@"暂不开通" sureTitle:@"立即开通" sureHandle:^{
        [self upgradeVIP];
    }];
}

- (void)upgradeVIP {
    [self.navigationController popViewControllerAnimated:NO];
    [YLPushManager pushVipWithEndTime:nil];
}


@end
