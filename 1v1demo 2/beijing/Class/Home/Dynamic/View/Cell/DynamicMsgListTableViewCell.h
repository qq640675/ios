//
//  DynamicMsgListTableViewCell.h
//  beijing
//
//  Created by yiliaogao on 2019/1/18.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicMsgListTableViewCell : SLBaseTableViewCell

@property (nonatomic, strong) UIImageView   *iconImageView;
@property (nonatomic, strong) UIImageView   *picImageView;
@property (nonatomic, strong) UIImageView   *videoTempImageView;

@property (nonatomic, strong) UILabel       *nameLb;
@property (nonatomic, strong) UILabel       *commentContentLb;
@property (nonatomic, strong) UILabel       *contentLb;
@property (nonatomic, strong) UILabel       *timeLb;

@end

NS_ASSUME_NONNULL_END
