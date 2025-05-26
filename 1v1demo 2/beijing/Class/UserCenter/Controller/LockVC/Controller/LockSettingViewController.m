//
//  LockSettingViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/11/14.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "LockSettingViewController.h"
#import "LockSettingPwdViewController.h"
#import "YLEditPhoneController.h"

@interface LockSettingViewController ()

@end

@implementation LockSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"未成年模式";
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)clickedOpenBtn:(id)sender {
    //先判断用户是否已经绑定手机
    if ([YLUserDefault userDefault].phone.length > 0) {
        LockSettingPwdViewController *vc = [[LockSettingPwdViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [SVProgressHUD showInfoWithStatus:@"请先绑定手机"];
        YLEditPhoneController *vc = [[YLEditPhoneController alloc] init];
        vc.navigationItem.title = @"绑定手机";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
