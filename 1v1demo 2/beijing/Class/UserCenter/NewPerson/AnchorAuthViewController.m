//
//  AnchorAuthViewController.m
//  beijing
//
//  Created by 黎 涛 on 2021/4/8.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "AnchorAuthViewController.h"
#import "YLEditPersonalController.h"
#import "YLNCertifyController.h"
#import "YLCertifyNowController.h"

@interface AnchorAuthViewController ()
{
    UIButton *infoBtn;
    UIButton *authBtn;
    int certificationStatus;
}

@end

@implementation AnchorAuthViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"完成认证";
    [self setSubViews];
//    [self requestStatus];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self requestStatus];
}

#pragma mark - net
- (void)requestStatus {
    [YLNetworkInterface getcertifyStatusSuccess:^(NSDictionary *dataDic) {
        int userDataStatus = [[NSString stringWithFormat:@"%@", dataDic[@"userDataStatus"]] intValue];
        self->certificationStatus = [[NSString stringWithFormat:@"%@", dataDic[@"certificationStatus"]] intValue];
        if (userDataStatus == 1) {
            [self setButtonUnEnable:self->infoBtn enable:NO title:@"已完善"];
            
            if (self->certificationStatus == 0) {
                [self setButtonUnEnable:self->authBtn enable:YES title:@"去认证"];
            } else if (self->certificationStatus == 1) {
                [self setButtonUnEnable:self->authBtn enable:NO title:@"已认证"];
            } else if (self->certificationStatus == 2) {
                [self setButtonUnEnable:self->authBtn enable:YES title:@"审核中"];
            }
        } else {
            [self setButtonUnEnable:self->infoBtn enable:YES title:@"去完善"];
            
            [self setButtonUnEnable:self->authBtn enable:NO title:@"去认证"];
        }
    }];
}

#pragma mark - subViews
- (void)setSubViews {
    infoBtn = [self authItemViewWithY:25 image:@"auth_info" title:@"第一步：完善资料" subTitle:@"必须完善资料才能拍照认证。" btnTitle:@"去完善"];
    [infoBtn addTarget:self action:@selector(infoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    authBtn = [self authItemViewWithY:145 image:@"auth_img" title:@"第二步：拍照认证" subTitle:@"必须是本人自拍才能通过" btnTitle:@"去认证"];
    [authBtn addTarget:self action:@selector(authButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)authItemViewWithY:(CGFloat)y image:(NSString *)image title:(NSString *)title subTitle:(NSString *)subTitle btnTitle:(NSString *)btnTitle {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8, y, App_Frame_Width-16, 100)];
    view.backgroundColor = UIColor.whiteColor;
    view.layer.cornerRadius = 6;
    view.layer.shadowColor = XZRGB(0xc3c3c3).CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowOpacity = 0.3;
    view.layer.shadowRadius = 4;
    [self.view addSubview:view];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(18, 27, 46, 46)];
    icon.image = [UIImage imageNamed:image];
    [view addSubview:icon];
    
    UILabel *titleL = [UIManager initWithLabel:CGRectMake(75, 25, view.width-75-90, 25) text:title font:18 textColor:XZRGB(0x2f2f2f)];
//    titleL.font = [UIFont boldSystemFontOfSize:18];
    titleL.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleL];
    
    UILabel *subTitleL = [UIManager initWithLabel:CGRectMake(75, 50, titleL.width, 25) text:subTitle font:14 textColor:XZRGB(0x999999)];
    subTitleL.textAlignment = NSTextAlignmentLeft;
    [view addSubview:subTitleL];
    
    UIButton *btn = [UIManager initWithButton:CGRectMake(view.width-86, 35, 66, 30) text:btnTitle font:12 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    btn.backgroundColor = XZRGB(0xC580FE);
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = btn.height/2;
    [view addSubview:btn];
    return btn;
}

- (void)setButtonUnEnable:(UIButton *)sender enable:(BOOL)enable title:(NSString *)title {
    [sender setTitle:title forState:0];
    sender.userInteractionEnabled = enable;
    if (enable) {
        sender.backgroundColor = XZRGB(0xC580FE);
        [sender setTitleColor:UIColor.whiteColor forState:0];
    } else {
        sender.backgroundColor = XZRGB(0xF2F3F7);
        [sender setTitleColor:XZRGB(0x999999) forState:0];
    }
}

#pragma mark - func
- (void)infoButtonClick:(UIButton *)sender {
    YLEditPersonalController *editPersonalInfoVC = [YLEditPersonalController new];
    editPersonalInfoVC.title = @"编辑资料";
    [self.navigationController pushViewController:editPersonalInfoVC animated:YES];
}

- (void)authButtonClick:(UIButton *)sender {
    if (certificationStatus == 0) {
        YLNCertifyController *applyCertificationVC = [YLNCertifyController new];
        applyCertificationVC.title = @"申请认证";
        [self.navigationController pushViewController:applyCertificationVC animated:YES];
    } else if (certificationStatus == 2) {
        YLCertifyNowController *CertifyNowVC = [YLCertifyNowController new];
        CertifyNowVC.title = @"主播资料审核中";
        [self.navigationController pushViewController:CertifyNowVC animated:YES];
    }
}


@end
