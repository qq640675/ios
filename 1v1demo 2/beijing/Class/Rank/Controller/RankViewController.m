//
//  RankViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/5/21.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "RankViewController.h"
#import "RankListViewController.h"
#import <SPPageMenu.h>

@interface RankViewController ()<UIScrollViewDelegate,SPPageMenuDelegate>


@property (nonatomic, copy) NSArray *pageMenuTitleArray;
@property (nonatomic, strong) NSMutableArray *myChildVCArray;
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation RankViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setSubViews];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [YLNetworkInterface getSystemConfigAndSave];
}

#pragma mark - func
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setSubViews {
    self.myChildVCArray = [NSMutableArray new];
    NSInteger selectedItemIndex = 0;
    self.pageMenuTitleArray = @[@"魅力榜", @"邀请榜", @"富豪榜", @"守护榜"];
    for (int i = 0; i < _pageMenuTitleArray.count; i++) {
        NSString *title = self.pageMenuTitleArray[i];
        RankListViewController *nsVC = [[RankListViewController alloc] init];
        if ([title isEqualToString:@"魅力榜"]) {
            nsVC.rankType = RankListTypeGoddess;
        } else if ([title isEqualToString:@"富豪榜"]) {
            nsVC.rankType = RankListTypeConsume;
        }else if ([title isEqualToString:@"邀请榜"]) {
            nsVC.rankType = RankListTypeInvited;
        } else if ([title isEqualToString:@"守护榜"]) {
            nsVC.rankType = RankListTypeGuard;
        }
        nsVC.isShowBack = !self.isHideBack;
        [self addChildViewController:nsVC];
        [_myChildVCArray addObject:nsVC];
    }
    
    self.pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(44, SafeAreaTopHeight-44, App_Frame_Width-88, 44) trackerStyle:SPPageMenuTrackerStyleLineAttachment];
    _pageMenu.dividingLine.hidden = YES;
    _pageMenu.selectedItemTitleColor   = UIColor.whiteColor;
    _pageMenu.selectedItemTitleFont    = [UIFont boldSystemFontOfSize:22];
    _pageMenu.unSelectedItemTitleColor = UIColor.whiteColor;
    _pageMenu.unSelectedItemTitleFont  = [UIFont systemFontOfSize:16.0f];
    _pageMenu.trackerWidth = 10;
    _pageMenu.trackerFollowingMode = SPPageMenuTrackerStyleRoundedRect;
    [_pageMenu setTrackerHeight:3 cornerRadius:1.5];
    _pageMenu.tracker.backgroundColor = UIColor.whiteColor;
    _pageMenu.bridgeScrollView = self.scrollView;
    _pageMenu.spacing = 10;
    [self.view addSubview:_pageMenu];
    
    [_pageMenu setItems:_pageMenuTitleArray selectedItemIndex:selectedItemIndex];
    _pageMenu.delegate = self;
    _scrollView.contentOffset = CGPointMake(App_Frame_Width*_pageMenu.selectedItemIndex, 0);
    _scrollView.contentSize = CGSizeMake(_pageMenuTitleArray.count*App_Frame_Width, 0);
    [self.view addSubview:self.scrollView];
    
    if (self.isHideBack == NO) {
        UIButton *backBtn = [UIManager initWithButton:CGRectMake(0, SafeAreaTopHeight-44, 44, 44) text:@"" font:1 textColor:nil normalImg:@"AnthorDetail_back" highImg:nil selectedImg:nil];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
    }
    
    _pageMenu.backgroundColor = UIColor.clearColor;
    [self.view bringSubviewToFront:_pageMenu];
    
//    UIButton *awardBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-60, SafeAreaTopHeight-30, 60, 30) text:@"奖励说明" font:12 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
//    [awardBtn addTarget:self action:@selector(awardButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:awardBtn];
}

#pragma mark - func
- (void)awardButtonClick {
    NSDictionary *awardSetDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANKAWARDSETTING"];
    TextAlertView *alert = [[TextAlertView alloc] initWithTitle:@"奖励说明"];
    alert.textAlignment = NSTextAlignmentLeft;
    [alert setContentWithString:[NSString stringWithFormat:@"%@", awardSetDic[@"t_rank_award_rules"]]];
}

#pragma mark -- Delegate
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (!self.scrollView.isDragging) { // 判断用户是否在拖拽scrollView
        // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            [self.scrollView setContentOffset:CGPointMake(App_Frame_Width * toIndex, 0) animated:NO];
        } else {
            [self.scrollView setContentOffset:CGPointMake(App_Frame_Width * toIndex, 0) animated:YES];
        }
    }
    
    if (_myChildVCArray.count <= toIndex) {return;}
    
    UIViewController *targetViewController = _myChildVCArray[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(App_Frame_Width * toIndex, 0, App_Frame_Width, self.scrollView.height);
    [_scrollView addSubview:targetViewController.view];
}

#pragma mark -- Lazyload
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return  _scrollView;
}


@end
