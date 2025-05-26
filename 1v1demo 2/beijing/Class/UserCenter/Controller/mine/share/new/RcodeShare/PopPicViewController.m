//
//  PopPicViewController.m
//  beijing
//
//  Created by 黎 涛 on 2019/6/27.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "PopPicViewController.h"
#import "JT3DScrollView.h"
#import "ShareManager.h"
#import "ToolManager.h"
#import "ShareActionView.h"
#import "BaseView.h"

#define kWidthScale(value) value*App_Frame_Width/375.0//根据iPhone 8尺寸计算宽度比例
#define kHeightScale(value) value*APP_Frame_Height/667.0//根据iPhone 8尺寸计算高度比例

@interface PopPicViewController ()<UIScrollViewDelegate>
{
    JT3DScrollView *scrollView;
    NSArray *pictureArr;
    UIImageView *bgImageView;
    UIPageControl *pagePoint;
    int selectedIndex;
    NSMutableArray *imageViews;
}
@property (nonatomic, copy) NSString *shareUrl;

@end

@implementation PopPicViewController



#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"推广海报";
    imageViews = [NSMutableArray array];
//    [self loadPictureList];
    [self getSharePath];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - net
- (void)getSharePath {
//    [SVProgressHUD show];
//    [YLNetworkInterface getDomainnamepoolWithType:1 rewardId:@"0" dynamicId:@"0" Success:^(NSString *shareUrl) {
//        self.shareUrl = shareUrl;
//        [self loadPictureList];
//    }];
    
    NSString *shareUrl = (NSString *)[SLDefaultsHelper getSLDefaults:@"common_share_url"];
    _shareUrl = shareUrl;
    NSString *bgImageUrl = (NSString *)[SLDefaultsHelper getSLDefaults:@"common_share_bg_img_url"];
    pictureArr = [bgImageUrl componentsSeparatedByString:@","];
    if (pictureArr.count > 0) {
        [self setSubViews];
    }
}

- (void)loadPictureList {
//    [YLNetworkInterface getSpreedImgListSuccess:^(NSArray *dataArray) {
//        [SVProgressHUD dismiss];
//        self->pictureArr = dataArray;
//        if (self->pictureArr.count > 0) {
//            [self setSubViews];
//        }
//    }];
    
    
}

#pragma mark - subViews
- (void)setSubViews {
//    UIButton *backBtn = [UIManager initWithButton:CGRectMake(0, SafeAreaTopHeight-44, 44, 44) text:@"返回" font:15 textColor:UIColor.blackColor normalImg:@"AnthorDetail_back_black" highImg:nil selectedImg:nil];
//    [backBtn setImagePosition:0 spacing:5];
//    [backBtn addTarget:self action:@selector(backViewController) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight)];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.clipsToBounds = YES;
    [self.view addSubview:bgImageView];
    [bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",pictureArr[0]]]];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight)];
    bgView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:bgView];
    
    UIView *scrBg = [[UIView alloc] initWithFrame:CGRectMake(0, 10+SafeAreaTopHeight, App_Frame_Width, kHeightScale(480))];
    scrBg.clipsToBounds = YES;
    scrBg.backgroundColor = UIColor.clearColor;
    [self.view addSubview:scrBg];
    
    scrollView = [[JT3DScrollView alloc] initWithFrame:CGRectMake(kWidthScale(40), 0, App_Frame_Width-kWidthScale(80), kHeightScale(480))];
    scrollView.effect = JT3DScrollViewEffectDepth;
    scrollView.delegate = self;
    [scrollView setAutoresizesSubviews:YES];
    scrollView.contentSize = CGSizeMake(scrollView.width*pictureArr.count, scrollView.height);
    [scrBg addSubview:scrollView];
    if (@available(iOS 11.0, *))
    {
        [scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    pagePoint = [[UIPageControl alloc] initWithFrame:CGRectMake(kWidthScale(40), CGRectGetMaxY(scrBg.frame), scrollView.width, 30)];
    pagePoint.numberOfPages = pictureArr.count;
    pagePoint.pageIndicatorTintColor = UIColor.whiteColor;
    pagePoint.currentPageIndicatorTintColor = XZRGB(0xfe2947);
    [self.view addSubview:pagePoint];
    
    UIButton *shareBtn = [UIManager initWithButton:CGRectMake(kWidthScale(50), CGRectGetMaxY(pagePoint.frame), App_Frame_Width-kWidthScale(100), 40) text:@"分享我的海报" font:17 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    shareBtn.backgroundColor = XZRGB(0xfe2947);
    shareBtn.layer.masksToBounds = YES;
    shareBtn.layer.cornerRadius = 20;
    [shareBtn addTarget:self action:@selector(sharePicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    [self setScrollImage];
}

- (void)setScrollImage {
    NSString *idString = [NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id+10000];
    for(int i = 0; i < pictureArr.count; i ++) {
        UIImageView *bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(scrollView.frame.size.width * i, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        bannerImageView.clipsToBounds = YES;
        bannerImageView.layer.cornerRadius = 8;
//        NSString *activitiPicture = [pictureArr[i] objectForKey:@"t_img_path"];
        [bannerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",pictureArr[i]]]];
        
        UIImageView *QRCode = [[UIImageView alloc] initWithFrame:CGRectMake((bannerImageView.width-100)/2, bannerImageView.height-170, 100, 100)];
        QRCode.image = [ToolManager createQRCodeWithString:_shareUrl size:100];
        [bannerImageView addSubview:QRCode];
        
        UILabel *markL = [UIManager initWithLabel:CGRectMake(0, bannerImageView.height-70, bannerImageView.width, 30) text:@"--邀请码--" font:15 textColor:UIColor.whiteColor];
        [bannerImageView addSubview:markL];
        
        UILabel *idLabel = [UIManager initWithLabel:CGRectMake((bannerImageView.width-90)/2, bannerImageView.height-40, 90, 25) text:idString font:15 textColor:UIColor.whiteColor];
        idLabel.backgroundColor = [UIColor blackColor];
        idLabel.layer.masksToBounds = YES;
        idLabel.layer.cornerRadius = 12.5;
        [bannerImageView addSubview:idLabel];
        
        [scrollView addSubview:bannerImageView];
        [imageViews addObject:bannerImageView];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) /pageWidth) +1;
    [pagePoint setCurrentPage:page];
    selectedIndex = page;
    if (pictureArr.count > page) {
        [bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",pictureArr[page]]]];
    }
}

#pragma mark - func
- (void)sharePicture {
    if (imageViews.count > selectedIndex) {
        UIImageView *imageV = (UIImageView *)imageViews[selectedIndex];
        
        ShareActionView *shareView = [[ShareActionView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height) shareTitle:nil shareContent:nil shareImage:[ToolManager imageWithView:imageV] shareLink:_shareUrl];
        shareView.isShareImage = YES;
        [shareView show];
        
    }
}

- (void)backViewController {
    [self.navigationController popViewControllerAnimated:NO];
}


@end

