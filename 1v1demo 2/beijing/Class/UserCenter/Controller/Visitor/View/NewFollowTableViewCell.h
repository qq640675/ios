//
//  NewFollowTableViewCell.h
//  beijing
//
//  Created by 黎 涛 on 2019/6/27.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WatchedModel.h"
#import "attentionInfoHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewFollowTableViewCell : UITableViewCell

@property (nonatomic, strong) attentionInfoHandle *handle; // 关注model
@property (nonatomic, strong) WatchedModel *model; //足迹 谁看过我 model
@property (nonatomic, assign) BOOL isFootPoint; //是否足迹
@property (nonatomic, assign) BOOL isBlackUser; //是否黑名单

@property (nonatomic, copy) void (^followButtonClick)(void);

@end

NS_ASSUME_NONNULL_END
