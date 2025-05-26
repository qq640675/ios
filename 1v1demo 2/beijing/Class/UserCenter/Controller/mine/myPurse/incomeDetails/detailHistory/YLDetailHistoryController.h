//
//  YLDetailHistoryController.h
//  beijing
//
//  Created by zhou last on 2018/6/21.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLIncomeDetailsController.h"

@interface YLDetailHistoryController : UIViewController

@property (nonatomic ,assign) YLDetailsType searchType; //查询类型 1.收入明细 2.支出明细 3.充值明细
@property (nonatomic ,strong) NSString *time; //年月日 如2018-07-07
@end
