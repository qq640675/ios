//
//  ExplainViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/8/10.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "ExplainViewController.h"

@interface ExplainViewController ()

@end

@implementation ExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"玩法说明";
    [self setsubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setsubViews {
    // 375 1625
    CGFloat height = 1419*App_Frame_Width/375;
    UIScrollView *scro = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight)];
    scro.bounces = NO;
    scro.showsVerticalScrollIndicator = NO;
    scro.contentSize = CGSizeMake(App_Frame_Width, height);
    [self.view addSubview:scro];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, height)];
    imageView.image = [UIImage imageNamed:@"explainBtn"];
    [scro addSubview:imageView];
}


@end
