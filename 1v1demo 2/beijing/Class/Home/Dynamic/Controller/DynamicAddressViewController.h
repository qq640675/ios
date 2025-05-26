//
//  DynamicAddressViewController.h
//  beijing
//
//  Created by yiliaogao on 2019/1/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseTableViewController.h"
#import "DynamicAddressTableViewDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicAddressViewController : SLBaseTableViewController

@property (nonatomic, strong) DynamicAddressListModel   *selectedAddressListModel;

@property (nonatomic, copy) void (^DidSelectAddressBlock)(DynamicAddressListModel *model,NSString *curLocationCity);

@end

NS_ASSUME_NONNULL_END
