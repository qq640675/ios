//
//  VipRechargeTypeAlertView.h
//  beijing
//
//  Created by 黎 涛 on 2019/10/12.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface VipRechargeTypeAlertView : BaseView

@property (nonatomic, copy) void (^didSelectedType)(NSInteger typeId, NSInteger type);

- (instancetype)initWithTypeArray:(NSArray *)typeArray;

@end

NS_ASSUME_NONNULL_END
