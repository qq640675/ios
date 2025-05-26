//
//  PrivacyCheckAlertView.h
//  beijing
//
//  Created by 黎 涛 on 2020/5/20.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrivacyCheckAlertView : BaseView

@property (nonatomic, copy) void (^sureButtonClickBlock)(void);

- (instancetype)initWithType:(NSString *)type coin:(int)coinNum;



@end

NS_ASSUME_NONNULL_END
