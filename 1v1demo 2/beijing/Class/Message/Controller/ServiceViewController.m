//
//  ServiceViewController.m
//  beijing
//
//  Created by 黎 涛 on 2019/9/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "ServiceViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "LXTAlertView.h"

@interface ServiceViewController ()<WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation ServiceViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title =self.navTitle;
    [self setSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
#pragma mark - UI
- (void)setSubViews {
    if (self.urlStr == nil) {
        [LXTAlertView alertViewDefaultOnlySureWithTitle:@"提示" message:@"地址错误" sureHandle:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight) configuration:config];
    _webView.navigationDelegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:_webView];
    
    if (@available(iOS 11.0, *)) {
        [_webView.scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    WKUserContentController *userCC = config.userContentController;
    [userCC addScriptMessageHandler:self name:@"back"];
    
    
//    _backBtn = [UIManager initWithButton:CGRectMake(0, top, 44, 44) text:@"" font:1 textColor:nil normalImg:nil highImg:nil selectedImg:nil];
//    _backBtn.backgroundColor = UIColor.clearColor;
//    [_backBtn addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_backBtn];
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [SVProgressHUD show];
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
    [_backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:0];
    [SVProgressHUD showInfoWithStatus:@"加载失败"];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name caseInsensitiveCompare:@"back"] == NSOrderedSame) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - func
- (void)navBack {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
