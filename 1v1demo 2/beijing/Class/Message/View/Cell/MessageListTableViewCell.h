//
//  MessageListTableViewCell.h
//  Qiaqia
//
//  Created by yiliaogao on 2019/6/13.
//  Copyright © 2019 yiliaogaoke. All rights reserved.
//

#import "SLBaseTableViewCell.h"
#import "MessageListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageListTableViewCell : SLBaseTableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *nickNameLb;

@property (nonatomic, strong) UILabel *descLb;

@property (nonatomic, strong) UILabel *timeLb;

@property (nonatomic, strong) UILabel *numberLb;

@end

NS_ASSUME_NONNULL_END
