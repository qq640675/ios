//
//  MessageHeaderView.m
//  beijing
//
//  Created by 黎 涛 on 2020/5/19.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MessageHeaderView.h"
#import "YLSearchController.h"
#import "YLMessageDetailController.h"
#import "YLConverseHistoryController.h"
#import "MansionInviteListViewController.h"
#import "YLPushManager.h"

@implementation MessageHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.frame = CGRectMake(0, 0, App_Frame_Width, 150);
        self.frame = CGRectMake(0, 0, App_Frame_Width, 55);
        self.backgroundColor = UIColor.whiteColor;
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    UIButton *searchBtn = [UIManager initWithButton:CGRectMake(15, 10, App_Frame_Width-30, 35) text:@"" font:1 textColor:nil normalImg:nil highImg:nil selectedImg:nil];
    searchBtn.backgroundColor = XZRGB(0xf2f3f7);
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 17.5;
    [searchBtn addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:searchBtn];
    
    UIImageView *searchLogo = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 15, 15)];
    searchLogo.image = [UIImage imageNamed:@"Dynamic_search"];
    [searchBtn addSubview:searchLogo];
    
    UILabel *searchTitle = [UIManager initWithLabel:CGRectMake(45, 0, 50, 35) text:@"搜索" font:15 textColor:XZRGB(0x666666)];
    searchTitle.textAlignment = NSTextAlignmentLeft;
    [searchBtn addSubview:searchTitle];
    
//    NSArray *imgArr = @[@"message_top_systrm", @"message_top_service", @"message_top_calllog"];
//    NSArray *titleArr = @[@"系统消息", @"在线客服", @"我的通话"];
////    NSArray *subTitleArr = @[@"最新消息显示", @"遇到问题咨询他", @"全部通话显示"];
////    if ([YLUserDefault userDefault].t_role == 1) {
////        imgArr = @[@"message_top_systrm", @"message_top_service", @"message_top_calllog", @"mansion_invitenot"];
////        titleArr = @[@"系统消息", @"在线客服", @"我的通话", @"府邸邀请"];
////    }
//    CGFloat width = App_Frame_Width/titleArr.count;
//    for (int i = 0; i < imgArr.count; i ++) {
//        UIButton *btn = [UIManager initWithButton:CGRectMake(width*i, 55, width, 80) text:titleArr[i] font:15 textColor:XZRGB(0x333333) normalImg:imgArr[i] highImg:nil selectedImg:nil];
//        btn.tag = 444+i;
//        [btn setImagePosition:2 spacing:5];
//        [btn addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btn];
//        
////        UILabel *subTitleL = [UIManager initWithLabel:CGRectMake(15, btn.height-7, btn.width-30, 20) text:subTitleArr[i] font:12 textColor:XZRGB(0x999999)];
////        subTitleL.tag = 666+i;
////        [btn addSubview:subTitleL];
//        
//        UILabel *redTagL = [UIManager initWithLabel:CGRectMake((btn.width)/2+20, 3, 20, 20) text:@"99+" font:10 textColor:UIColor.whiteColor];
//        redTagL.backgroundColor = XZRGB(0xfe2947);
//        redTagL.layer.masksToBounds = YES;
//        redTagL.layer.cornerRadius = redTagL.width/2;
//        redTagL.tag = 555+i;
//        redTagL.hidden = YES;
//        [btn addSubview:redTagL];
//    }
    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-5, self.width, 5)];
//    line.backgroundColor = XZRGB(0xf2f3f7);
//    [self addSubview:line];
}

- (void)searchButtonClick {
    UIViewController *nowVC = [SLHelper getCurrentVC];
    YLSearchController *searchVC = [YLSearchController new];
    [nowVC.navigationController pushViewController:searchVC animated:YES];
}

- (void)topButtonClick:(UIButton *)sender {
    UIViewController *nowVC = [SLHelper getCurrentVC];
    if (sender.tag == 444) {
        [self setSystemNum:0];
        YLMessageDetailController *msgDetailVC  = [YLMessageDetailController new];
        msgDetailVC.title = @"系统消息";
        [nowVC.navigationController pushViewController:msgDetailVC animated:YES];
    } else if (sender.tag == 445) {
        [YLPushManager pushService];
    } else if (sender.tag == 446) {
        YLConverseHistoryController *coversationVC = [YLConverseHistoryController new];
        coversationVC.title = @"我的通话";
        [nowVC.navigationController pushViewController:coversationVC animated:YES];
    } else if (sender.tag == 447) {
        // 府邸邀请
        MansionInviteListViewController *inviteListVC = [[MansionInviteListViewController alloc] init];
        [nowVC.navigationController pushViewController:inviteListVC animated:YES];
    }
}

- (void)setSystemNum:(int)systemNum {
    UILabel *tagL = [self viewWithTag:555];
    if (systemNum == 0) {
        tagL.hidden = YES;
    } else {
        tagL.hidden = NO;
        if (systemNum > 99) {
            tagL.text = @"99+";
        } else {
            tagL.text = [NSString stringWithFormat:@"%d", systemNum];
        }
    }
}

- (void)setSystemContent:(NSString *)systemContent {
    UILabel *contentL = [self viewWithTag:666];
    contentL.text = systemContent;
}

- (void)setMansionCount:(int)mansionCount {
    UILabel *tagL = [self viewWithTag:558];
    if (mansionCount == 0) {
        tagL.hidden = YES;
    } else {
        tagL.hidden = NO;
        if (mansionCount > 99) {
            tagL.text = @"99+";
        } else {
            tagL.text = [NSString stringWithFormat:@"%d", mansionCount];
        }
    }
}


@end
