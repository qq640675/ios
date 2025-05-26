//
//  DynamicReleaseListTableViewCell.h
//  beijing
//
//  Created by yiliaogao on 2018/12/26.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "SLBaseTableViewCell.h"
#import "DynamicReleaseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicReleaseListTableViewCell : SLBaseTableViewCell

@property (nonatomic, strong) UILabel   *titleLb;

@property (nonatomic, strong) UIImageView   *iconImageView;

@property (nonatomic, strong) DynamicReleaseListModel   *releaseListModel;

@end

NS_ASSUME_NONNULL_END
