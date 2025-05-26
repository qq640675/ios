//
//  shareEarnHandle.h
//  beijing
//
//  Created by zhou last on 2018/7/11.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shareEarnHandle : NSObject

@property (nonatomic ,assign) CGFloat profitTotal;         //分享总收益
@property (nonatomic ,strong) NSArray *ratio;                //推广比例
@property (nonatomic ,strong) NSDictionary *systemStup;       //潜水用户
@property (nonatomic ,strong) NSString *t_share_money;       //可提现分享金币
@property (nonatomic ,strong) NSString *totalCount;          //系统设置
@property (nonatomic ,assign) int twoSpreadCount;       //二级推广用户
@property (nonatomic ,assign) int oneSpreadCount;       //一级推广总数


@end
