//
//  YLAMapLocationManager.h
//  beijing
//
//  Created by yiliaogao on 2019/1/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "YLAMapPOIManager.h"

typedef void(^YLAMapLocationManagerLocationBlock)(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error);


NS_ASSUME_NONNULL_BEGIN

@interface YLAMapLocationManager : NSObject
<
AMapLocationManagerDelegate
>

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, copy) YLAMapLocationManagerLocationBlock  locationBlock;

+ (instancetype)shareInstance;

- (void)startLocation:(YLAMapLocationManagerLocationBlock)locationBlock;

- (void)stopLaction;


@end

NS_ASSUME_NONNULL_END
