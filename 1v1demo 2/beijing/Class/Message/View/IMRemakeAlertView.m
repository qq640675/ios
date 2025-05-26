//
//  IMRemakeAlertView.m
//  beijing
//
//  Created by 黎 涛 on 2020/11/18.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "IMRemakeAlertView.h"

@implementation IMRemakeAlertView
{
    UIView *bgView;
    UITextField *remakeTF;
    NSInteger friendId;
}

- (instancetype)initWithFriendIMId:(NSInteger)imId {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        friendId = imId;
        
        [self setSubViews];
        [self addNotification];
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
        
    }
    return self;
}

- (void)setSubViews {
    bgView = [[UIView alloc] initWithFrame:CGRectMake(40, (APP_Frame_Height-180)/2, App_Frame_Width-80, 180)];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 10;
    [self addSubview:bgView];
    
    UILabel *titleL = [UIManager initWithLabel:CGRectMake(0, 0, bgView.width, 50) text:@"设置备注" font:15 textColor:XZRGB(0x333333)];
    [bgView addSubview:titleL];
    
    remakeTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 70, bgView.width-60, 30)];
    remakeTF.borderStyle = UITextBorderStyleRoundedRect;
    remakeTF.placeholder = @"请输入好友备注名";
    remakeTF.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:remakeTF];
    
    CGFloat gap = (bgView.width-160)/3;
    UIButton *canclebtn = [UIManager initWithButton:CGRectMake(gap, bgView.height-45, 80, 30) text:@"取消" font:15 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
    canclebtn.layer.masksToBounds = YES;
    canclebtn.layer.cornerRadius = 15;
    canclebtn.layer.borderWidth = 1;
    canclebtn.layer.borderColor = XZRGB(0x333333).CGColor;
    [canclebtn addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:canclebtn];
    
    UIButton *sureBtn = [UIManager initWithButton:CGRectMake(80+gap*2, canclebtn.y, 80, 30) text:@"确定" font:15 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    sureBtn.backgroundColor = KDEFAULTCOLOR;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 15;
    [sureBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sureBtn];
}

- (void)cancleButtonClick {
    [self endEditing:YES];
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)sureButtonClick {
    if (remakeTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"备注不能为空"];
        return;
    }
    
    [self endEditing:YES];
    [[TIMFriendshipManager sharedInstance] modifyFriend:[NSString stringWithFormat:@"%ld", friendId] values:@{TIMFriendTypeKey_Remark : remakeTF.text} succ:^{
        if (self.setRemakeSuccess) {
            self.setRemakeSuccess(self->remakeTF.text);
        }
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        } fail:^(int code, NSString *msg) {
            if (code == 30001) {
                if (self.setRemakeSuccess) {
                    self.setRemakeSuccess(self->remakeTF.text);
                }
                [self removeFromSuperview];
            } else {
                [SVProgressHUD showInfoWithStatus:@"设置异常"];
            }
            NSLog(@"___im remake error: %d   %@", code, msg);
        }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self->bgView.y = (APP_Frame_Height-180)/2-100;
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self->bgView.y = (APP_Frame_Height-180)/2;
    }];
}


@end
