//
//  YLAMapLocationManager.m
//  beijing
//
//  Created by yiliaogao on 2019/1/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "YLAMapLocationManager.h"
#import "BaseView.h"
#import "SLAlertController.h"
#import "NSString+Util.h"

static YLAMapLocationManager *locationManager = nil;

@implementation YLAMapLocationManager

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!locationManager) {
            locationManager = [[YLAMapLocationManager alloc] init];
            [locationManager configLocationManager];
        }
    });
    return locationManager;
}

- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:3];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:3];
    
}


- (void)startLocation:(YLAMapLocationManagerLocationBlock)locationBlock {
    
    if (![SLHelper isAppLocationOpen]) {
        [self showAlertView];
        [SVProgressHUD dismiss];
        return;
    }
    
    [self.locationManager setDelegate:self];
    
    self.locationBlock = locationBlock;
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (self.locationBlock) {
            self.locationBlock(location,regeocode,error);
        }
    }];
    
}

- (void)stopLaction {
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
}

- (void)showAlertView {
    [SLAlertController alertControllerWithStyle:UIAlertControllerStyleAlert controller:[SLHelper getPresentedViewController] alertControllerTitle:nil alertControllerMessage:@"定位服务未开启，请进入系统【设置】>【隐私】>【定位服务】中打开开关" alertControllerSheetActionTitles:nil alertControllerSureActionTitle:@"去设置" alertControllerCancelActionTitle:@"取消" alertControllerSheetActionBlock:nil alertControllerAlertSureActionBlock:^{
        
        [self goGpsSetting];
        
    } alertControllerAlertCancelActionBlock:nil];
}

- (void)goGpsSetting {
    [NSString openScheme:UIApplicationOpenSettingsURLString];
}

@end
