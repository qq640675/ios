//
//  GuardView.h
//  beijing
//
//  Created by 黎 涛 on 2021/4/12.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuardView : BaseView

@property (nonatomic, copy) void (^ sendGuardSuccess)(void);

- (instancetype)initWithId:(NSInteger)userId;
- (void)showWithDataDic:(NSDictionary *)dataDic;


@end

NS_ASSUME_NONNULL_END
