//
//  YLIncomeDetailsController.h
//  beijing
//
//  Created by zhou last on 2018/6/21.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    YLDetailsTypeIncome = 1,
    YLDetailsTypeSpending,
    YLDetailsTypeRecharge,
    YLDetailsTypeWithdrawal,
} YLDetailsType;
@interface YLIncomeDetailsController : UIViewController

@property (nonatomic ,assign) YLDetailsType detailType;

@property (nonatomic ,assign) int putforward;

@end
