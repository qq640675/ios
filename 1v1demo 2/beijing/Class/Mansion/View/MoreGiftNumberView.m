//
//  MoreGiftNumberView.m
//  beijing
//
//  Created by 黎 涛 on 2021/4/15.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "MoreGiftNumberView.h"

@implementation MoreGiftNumberView
{
    UIView *bgView;
    UITextField *numberTF;
}

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.2];
        [self setSubViews];
        [self addNotification];
    }
    return self;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

#pragma mark - not
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self->bgView.y = (APP_Frame_Height-235)/2-100;
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self->bgView.y = (APP_Frame_Height-235)/2;
    }];
}

#pragma mark - sunViews
- (void)setSubViews {
    bgView = [[UIView alloc] initWithFrame:CGRectMake((App_Frame_Width-310)/2, (APP_Frame_Height-235)/2, 310, 235)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 10;
    bgView.backgroundColor = UIColor.whiteColor;
    [self addSubview:bgView];
    
    UILabel *titleLabel = [UIManager initWithLabel:CGRectMake(40, 0, bgView.width-80, 50) text:@"其他数量" font:18 textColor:XZRGB(0x333333)];
    [bgView addSubview:titleLabel];
    
    UIView *tfBGView = [[UIView alloc] initWithFrame:CGRectMake(15, 85, bgView.width-30, 45)];
    tfBGView.backgroundColor = XZRGB(0xf2f3f7);
    tfBGView.layer.masksToBounds = YES;
    tfBGView.layer.cornerRadius = 4;
    [bgView addSubview:tfBGView];
    
    numberTF = [[UITextField alloc] initWithFrame:CGRectMake(7.5, 7.5, tfBGView.width-15, 30)];
    numberTF.textColor = XZRGB(0x868686);
    numberTF.placeholder = @"请输入礼物个数";
    numberTF.keyboardType = UIKeyboardTypeNumberPad;
    [tfBGView addSubview:numberTF];
    
    CGFloat gap = (bgView.width-180)/3;
    UIButton *cancleBtn = [UIManager initWithButton:CGRectMake(gap, bgView.height-35-18, 90, 35) text:@"取消" font:18 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
    cancleBtn.backgroundColor = XZRGB(0xf2f3f7);
    cancleBtn.layer.masksToBounds = YES;
    cancleBtn.layer.cornerRadius = 17.5;
    [cancleBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancleBtn];
    
    UIButton *sureBtn = [UIManager initWithButton:CGRectMake(gap*2+90, bgView.height-35-18, 90, 35) text:@"确定" font:18 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    sureBtn.backgroundColor = [XZRGB(0xae4ffd) colorWithAlphaComponent:0.72];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 17.5;
    [sureBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sureBtn];
}

- (void)remove {
    [self endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFromSuperview];
}

- (void)sureButtonClick {
    [self remove];
    if (self.sureButtonClickBlock) {
        self.sureButtonClickBlock([numberTF.text intValue]);
    }
}



@end
