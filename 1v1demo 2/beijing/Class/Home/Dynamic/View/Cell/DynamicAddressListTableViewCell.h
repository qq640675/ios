//
//  DynamicAddressListTableViewCell.h
//  beijing
//
//  Created by yiliaogao on 2019/1/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicAddressListTableViewCell : SLBaseTableViewCell

@property (nonatomic, strong) UILabel   *nameLb;
@property (nonatomic, strong) UILabel   *addressLb;
@property (nonatomic, strong) UIImageView   *tempImageView;

@end

NS_ASSUME_NONNULL_END
