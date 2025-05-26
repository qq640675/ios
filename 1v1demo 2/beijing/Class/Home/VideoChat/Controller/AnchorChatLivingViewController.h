//
//  AnchorChatLivingViewController.h
//  beijing
//
//  Created by yiliaogao on 2019/2/27.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnchorChatLivingViewController : BaseViewController

@property (nonatomic, assign) int    roomId;

@property (nonatomic, assign) int    userId;

@property (nonatomic, assign) BOOL   isMeCallOther;

@property (nonatomic, assign) int chatType;

@end

NS_ASSUME_NONNULL_END
