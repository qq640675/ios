//
//  DynamicAddressNavigationView.h
//  beijing
//
//  Created by yiliaogao on 2019/1/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DynamicAddressNavigationViewDelegate <NSObject>

- (void)didSelectDynamicAddressNavigationViewWithBtn:(NSInteger)tag;

@end

@interface DynamicAddressNavigationView : BaseView

@property (nonatomic, weak) id<DynamicAddressNavigationViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
