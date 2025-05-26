//
//  BigImageViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/1/15.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BigImageViewController.h"
// TIM 里面的一个库 用于查看大图  使用很方便
#import "ISVImageScrollView.h"

@interface BigImageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    
    ISVImageScrollView *imageScrollView = [[ISVImageScrollView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    imageScrollView.imageView.image = self.bigImage;
    [self.view addSubview:imageScrollView];
    
    self.imageView = [[UIImageView alloc] initWithImage:self.bigImage];
    imageScrollView.imageView = self.imageView;
    imageScrollView.maximumZoomScale = 4.0;
    imageScrollView.delegate = self;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, SafeAreaTopHeight)];
    blackView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.1];
    [self.view addSubview:blackView];
    UIButton *backBtn = [UIManager initWithButton:CGRectMake(0, SafeAreaTopHeight-44, 60, 44) text:@"返回" font:16 textColor:XZRGB(0x333333) normalImg:@"nav_back" highImg:nil selectedImg:nil];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [blackView addSubview:backBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
