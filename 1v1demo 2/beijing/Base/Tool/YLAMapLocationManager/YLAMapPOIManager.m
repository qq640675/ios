//
//  YLAMapPOIManager.m
//  beijing
//
//  Created by yiliaogao on 2019/1/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "YLAMapPOIManager.h"

static YLAMapPOIManager *poiManager = nil;

@implementation YLAMapPOIManager

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!poiManager) {
            poiManager = [[YLAMapPOIManager alloc] init];
        }
    });
    return poiManager;
}


- (void)searchAroundPOI:(CLLocation *)location searchBlock:(YLAMapPOIManagerSearchBlock)searchBlock {
    self.searchBlock = searchBlock;
    
    self.searchAPI = [[AMapSearchAPI alloc] init];
    self.searchAPI.delegate = self;
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location            = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
    [self.searchAPI AMapPOIAroundSearch:request];
}

- (void)searchPOIWithKey:(NSString *)key city:(NSString *)city location:(CLLocation *)location searchBlock:(YLAMapPOIManagerSearchBlock)searchBlock {
    self.searchBlock = searchBlock;
    
    self.searchAPI = [[AMapSearchAPI alloc] init];
    self.searchAPI.delegate = self;
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords            = key;
    request.city                = city;
    request.requireExtension    = YES;
    request.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    /* 按照距离排序. */
    request.sortrule            = 0;
    
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    [self.searchAPI AMapPOIKeywordsSearch:request];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (self.searchBlock) {
        self.searchBlock(response.pois);
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    if (self.searchBlock) {
        self.searchBlock(nil);
    }
}

@end
