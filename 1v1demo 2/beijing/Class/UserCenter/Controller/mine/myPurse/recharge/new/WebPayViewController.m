//
//  WebPayViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/4/8.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "WebPayViewController.h"
#import <WebKit/WebKit.h>

@interface WebPayViewController ()
<
WKNavigationDelegate
>

@end

@implementation WebPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"支付";
    
    if (self.webUrl == nil) return;
    if (self.webUrl.length == 0 || [self.webUrl containsString:@"null"]) return;
    
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
        
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:_webUrl]];
    [webView loadRequest: request];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]];
//    [webView loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
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
    [SVProgressHUD showInfoWithStatus:@"加载失败"];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *currentUrl = navigationAction.request.URL.absoluteString;
    NSLog(@"_______%@",currentUrl);
    if ([currentUrl hasPrefix:@"weixin://"] || [currentUrl hasPrefix:@"alipays://platformapi"] || [currentUrl hasPrefix:@"alipay://alipayclient"]) {
        
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}


@end
