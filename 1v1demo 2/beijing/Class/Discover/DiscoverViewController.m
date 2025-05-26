//
//  DiscoverViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/7/26.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DiscoverViewController.h"
#import "YLAppointMentController.h"
#import "YLDynamicViewController.h"
#import "ChooseChatViewController.h"
#import "YLDynamicReleaseViewController.h"
#import <SPPageMenu.h>

@interface DiscoverViewController ()
<
UIScrollViewDelegate,
SPPageMenuDelegate
>

@property (nonatomic, copy) NSArray *pageMenuTitleArray;

@property (nonatomic, strong) NSMutableArray *myChildVCArray;

@property (nonatomic, strong) SPPageMenu *pageMenu;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

#pragma mark -- UI
- (void)setupUI {
    self.view.backgroundColor   = [UIColor whiteColor];
    
//    UIView *lineView = [UIView new];
//    lineView.backgroundColor = XZRGB(0xE7E7E7);
//    [self.view addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(SafeAreaTopHeight);
//        make.width.mas_equalTo(App_Frame_Width);
//        make.height.mas_equalTo(1);
//    }];
    
    [self initWithPageMenu];
}

- (void)initWithPageMenu {
    self.myChildVCArray = [NSMutableArray new];
    NSInteger selectedItemIndex = 0;
    selectedItemIndex = 0;
    self.pageMenuTitleArray = @[@"全部",@"同城",@"关注"];
    for (int i = 0; i < _pageMenuTitleArray.count; i++) {
        YLDynamicViewController *dynamicVC = [[YLDynamicViewController alloc] init];
        if (i == 1) {
            dynamicVC.isNear = YES;
        } else if (i == 2) {
            dynamicVC.isFollow = YES;
        }
        [self addChildViewController:dynamicVC];
        [_myChildVCArray addObject:dynamicVC];
    }
    
    self.pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, SafeAreaTopHeight-44, App_Frame_Width-50, 44) trackerStyle:SPPageMenuTrackerStyleLineAttachment];
    _pageMenu.dividingLine.hidden = YES;
    _pageMenu.selectedItemTitleColor   = XZRGB(0x3f3b48);
    _pageMenu.selectedItemTitleFont    = [UIFont boldSystemFontOfSize:24];
    _pageMenu.unSelectedItemTitleColor = XZRGB(0x3f3b48);
    _pageMenu.unSelectedItemTitleFont  = [UIFont systemFontOfSize:16.0f];
    _pageMenu.trackerWidth = 10;
    _pageMenu.trackerFollowingMode = SPPageMenuTrackerStyleRoundedRect;
    [_pageMenu setTrackerHeight:3 cornerRadius:1.5];
    _pageMenu.tracker.backgroundColor = XZRGB(0x3f3b48);
    _pageMenu.bridgeScrollView = self.scrollView;
    [self.view addSubview:_pageMenu];
    
    [_pageMenu setItems:_pageMenuTitleArray selectedItemIndex:selectedItemIndex];
    _pageMenu.delegate = self;
    _scrollView.contentOffset = CGPointMake(App_Frame_Width*_pageMenu.selectedItemIndex, 0);
    _scrollView.contentSize = CGSizeMake(_pageMenuTitleArray.count*App_Frame_Width, 0);
    [self.view addSubview:self.scrollView];
 
  
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self setrightButton];
}

-(void)setrightButton{
    
    [YLNetworkInterface index:[YLUserDefault userDefault].t_id block:^(personalCenterHandle *handle) {
        [YLUserDefault saveRole:handle.t_role];
        [YLUserDefault saveVip:handle.t_is_vip];
        [YLUserDefault saveCity:handle.t_city];
       
        if (handle.t_sex == 1){
            
            
            
        }else{
            UIButton *releaseBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-70, SafeAreaTopHeight-44, 70, 44) text:@"" font:14 textColor:XZRGB(0x333333) normalBackGroudImg:nil highBackGroudImg:nil selectedBackGroudImg:nil];
           
            [self.view addSubview:releaseBtn];
            [YLNetworkInterface getisPushDynamic:[handle.t_idcard intValue] :^(BOOL isSuccess) {
                
                if (!isSuccess){
                    [releaseBtn setHidden:NO];
//                    releaseBtn.titleLabel.text = ;
                    [releaseBtn setTitle:@"发布动态" forState:UIControlStateNormal];
                    [releaseBtn addTarget:self action:@selector(clickedReleaseBtnBtn) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [releaseBtn setHidden:YES];
                    [releaseBtn setTitle:@"" forState:UIControlStateNormal];
//                    [releaseBtn addTarget:self action:@selector(clickedReleaseBtnBtn) forControlEvents:UIControlEventTouchUpInside];
                }
                
            }];
            
            
            
        }
       
    }];
    
}


- (void)clickedReleaseBtnBtn {
    YLDynamicReleaseViewController *releaseVC = [[YLDynamicReleaseViewController alloc] init];
    [self.navigationController pushViewController:releaseVC animated:YES];
}

- (void)videoVC {
    YLAppointMentController *videoVC = [[YLAppointMentController alloc]initNav:self];
    [self addChildViewController:videoVC];
    [_myChildVCArray addObject:videoVC];
}

- (void)dynamicVC {
    YLDynamicViewController *dynamicVC = [[YLDynamicViewController alloc] init];
    [self addChildViewController:dynamicVC];
    [_myChildVCArray addObject:dynamicVC];
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
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight+1, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight-1)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return  _scrollView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
