//
//  BigLivingMsgListModel.h
//  beijing
//
//  Created by yiliaogao on 2019/4/24.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BigLivingMsgListModel : SLBaseListModel

@property (nonatomic, copy) NSString    *nickName;

@property (nonatomic, copy) NSString    *content;

@property (nonatomic, assign) BOOL       isSystemMsg;

@property (nonatomic, assign) BOOL       isUserJoinRoomMsg;

@end

NS_ASSUME_NONNULL_END
