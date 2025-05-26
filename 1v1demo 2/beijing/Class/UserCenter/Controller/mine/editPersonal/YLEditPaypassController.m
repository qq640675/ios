//
//  YLEditPhoneController.m
//  beijing
//
//  Created by zhou last on 2018/8/17.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLEditPaypassController.h"
#import "YLNetworkInterface.h"
#import "YLValidExtension.h"
#import <SVProgressHUD.h>
#import "YLUserDefault.h"
#import "NSString+Extension.h"
#import "YLTapGesture.h"
#import "LoginVerificationView.h"
#import "XZTabBarController.h"

@interface YLEditPaypassController ()
{
    BOOL isHasPass;
}

@property (weak, nonatomic) IBOutlet UIButton *uploadBtn; //完成验证
@property (weak, nonatomic) IBOutlet UITextField *orgPassField;
@property (weak, nonatomic) IBOutlet UIView *orgLineView;
@property (weak, nonatomic) IBOutlet UITextField *nowPassField;
@property (weak, nonatomic) IBOutlet UIView *nowLineView;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassField;
@property (weak, nonatomic) IBOutlet UIView *confirmLineView;


@end

@implementation YLEditPaypassController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    isHasPass = NO;
    
    [self customUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark ---- customUI
- (void)customUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [YLTapGesture tapGestureTarget:self sel:@selector(hideKeyBoard) view:self.view];
    
    [YLNetworkInterface has_paypass:[YLUserDefault userDefault].t_id block:^(BOOL isSuccess) {
        if (isSuccess) {
            isHasPass = YES;
            
            self.orgPassField.hidden = NO;
            self.orgLineView.hidden = NO;
        }
        else
        {
            isHasPass = NO;
        }
    }];

}

#pragma mark ---- 隐藏键盘
- (void)hideKeyBoard
{
    [self.orgPassField resignFirstResponder];
    [self.nowPassField resignFirstResponder];
    [self.confirmPassField resignFirstResponder];
}


- (IBAction)uploadBtnClciked:(id)sender {
    if (isHasPass == YES)
    {
        if ([NSString isNullOrEmpty:self.orgPassField.text]) {
            [SVProgressHUD showInfoWithStatus:@"原密码不能为空"];
            return;
        }
    }
    
    if ([NSString isNullOrEmpty:self.nowPassField.text]) {
        [SVProgressHUD showInfoWithStatus:@"新密码不能为空"];
        return;
    }


    if ([NSString isNullOrEmpty:self.confirmPassField.text]) {
        [SVProgressHUD showInfoWithStatus:@"确认密码不能为空"];
        return;
    }
    
    if (![self.nowPassField.text isEqualToString:self.confirmPassField.text]) {
        [SVProgressHUD showInfoWithStatus:@"新密码与确认密码不一致"];
        return;
    }
    
    NSString *oldpass = @"";
    if (isHasPass == YES)
    {
        oldpass = self.orgPassField.text;
    }

    NSString *newpass = self.nowPassField.text;
    
    [YLNetworkInterface up_paypass:[YLUserDefault userDefault].t_id oldpass:oldpass newpass:newpass block:^(BOOL isSuccess) {
        if (isSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
