//
//  MansionInviteTableViewCell.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/6.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MansionMyFollowListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MansionInviteTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^inviteButtonClickBlock)(void);

@property (nonatomic, strong) MansionMyFollowListModel *myFollowModel;

@end

NS_ASSUME_NONNULL_END
