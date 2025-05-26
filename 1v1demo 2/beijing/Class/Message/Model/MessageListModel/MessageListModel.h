//
//  MessageListModel.h
//  Qiaqia
//
//  Created by yiliaogao on 2019/6/13.
//  Copyright © 2019 yiliaogaoke. All rights reserved.
//

#import "SLBaseListModel.h"
#import "MessageListDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageListModel : SLBaseListModel

@property (nonatomic, assign) NSInteger     notReplyCount;

@property (nonatomic, assign) NSInteger     userId;

@property (nonatomic, copy) NSString        *nickName;

@property (nonatomic, copy) NSString        *createTime;

@property (nonatomic, copy) NSString        *time;

@property (nonatomic, copy) NSString        *handImg;

@property (nonatomic, strong) MessageListDataModel  *dataModel;

@property (nonatomic, assign) BOOL          isTextMessage;

@property (nonatomic, assign) BOOL isTop;//是否置顶

@property (nonatomic, assign) BOOL isGroup;
@property (nonatomic, copy) NSString *group;

@end

NS_ASSUME_NONNULL_END
