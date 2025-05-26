//
//  YLCertifyNowController.m
//  beijing
//
//  Created by zhou last on 2018/10/28.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLCertifyNowController.h"
#import "YLEditPersonalController.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"

@interface YLCertifyNowController ()

@property (weak, nonatomic) IBOutlet UILabel *wechatCustomerLabel;
@property (weak, nonatomic) IBOutlet UIButton *inputPersonBtn;
@end

@implementation YLCertifyNowController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self getIdentificationWeiXin];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.inputPersonBtn.layer setCornerRadius:22.5];
    [self.inputPersonBtn setClipsToBounds:YES];
}


#pragma mark ---- 获取微信
- (void)getIdentificationWeiXin
{
    [YLNetworkInterface getIdentificationWeiXin:[YLUserDefault userDefault].t_id block:^(NSString *token) {
        self.wechatCustomerLabel.text = token;
    }];
}

#pragma mark ---- 编辑资料
- (IBAction)inputEditPersonVC:(id)sender {
//    YLEditPersonalController *editPersonalVC = [YLEditPersonalController new];
//    editPersonalVC.title = @"编辑资料";
//    [self.navigationController pushViewController:editPersonalVC animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
