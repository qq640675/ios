//
//  InvitationTudiListTableViewCell.h
//  beijing
//
//  Created by yiliaogao on 2019/3/26.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface InvitationTudiListTableViewCell : SLBaseTableViewCell

@property (nonatomic, strong) UILabel   *timeLb;

@property (nonatomic, strong) UIImageView   *iconImageView;

@property (nonatomic, strong) UILabel   *nikeNameLb;

@property (nonatomic, strong) UILabel   *moneyLb;

@property (nonatomic, strong) UILabel   *allBuyGoldLb;

@property (nonatomic, strong) UILabel   *goldLb;

- (void)initWithData:(SLBaseListModel *)listModel;

@end

NS_ASSUME_NONNULL_END
