//
//  LockOpenTempViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/11/14.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "LockOpenTempViewController.h"
#import "LockSettingViewController.h"

@interface LockOpenTempViewController ()

@end

@implementation LockOpenTempViewController

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
    
    UILabel *lb = [UIManager initWithLabel:CGRectZero text:@"为保护未成年健康成长，新游山特别推出未成年模式，该模式下可以禁止所有功能，如需使用，请设置密码保护。" font:15.0f textColor:XZRGB(0x868686)];
    lb.numberOfLines = 0;
    lb.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(10);
        make.right.equalTo(bgView).offset(-10);
        make.top.equalTo(tempImageView.mas_bottom).offset(25);
    }];
    
    UIButton *settingBtn = [UIManager initWithButton:CGRectZero text:@"设置未成年模式 >" font:15.0f textColor:XZRGB(0xAE4FFD) normalImg:nil highImg:nil selectedImg:nil];
    [settingBtn addTarget:self action:@selector(clickedSettingBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:settingBtn];
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(lb.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = XZRGB(0xebebeb);
    [bgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(bgView);
        make.bottom.equalTo(bgView).offset(-40);
        make.height.offset(1);
    }];
    
    UIButton *okBtn = [UIManager initWithButton:CGRectZero text:@"我知道了" font:16.0f textColor:[UIColor blackColor] normalImg:nil highImg:nil selectedImg:nil];
    [okBtn addTarget:self action:@selector(clickedOkBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(bgView);
        make.bottom.equalTo(bgView).offset(0);
        make.height.offset(40);
    }];
}

- (void)clickedOkBtn {
    [self removeFromSuperview];
}

- (void)clickedSettingBtn {
    
    UIViewController *curVC = [SLHelper getCurrentVC];
    
    LockSettingViewController *settingVC = [[LockSettingViewController alloc] init];
    
    [curVC.navigationController pushViewController:settingVC animated:YES];
    
    [self clickedOkBtn];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
