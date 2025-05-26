//
//  MansionInviteListTableViewCell.h
//  beijing
//
//  Created by 黎 涛 on 2020/7/13.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MansionInviteListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MansionInviteListTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^inviteCellButtonClick)(NSInteger index);
@property (nonatomic, strong) MansionInviteListModel *inviteModel;

@end

NS_ASSUME_NONNULL_END
