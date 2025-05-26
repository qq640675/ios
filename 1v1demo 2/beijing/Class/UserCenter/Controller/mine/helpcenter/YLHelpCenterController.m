//
//  YLHelpCenterController.m
//  beijing
//
//  Created by zhou last on 2018/6/21.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLHelpCenterController.h"
#import <Masonry.h>
#import <SVProgressHUD.h>
#import "YLNetworkInterface.h"
#import "WelcomeViewController.h"
#import "DefineConstants.h"
#import <WebKit/WebKit.h>

@interface YLHelpCenterController ()<WKNavigationDelegate>
{
    WKWebView *webView;
}

@end

@implementation YLHelpCenterController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (self.presentingViewController) {
        // 修改导航栏左边的item
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLogin)];;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight)];
       webView.navigationDelegate = self;
       
       [self.view addSubview:webView];
       
       if (@available(iOS 11.0, *)) {
           [webView.scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
       }
    

//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"userment" ofType:@"html"];
//    if (self.urlPath.length != 0) {
//        filePath = [[NSBundle mainBundle] pathForResource:self.urlPath ofType:@"html"];
//    }
//    NSString *path = [filePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//
//    NSURL *url = [[NSURL alloc] initWithString:path];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self->webView loadRequest:request];
    
    NSString *htmlTitle = @"userment";
    if (self.urlPath.length > 0) {
        htmlTitle = self.urlPath;
    }
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *basePath = [NSString stringWithFormat:@"%@",bundlePath];
    NSURL *baseUrl = [NSURL fileURLWithPath:basePath isDirectory:YES];
    NSString *indexPath = [NSString stringWithFormat:@"%@/%@.html",basePath, htmlTitle];
    NSString *indexContent = [NSString stringWithContentsOfFile:indexPath encoding:NSUTF8StringEncoding error:NULL];
    [webView loadHTMLString:indexContent baseURL:baseUrl];
}
                                                 
- (void)backToLogin
{
    if (self.fenghao.length == 0){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        WelcomeViewController *loginVC = [WelcomeViewController new];
        self.view.window.rootViewController = loginVC;
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [SVProgressHUD show];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [SVProgressHUD dismiss];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [SVProgressHUD showInfoWithStatus:@"加载失败"];
}



@end
