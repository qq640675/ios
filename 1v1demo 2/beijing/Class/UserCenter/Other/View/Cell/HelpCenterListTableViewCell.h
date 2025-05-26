//
//  HelpCenterListTableViewCell.h
//  beijing
//
//  Created by yiliaogao on 2019/3/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HelpCenterListTableViewCell : SLBaseTableViewCell

@property (nonatomic, strong) UILabel   *titleLb;
@property (nonatomic, strong) UILabel   *descLb;
@property (nonatomic, strong) UIImageView   *arrowImageView;

@end

NS_ASSUME_NONNULL_END
