//
//  NearViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/5/14.
//  Copyright © 2020 zhou last. All rights reserved.
//

// vc
#import "NearViewController.h"

// view
#import "NearTableViewCell.h"
#import "HomeSendMessageAlertView.h"

// other
#import "YLPushManager.h"
#import "LXTAlertView.h"
#import <MJRefresh.h>
#import <CoreLocation/CoreLocation.h>

@interface NearViewController ()<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
{
    UITableView *nearTableView;
    int nPage; //页码
    NSMutableArray *nearListArray; //数据
    
    BOOL isLoc;
    CLLocationManager *locManager;//位置
    double currentLatitude;//经度
    double currentLongitude;//纬度
    
}

@property (nonatomic, strong) UIView *noVipView;
@property (nonatomic, strong) UIButton *groupAnimationBtn;
@property (nonatomic, strong) UIButton *groupBtn;

@end

@implementation NearViewController

#pragma amrk - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;

    nearListArray = [NSMutableArray array];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    isLoc = NO;
    
    [self setSubViews];
    
    if (self.isBoyUser == YES) {
        [self requestOnlineFansIsRefresh:YES];
    }
    
    [self addNoVipView];
    [self groupMessageButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (self.isBoyUser == NO) {
        if (isLoc == NO) {
            [self startLocation];
        }
    }
}

#pragma mark - 群发
- (void)groupMessageButton {
    if (self.isBoyUser && [YLUserDefault userDefault].t_role == 1) {
        self.groupAnimationBtn = [UIManager initWithButton:CGRectMake(APP_FRAME_WIDTH - 103, APP_FRAME_HEIGHT-SafeAreaBottomHeight-160-NAVIGATIONBAR_HEIGHT, 103, 53) text: nil font:16 textColor:XZRGB(0x333333) normalImg:@"NewHomePage_group_msg" highImg:nil selectedImg:nil];
                [self.view addSubview:_groupAnimationBtn];
                
        self.groupBtn = [UIManager initWithButton:CGRectMake(APP_FRAME_WIDTH - 103, APP_FRAME_HEIGHT-SafeAreaBottomHeight-160-NAVIGATIONBAR_HEIGHT, 103, 53) text: nil font:16 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
        [_groupBtn addTarget:self action:@selector(clickedGroupBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_groupBtn];
                
                [self addGroupBtnAnimation];
    }
}

- (void)clickedGroupBtn {
    [YLNetworkInterface getIMToUserMesListSuccess:^(NSArray *msgArray) {
        if (msgArray.count == 0) return;
            
        HomeSendMessageAlertView *alertView = [[HomeSendMessageAlertView alloc] initWithMessageArray:msgArray];
        [alertView show];
    }];
}

- (void)addGroupBtnAnimation {
    
    [UIView animateWithDuration:.6 animations:^{
        self.groupAnimationBtn.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {

        [UIView animateWithDuration:.6 animations:^{
            self.groupAnimationBtn.transform = CGAffineTransformIdentity;
            
        }];
        [self performSelector:@selector(addGroupBtnAnimation) withObject:nil afterDelay:.6];
        
    }];
}

#pragma mark - addNoVipView
- (void)addNoVipView {
    if ([YLUserDefault userDefault].t_is_vip == 0 || [YLUserDefault userDefault].t_role == 1 || _isBoyUser) {
        return;
    }
    self.noVipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight-SafeAreaBottomHeight+10)];
    _noVipView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_noVipView];
    
    UILabel *labbel = [UIManager initWithLabel:CGRectMake(0, _noVipView.height/2-60, App_Frame_Width, 30) text:@"VIP用户才能使用同城功能哦~" font:17 textColor:XZRGB(0x333333)];
    [_noVipView addSubview:labbel];
    
    UIButton *vipBtn = [UIManager initWithButton:CGRectMake((_noVipView.width-120)/2, CGRectGetMaxY(labbel.frame)+10, 120, 36) text:@"立即升级" font:18 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    vipBtn.backgroundColor = XZRGB(0xfe2947);
    vipBtn.layer.masksToBounds = YES;
    vipBtn.layer.cornerRadius = 18;
    [vipBtn addTarget:self action:@selector(rechargeVIP) forControlEvents:UIControlEventTouchUpInside];
    [_noVipView addSubview:vipBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedVip) name:@"CHANGEDVIP" object:nil];
}

- (void)rechargeVIP {
    [YLPushManager pushVipWithEndTime:nil];
}

