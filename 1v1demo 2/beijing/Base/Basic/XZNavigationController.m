//
//  XZNavigationController.m
//  XZ_WeChat
//
//  Created by 郭现壮 on 16/9/27.
//  Copyright © 2016年 gxz. All rights reserved.
//

#import "XZNavigationController.h"
#import "DefineConstants.h"

@interface XZNavigationController ()

@end

@implementation XZNavigationController

+ (void)initialize
{
    [[UINavigationBar appearance]setTintColor:XZRGB(0x3c434d)];

    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = XZRGB(0x3c434d);
    textAttrs[NSFontAttributeName] = PingFangSCFont(15);
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];

//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -20) forBarMetrics:UIBarMetricsDefault];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    
//    [viewController.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"back"]];
//    [viewController.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
    
//    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
//    viewController.navigationController.navigationBar.tintColor = KWHITECOLOR;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    //设置backBarButtonItem即可
    viewController.navigationItem.backBarButtonItem = backItem;
    
    [super pushViewController:viewController animated:animated];
}

@end
