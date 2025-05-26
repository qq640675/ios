//
//  LaunchAdvViewController.m
//  beijing
//
//  Created by 黎 涛 on 2019/8/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "LaunchAdvViewController.h"
#import <WebKit/WebKit.h>

@interface LaunchAdvViewController ()<WKNavigationDelegate>
{
    WKWebView *webView;
    UIButton *backButton;
}

@end

@implementation LaunchAdvViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setWebView];
    
    if (self.fromType == 0 || self.fromType == 2) {
        [self setbackButton];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - set subViews
- (void)setWebView {
    NSURL *url = [NSURL URLWithString:self.advUrl];
    webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    webView.navigationDelegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
    
    if (@available(iOS 11.0, *)) {
        [webView.scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

- (void)setbackButton {
    backButton = [UIButton buttonWithType:0];
    backButton.frame = CGRectMake(10, SafeAreaTopHeight-37, 30, 30);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:0];
    backButton.layer.masksToBounds = YES;
    backButton.layer.cornerRadius = 15;
    backButton.backgroundColor = XZRGB(0xe1e1e1);
    [backButton addTarget:self action:@selector(cancleAndGoBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [SVProgressHUD show];
    [self.view bringSubviewToFront:backButton];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [SVProgressHUD dismiss];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [SVProgressHUD showInfoWithStatus:@"加载失败"];
}

#pragma mark - func
- (void)cancleAndGoBack {
    if (self.fromType == 0) {
        if (webView.canGoBack == YES) {
            [webView goBack];
        } else {
            if (self.cancleBlock) {
                self.cancleBlock();
            }
        }
    } else if (self.fromType == 2) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
