//
//  DynamicAddressSearchView.h
//  beijing
//
//  Created by yiliaogao on 2019/1/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"

@protocol DynamicAddressSearchViewDelegate <NSObject>

- (void)didSelectDynamicAddressSearchViewWithCancel;

- (void)didSelectDynamicAddressSearchViewWithSearch:(NSString *)key;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DynamicAddressSearchView : BaseView
<
UITextFieldDelegate
>

@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, weak) id<DynamicAddressSearchViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
