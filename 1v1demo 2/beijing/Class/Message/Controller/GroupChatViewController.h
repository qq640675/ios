//
//  GroupChatViewController.h
//  beijing
//
//  Created by 黎 涛 on 2021/6/2.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "BaseViewController.h"
#import "TUIChatController.h"
NS_ASSUME_NONNULL_BEGIN


@class TUIMessageCellData;
@interface GroupChatViewController : BaseViewController

@property (nonatomic, strong) TUIConversationCellData *conversationData;

@property (nonatomic, copy) NSString *group;


@end

NS_ASSUME_NONNULL_END
