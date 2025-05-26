//
//  FirstRechargeView.h
//  beijing
//
//  Created by 黎 涛 on 2021/4/8.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "WXApiManager.h"
#import <WXApi.h>
#import <TencentOpenAPI/TencentOAuth.h>

NS_ASSUME_NONNULL_BEGIN

@interface FirstRechargeView : BaseView<WXApiManagerDelegate>

- (void)show;

@end

NS_ASSUME_NONNULL_END



@interface FirstMoneyListButton : UIButton

- (void)setContent:(NSDictionary *)dic;

@end


@interface PayTypeListButton : UIButton

- (void)setContent:(NSDictionary *)dic;

@end
