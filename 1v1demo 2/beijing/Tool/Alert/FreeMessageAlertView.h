//
//  FreeMessageAlertView.h
//  beijing
//
//  Created by 黎 涛 on 2020/4/15.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FreeMessageAlertView : BaseView

- (void)showWithNum:(NSString *)messageNum isCase:(BOOL)isCase goldNum:(NSString *)goldNum isGold:(BOOL)isGold;

@end

NS_ASSUME_NONNULL_END
