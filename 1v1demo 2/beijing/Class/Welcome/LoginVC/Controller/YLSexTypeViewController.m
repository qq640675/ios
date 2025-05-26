//
//  YLSexTypeViewController.m
//  beijing
//
//  Created by zhou last on 2018/7/23.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLSexTypeViewController.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "YLJsonExtension.h"
#import "XZTabBarController.h"
#import "DefineConstants.h"
#import <SVProgressHUD.h>

@interface YLSexTypeViewController ()<UITextFieldDelegate>
{
    int sexType;
}

@property (weak, nonatomic) IBOutlet UIButton *womanButton;
@property (weak, nonatomic) IBOutlet UIButton *manButton;


@end

@implementation YLSexTypeViewController

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    sexType = -1;
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"-1" forKey:@"t_sex"];
    
    [YLNetworkInterface getRefereeSuccess:^(int resultCode) {
        if (resultCode == -1) {
            self.invitiLabel.hidden = NO;
            self.invitiTextField.hidden = NO;
        }
    }];
}

#pragma mark ---- 女
- (IBAction)womomButtonBeClicked:(id)sender {
    [self sexTypeSel:[(UIButton *)sender tag]];
}

#pragma mark ---- 男
- (IBAction)manButtonBeClicked:(id)sender {
    [self sexTypeSel:[(UIButton *)sender tag]];
}


- (void)sexTypeSel:(NSInteger)tag {
    if (tag == 100) {
        sexType = 0;
        [self.womanButton setImage:IChatUImage(@"sex_woman") forState:UIControlStateNormal];
        [self.manButton setImage:IChatUImage(@"sex_man_nosel") forState:UIControlStateNormal];
    }else{
        sexType = 1;
        [self.womanButton setImage:IChatUImage(@"sex_woman_nosel") forState:UIControlStateNormal];
        [self.manButton setImage:IChatUImage(@"sex_man") forState:UIControlStateNormal];
    }
}


#pragma mark ----- 返回
- (IBAction)backButtonBeClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

// 只能输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}

#pragma mark ----- 确定
- (IBAction)loginOKButtonBeClicked:(id)sender {
    if (sexType == -1) {
        [SVProgressHUD showErrorWithStatus:@"请选择性别！"];
        return;
    }
    
    if (self.invitiTextField.text.length > 8) {
        [SVProgressHUD showInfoWithStatus:@"请填写小于8位数的邀请码"];
        return;
    }
    
    [YLNetworkInterface upateUserSex:[YLUserDefault userDefault].t_id sex:self->sexType idCard:self.invitiTextField.text block:^(BOOL isSuccess) {
        if (isSuccess) {
            [YLPushManager pushMainPage];
        }
    }];
}


@end
