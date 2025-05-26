//
//  vipSetMealHandle.h
//  beijing
//
//  Created by zhou last on 2018/8/14.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface vipSetMealHandle : NSObject

@property (nonatomic ,assign) int t_gold;                     //套餐价格(金币)
@property (nonatomic ,assign) int t_id;                       //套餐编号
@property (nonatomic ,strong) NSString *t_money;              //套餐价格(RMB)
@property (nonatomic ,strong) NSString *t_setmeal_name;       //套餐名称
@property (nonatomic ,strong) NSString *t_describe; //套餐描述
@property (nonatomic ,strong) NSString *t_duration; //月数
@property (nonatomic ,strong) NSString *t_cost_price;//原价
@property (nonatomic, copy) NSString *avgDayMoney;
@property (nonatomic, copy) NSString *t_remarks;
@property (nonatomic, assign) BOOL t_is_recommend;

@end
