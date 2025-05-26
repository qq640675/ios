//
//  myPurseHandle.h
//  beijing
//
//  Created by zhou last on 2018/7/9.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myPurseHandle : NSObject

@property (nonatomic ,strong) NSString *amount;  //总金币
@property (nonatomic ,assign) int putforward;  //可提现金额
@property (nonatomic ,strong) NSString *monthExpenditureMoney;  //本月支出金币
@property (nonatomic ,strong) NSString *monthMoney;  //本月收入金币
@property (nonatomic ,strong) NSString *rechargeMoney;  //本月充值金币
@property (nonatomic ,strong) NSString *withdrawCashMap;  //本月提现金币


@end
