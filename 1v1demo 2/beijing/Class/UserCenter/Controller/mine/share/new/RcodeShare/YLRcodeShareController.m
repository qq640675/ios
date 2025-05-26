//
//  YLRcodeShareController.m
//  beijing
//
//  Created by zhou last on 2018/10/19.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLRcodeShareController.h"
#import <Masonry.h>
#import "DefineConstants.h"
#import "YLTapGesture.h"
#import <SVProgressHUD.h>
#import "YLUserDefault.h"
#import "DefineConstants.h"
#import "YLNetworkInterface.h"
#import "BaseView.h"
#import "ShareManager.h"
#import "ShareActionView.h"

@interface YLRcodeShareController ()

@property (weak,   nonatomic) IBOutlet UIImageView *bgImageView;

@property (strong, nonatomic) UIImageView *ewmImageView;

@end

@implementation YLRcodeShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"分享赚钱";
    
    [self codeCustomUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark ---- customUI
- (void)codeCustomUI {

    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    [self setupShareImage];

}

- (void)clickedRightBtn {
//    ShareActionView *shareView = [[ShareActionView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height) ShareTitle:@"【新游山】通过视频认识TA" shareContent:@"可以和附近人视频聊天的软件" logoImage:[UIImage imageNamed:@"logo60"] shareImage:[SLHelper imageWithView:_bgImageView]];
//    [self.view addSubview:shareView];
}



- (void)setupShareImage {
    
    NSString *bgImageUrl = (NSString *)[SLDefaultsHelper getSLDefaults:@"common_share_bg_img_url"];
    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:bgImageUrl]];
    self.ewmImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_bgImageView addSubview:_ewmImageView];
    CGFloat bottomGap = SafeAreaBottomHeight-49;
    [_ewmImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgImageView).offset(-10-bottomGap);
        make.right.mas_equalTo(self.bgImageView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(160, 160));
    }];
    
    NSString *shareUrl = (NSString *)[SLDefaultsHelper getSLDefaults:@"common_share_url"];
    _ewmImageView.image = [SLHelper getErweimaImageWithSize:App_Frame_Width link:shareUrl];
    
    
    UIButton *rightBtn = [UIManager initWithButton:CGRectMake(0, 0, 64, 44) text:@"立即分享" font:15.0f textColor:[UIColor blackColor] normalImg:nil highImg:nil selectedImg:nil];
    [rightBtn addTarget:self action:@selector(clickedRightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}



@end
