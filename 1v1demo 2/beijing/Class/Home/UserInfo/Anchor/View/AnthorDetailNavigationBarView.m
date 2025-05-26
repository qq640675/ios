//
//  AnthorDetailNavigationBarView.m
//  beijing
//
//  Created by yiliaogao on 2019/3/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "AnthorDetailNavigationBarView.h"

@implementation AnthorDetailNavigationBarView
//{
//    UIView *statusPoint;
//    UILabel *statusLabel;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.alpha = 0.0;
    [self addSubview:_bgView];
    
    self.nickNameLb = [UIManager initWithLabel:CGRectMake(70, SafeAreaTopHeight-44, App_Frame_Width-140, 44) text:@"昵称" font:20.0f textColor:XZRGB(0x333333)];
    [_bgView addSubview:_nickNameLb];
    
    self.backBtn = [UIManager initWithButton:CGRectMake(0, SafeAreaTopHeight-44, 60, 44) text:nil font:12.0f textColor:[UIColor whiteColor] normalImg:@"AnthorDetail_back" highImg:nil selectedImg:nil];
    [self.backBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];
    
    self.moreBtn = [UIManager initWithButton:CGRectMake(self.width-60, SafeAreaTopHeight-44, 60, 44) text:nil font:12.0f textColor:[UIColor whiteColor] normalImg:@"AnthorDetail_more" highImg:nil selectedImg:nil];
    [self addSubview:_moreBtn];
    
//    UIView *statusBGView = [[UIView alloc] initWithFrame:CGRectMake(App_Frame_Width-65, SafeAreaTopHeight-44+11, 50, 22)];
//    statusBGView.layer.masksToBounds = YES;
//    statusBGView.layer.cornerRadius = 11;
//    statusBGView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.3];
//    [self addSubview:statusBGView];
//
//    statusPoint = [[UIView alloc] initWithFrame:CGRectMake(7, 7, 8, 8)];
//    statusPoint.layer.masksToBounds = YES;
//    statusPoint.layer.cornerRadius = 4;
//    statusPoint.backgroundColor = XZRGB(0x868686);
//    [statusBGView addSubview:statusPoint];
//
//    statusLabel = [UIManager initWithLabel:CGRectMake(22, 0, 28, 22) text:@"离线" font:12 textColor:XZRGB(0x868686)];
//    statusLabel.textAlignment = NSTextAlignmentLeft;
//    [statusBGView addSubview:statusLabel];
}

- (void)backButtonClick {
    UIViewController *nowVC = [SLHelper getCurrentVC];
    [nowVC.navigationController popViewControllerAnimated:YES];
}

//- (void)setInfoHandle:(godnessInfoHandle *)infoHandle {
//    self.nickNameLb.text = infoHandle.t_nickName;
//
//    if (infoHandle.t_onLine == 0) {
//        statusLabel.text = @"在线";
//        statusPoint.backgroundColor = XZRGB(0x31df9b);
//        statusLabel.textColor = XZRGB(0x31df9b);
//    } else if (infoHandle.t_onLine == 1) {
//        statusLabel.text = @"在聊";
//        statusPoint.backgroundColor = XZRGB(0xfe2947);
//        statusLabel.textColor = XZRGB(0xfe2947);
//    } else {
//        statusLabel.text = @"离线";
//        statusPoint.backgroundColor = XZRGB(0x868686);
//        statusLabel.textColor = XZRGB(0x868686);
//    }
//}

@end
