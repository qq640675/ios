//
//  DynamicAddressListModel.h
//  beijing
//
//  Created by yiliaogao on 2019/1/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicAddressListModel : SLBaseListModel

@property (nonatomic, copy) NSString    *name;
@property (nonatomic, copy) NSString    *address;

@property (nonatomic, assign) BOOL      isSelected;
@property (nonatomic, assign) BOOL      isNoLocation;
@property (nonatomic, assign) BOOL      isCity;

@end

NS_ASSUME_NONNULL_END
