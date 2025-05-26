//
//  LockPwdTempView.m
//  beijing
//
//  Created by yiliaogao on 2019/11/14.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "LockPwdTempView.h"
#import "LockPwdViewController.h"
#import "YLEditPhoneController.h"

@implementation LockPwdTempView

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
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.clipsToBounds = YES;
    bgView.layer.cornerRadius = 5.0f;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(300, 340));
    }];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:IChatUImage(@"Lock_temp")];
    [bgView addSubview:tempImageView];
    [tempImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(bgView).offset(20);
    }];
    
    UILabel *lb = [UIManager initWithLabel:CGRectZero text:@"你已开启未成年模式，所有功能已关闭" font:15.0f textColor:XZRGB(0x868686)];
    lb.numberOfLines = 0;
    [bgView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(10);
        make.right.equalTo(bgView).offset(-10);
        make.top.equalTo(tempImageView.mas_bottom).offset(25);
    }];
    
    UIButton *settingBtn = [UIManager initWithButton:CGRectZero text:@"关闭未成年模式" font:15.0f textColor:XZRGB(0xAE4FFD) normalImg:nil highImg:nil selectedImg:nil];
    settingBtn.clipsToBounds = YES;
    settingBtn.layer.cornerRadius = 20.0f;
    settingBtn.layer.borderWidth = 1.0f;
    settingBtn.layer.borderColor = XZRGB(0xAE4FFD).CGColor;
    [settingBtn addTarget:self action:@selector(clickedSettingBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:settingBtn];
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(lb.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = XZRGB(0xebebeb);
    [bgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(bgView);
        make.bottom.equalTo(bgView).offset(-40);
        make.height.offset(1);
    }];
    
    UIButton *okBtn = [UIManager initWithButton:CGRectZero text:@"忘记密码" font:16.0f textColor:[UIColor blackColor] normalImg:nil highImg:nil selectedImg:nil];
    [okBtn addTarget:self action:@selector(clickedOkBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(bgView);
        make.bottom.equalTo(bgView).offset(0);
        make.height.offset(40);
    }];
}

- (void)clickedOkBtn {
    UIViewController *curVC = [SLHelper getCurrentVC];
    
    YLEditPhoneController *vc = [[YLEditPhoneController alloc] init];
    vc.navigationItem.title = @"验证码解锁";
    vc.isLock = YES;
    [curVC.navigationController pushViewController:vc animated:YES];

}

- (void)clickedSettingBtn {
    
    UIViewController *curVC = [SLHelper getCurrentVC];
    LockPwdViewController *vc = [[LockPwdViewController alloc] init];
    [curVC.navigationController pushViewController:vc animated:YES];
}

@end
