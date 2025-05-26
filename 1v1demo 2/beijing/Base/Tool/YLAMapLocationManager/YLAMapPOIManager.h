//
//  YLAMapPOIManager.h
//  beijing
//
//  Created by yiliaogao on 2019/1/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

typedef void(^YLAMapPOIManagerSearchBlock)(NSArray<AMapPOI *> *pois);

NS_ASSUME_NONNULL_BEGIN

@interface YLAMapPOIManager : NSObject
<
AMapSearchDelegate
>

@property (nonatomic, strong) AMapSearchAPI *searchAPI;

@property (nonatomic, copy) YLAMapPOIManagerSearchBlock searchBlock;

+ (instancetype)shareInstance;

- (void)searchAroundPOI:(CLLocation *)location searchBlock:(YLAMapPOIManagerSearchBlock)searchBlock;

- (void)searchPOIWithKey:(NSString *)key city:(NSString *)city location:(CLLocation *)location searchBlock:(YLAMapPOIManagerSearchBlock)searchBlock ;

@end

NS_ASSUME_NONNULL_END
