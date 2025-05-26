//
//  newBalanceHandle.h
//  beijing
//
//  Created by zhou last on 2018/10/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface newBalanceHandle : NSObject

@property (nonatomic ,assign) int pageCount;  //总页码
@property (nonatomic ,assign) int profitAndPay;  //收支 -1:支出 1:收益
@property (nonatomic ,assign) int t_value;  //消耗值(VIP为RMB)
@property (nonatomic ,assign) int t_change_category;  //类别

@property (nonatomic ,strong) NSString *tTime; //时间
@property (nonatomic ,strong) NSString *detail; //描述
@property (nonatomic ,strong) NSString *t_handImg; //头像

@end

NS_ASSUME_NONNULL_END
