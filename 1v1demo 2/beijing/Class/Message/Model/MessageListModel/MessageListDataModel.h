//
//  MessageListDataModel.h
//  Qiaqia
//
//  Created by yiliaogao on 2019/7/10.
//  Copyright © 2019 yiliaogaoke. All rights reserved.
//

#import "SLBaseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageListDataModel : SLBaseListModel

@property (nonatomic, copy) NSString        *handImg;

@property (nonatomic, copy) NSString        *msgText;

@property (nonatomic, copy) NSString        *nickName;

@property (nonatomic, assign) NSInteger     unReadMsgCount;

@property (nonatomic, strong) NSDate        *timestamp;

- (instancetype)initWithConversation:(TIMConversation *)conversation;


@end

NS_ASSUME_NONNULL_END