- (void)changedVip {
    if (_noVipView) {
        [_noVipView removeFromSuperview];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHANGEDVIP" object:nil];
}

#pragma mark - net
- (void)getNearListIsRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        nPage = 1;
    } else {
        nPage ++;
    }
    [SVProgressHUD show];
    [YLNetworkInterface getAnthorDistanceListUserd:[YLUserDefault userDefault].t_id page:nPage lat:currentLatitude lng:currentLongitude block:^(NSMutableArray *listArray) {
        [SVProgressHUD dismiss];
        [self->nearTableView.mj_header endRefreshing];
        [self->nearTableView.mj_footer endRefreshing];
        if (listArray == nil) {
            self->nPage --;
            return ;
        }
        if ([listArray count] < 10) {
            self->nearTableView.mj_footer.state = MJRefreshStateNoMoreData;
            [self->nearTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self->nPage == 1) {
            self->nearListArray = [NSMutableArray arrayWithArray:listArray];
        } else {
            [self->nearListArray addObjectsFromArray:listArray];
        }
        
        [self->nearTableView reloadData];
    }];
}

- (void)requestOnlineFansIsRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        nPage = 1;
    } else {
        nPage ++;
    }
    [SVProgressHUD show];
    [YLNetworkInterface getOnLineUserList:[YLUserDefault userDefault].t_id page:nPage searchType:![YLUserDefault userDefault].t_sex search:@"" block:^(NSMutableArray *listArray) {
        [SVProgressHUD dismiss];
        [self->nearTableView.mj_header endRefreshing];
        [self->nearTableView.mj_footer endRefreshing];
        if (listArray == nil) {
            self->nPage --;
            return ;
        }
        if ([listArray count] < 10) {
            self->nearTableView.mj_footer.state = MJRefreshStateNoMoreData;
            [self->nearTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self->nPage == 1) {
            self->nearListArray = [NSMutableArray arrayWithArray:listArray];
        } else {
            [self->nearListArray addObjectsFromArray:listArray];
        }
        
        [self->nearTableView reloadData];
    }];
}

#pragma mark - subViews
- (void)setSubViews {
    nearTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight) style:UITableViewStylePlain];
    nearTableView.backgroundColor = [UIColor whiteColor];
    nearTableView.tableFooterView = [UIView new];
    nearTableView.dataSource = self;
    nearTableView.delegate = self;
    nearTableView.rowHeight = 100;
    [nearTableView registerClass:[NearTableViewCell class] forCellReuseIdentifier:@"nearCell"];
    [self.view addSubview:nearTableView];
    
    WEAKSELF;
    nearTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isBoyUser == YES) {
            [weakSelf requestOnlineFansIsRefresh:YES];
        } else {
            [weakSelf getNearListIsRefresh:YES];
        }
    }];
    
    nearTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.isBoyUser == YES) {
            [weakSelf requestOnlineFansIsRefresh:NO];
        } else {
            [weakSelf getNearListIsRefresh:NO];
        }
    }];
}

#pragma mark - UITableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return nearListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NearTableViewCell *nearCell = [tableView dequeueReusableCellWithIdentifier:@"nearCell"];
    if (self.isBoyUser == YES) {
        nearCell.isBoyUser = YES;
        [nearCell setFansHandle:nearListArray[indexPath.row]];
    } else {
        nearCell.isBoyUser = NO;
        [nearCell setNearHandle:nearListArray[indexPath.row]];
    }
    return nearCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark ---- 开始定位
- (void)startLocation {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        locManager = [[CLLocationManager alloc] init];
        locManager.delegate = self;
        locManager.desiredAccuracy= kCLLocationAccuracyBest;
        [locManager requestWhenInUseAuthorization];
    } else if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        locManager = [[CLLocationManager alloc] init];
        locManager.delegate = self;
        locManager.desiredAccuracy= kCLLocationAccuracyBest;
    }else{
        [LXTAlertView alertViewDefaultWithTitle:@"温馨提示" message:@"定位服务未开启，请进入系统【设置】>【隐私】>【定位服务】中打开开关" sureHandle:^{
            [NSString openScheme:UIApplicationOpenSettingsURLString];
        }];
    }

    [locManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [manager stopUpdatingLocation];
    
    CLLocation *currentLocation = [locations lastObject];
    currentLatitude = currentLocation.coordinate.latitude;
    currentLongitude = currentLocation.coordinate.longitude;

    isLoc = YES;
    
    [self getNearListIsRefresh:YES];
    [YLNetworkInterface uploadCoordinate:[YLUserDefault userDefault].t_id lat:currentLatitude lng:currentLongitude];
}



@end
