//
//  RechargePayListTableViewCell.h
//  beijing
//
//  Created by yiliaogao on 2019/7/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargePayListModel.h"

@protocol RechargePayListTableViewCellDelegate <NSObject>

- (void)didSelectRechargePayListTableViewCellWithBtn:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_BEGIN

@interface RechargePayListTableViewCell : UITableViewCell

@property (nonatomic, strong) RechargePayListModel  *listModel;

@property (nonatomic, weak) id<RechargePayListTableViewCellDelegate> delegate;

- (void)initWithData:(RechargePayListModel *)model;

@end

NS_ASSUME_NONNULL_END
