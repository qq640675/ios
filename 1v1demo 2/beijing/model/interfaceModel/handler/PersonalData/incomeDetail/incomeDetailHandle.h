//
//  incomeDetailHandle.h
//  beijing
//
//  Created by zhou last on 2018/7/9.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface incomeDetailHandle : NSObject

@property (nonatomic ,strong) NSString *tTime;              //日期
@property (nonatomic ,assign) int t_value;            //钱
@property (nonatomic ,assign) int t_change_category;  //来源
@property (nonatomic ,assign) float t_money;            //钱
@property (nonatomic ,assign) int t_state;            //0.未审核1.提现成功2.提现失败
@property (nonatomic ,strong) NSString *t_describe;  //提现失败时描述
@property (nonatomic ,strong) NSString *totalMoney;  //提现失败时描述
@property (nonatomic ,assign) int pageCount;        //页码
@property (nonatomic ,assign) int t_order_state;            //0和1提现中 2.提现成功 3.提现失败
@property (nonatomic ,assign) int t_type;            //0.支付宝 1.微信
@property (nonatomic ,assign) int monthTotal;        //金币



@end
