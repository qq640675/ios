//
//  PersonCenterListTableViewCell.h
//  beijing
//
//  Created by yiliaogao on 2019/3/1.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseTableViewCell.h"
#import "PersonCenterListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonCenterListTableViewCell : SLBaseTableViewCell

@property (nonatomic, strong) UIButton      *iconImageBtn;

@property (nonatomic, strong) UILabel       *titleLb;

@property (nonatomic, strong) UIView        *lineView;

@property (nonatomic, strong) UIImageView   *nextImageView;

@property (nonatomic, strong) UISwitch      *switchBtn;



@end

NS_ASSUME_NONNULL_END
