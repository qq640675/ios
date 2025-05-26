//
//  MessageHandleOptionsView.m
//  beijing
//
//  Created by 黎 涛 on 2021/3/25.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "MessageHandleOptionsView.h"
#import "TUILocalStorage.h"

@implementation MessageHandleOptionsView

#pragma mark - init
- (instancetype)initWithId:(NSInteger)userId covId:(NSString *)covId isFollow:(BOOL)isFollow sex:(int)sex {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        self.backgroundColor = UIColor.clearColor;
        self.userId = userId;
        self.covId = covId;
        self.isFollow = isFollow;
        self.sex = sex;
        self.isTop = NO;
        if ([[[TUILocalStorage sharedInstance] topConversationList] containsObject:self.covId]) {
            self.isTop = YES;
        }
        [self setSubViews];
    }
    return self;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (void)remove {
    [self removeFromSuperview];
}

#pragma mark - subViews
- (void)setSubViews {
    UIView *tapV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    tapV.backgroundColor = UIColor.clearColor;
    [self addSubview:tapV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
    [tapV addGestureRecognizer:tap];
    
    NSArray *titles = @[@"加入黑名单", @"消息置顶", @"关注", @"投诉", @"修改备注", @"查看主页"];
    CGFloat btnWidth = 90;
    CGFloat btnHeight = 30;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(App_Frame_Width-btnWidth-5, SafeAreaTopHeight+5, btnWidth, btnHeight*titles.count)];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    [self addSubview:bgView];
    
    for (int i = 0; i < titles.count; i ++) {
        UIButton *btn = [UIManager initWithButton:CGRectMake(0, btnHeight*i, btnWidth, btnHeight) text:titles[i] font:14 textColor:XZRGB(0x666666) normalImg:nil highImg:nil selectedImg:nil];
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        if (i == 1) {
            self.topBtn = btn;
            [self.topBtn setTitle:@"取消置顶" forState:UIControlStateSelected];
            self.topBtn.selected = self.isTop;
        } else if (i == 2) {
            self.followBtn = btn;
            [self.followBtn setTitle:@"取消关注" forState:UIControlStateSelected];
            self.followBtn.selected = self.isFollow;
        }
        if (i != 0) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, btnHeight*i, btnWidth, 1)];
            line.backgroundColor = XZRGB(0xebebeb);
            [bgView addSubview:line];
        }
    }
}

#pragma mark - func
- (void)buttonClick:(UIButton *)sender {
    NSInteger index = sender.tag-1000;
    if (index == 0) {
        //黑名单
        [self addBlackList];
    } else if (index == 1) {
        //置顶
        [self topButtonClick];
    } else if (index == 2) {
        //关注
        [self followButtonClick];
    } else if (index == 3) {
        //投诉
        [YLPushManager pushReportWithId:self.userId];
    } else if (index == 4) {
        //备注
        [self remarkButtonClick];
    } else if (index == 5) {
        //主页
        [YLPushManager pushAnchorDetail:self.userId];
    }
    [self remove];
}

- (void)addBlackList {
    [SVProgressHUD show];
    [YLNetworkInterface addBlackUserWithId:[NSString stringWithFormat:@"%ld", (long)self.userId] success:^{
        [SVProgressHUD showSuccessWithStatus:@"操作成功"];
    }];

}

- (void)followButtonClick {
    if (self.sex == [YLUserDefault userDefault].t_sex) {
        [SVProgressHUD showInfoWithStatus:@"暂未开放同性用户交流"];
        return;
    }
    if (self.followBtn.selected == NO) {
        [self follow];
    } else {
        [self cancleFollow];
    }
}

- (void)follow {
    WEAKSELF
    [YLNetworkInterface addAttention:[YLUserDefault userDefault].t_id coverFollowUserId:(int)self.userId block:^(BOOL isSuccess) {
        if (isSuccess) {
            self.followBtn.selected = YES;
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            if (weakSelf.followButtonClickBlock) {
                weakSelf.followButtonClickBlock(1);
            }
        }
    }];
}

- (void)cancleFollow {
    WEAKSELF
    [YLNetworkInterface cancelAtttention:[YLUserDefault userDefault].t_id coverFollowUserId:(int)self.userId  block:^(BOOL isSuccess) {
        if (isSuccess) {
            self.followBtn.selected = NO;
            [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            if (weakSelf.followButtonClickBlock) {
                weakSelf.followButtonClickBlock(0);
            }
        }
    }];
}

- (void)topButtonClick {
    if (!self.topBtn.selected) {
        [[TUILocalStorage sharedInstance] addTopConversation:_covId];
    } else {
        [[TUILocalStorage sharedInstance] removeTopConversation:_covId];
    }
}

- (void)remarkButtonClick {
    if (self.remarkButtonClickBlock) {
        self.remarkButtonClickBlock();
    }
}


@end
