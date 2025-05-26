//
//  RechargePayListModel.h
//  beijing
//
//  Created by yiliaogao on 2019/7/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RechargePayListModel : SLBaseListModel

@property (nonatomic, assign) BOOL isOpenMorePay;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) NSArray     *listArray;

@end

NS_ASSUME_NONNULL_END
