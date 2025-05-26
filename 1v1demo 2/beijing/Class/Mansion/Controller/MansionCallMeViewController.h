//
//  MansionCallMeViewController.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/11.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MansionCallMeViewController : BaseViewController

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) int mansionRoomId;
@property (nonatomic, assign) int roomId;
@property (nonatomic, assign) MansionChatType chatType;
@property (nonatomic, copy) void (^answerNewComing)(BOOL isHangUp);//操作回调   isHangUp：是否挂断

@end

NS_ASSUME_NONNULL_END
