//
//  MansionJoinedTableViewCell.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/6.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MansionJoinedModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MansionJoinedTableViewCell : UITableViewCell

@property (nonatomic, strong) MansionJoinedModel *joinedModel;
@property (nonatomic, copy) void (^deleteButtonClickBlock)(void);


@end

NS_ASSUME_NONNULL_END
