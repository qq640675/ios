//
//  ChatLivingMsgListModel.h
//  beijing
//
//  Created by yiliaogao on 2019/2/28.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatLivingMsgListModel : SLBaseListModel

@property (nonatomic, copy) NSString    *content;

@property (nonatomic, assign) BOOL       isSelf;

@property (nonatomic, assign) BOOL       isSystemMsg;

@end

NS_ASSUME_NONNULL_END
