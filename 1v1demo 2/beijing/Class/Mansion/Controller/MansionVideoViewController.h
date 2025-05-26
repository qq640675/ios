//
//  MansionVideoViewController.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/6.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface MansionVideoViewController : BaseViewController

@property (nonatomic, assign) BOOL isNewComing; //是否新来电
@property (nonatomic, assign) MansionChatType chatType;

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, assign) BOOL isHouseOwner; // 是否是房主
@property (nonatomic, assign) NSInteger ownerId;

@property (nonatomic, assign) int mansionRoomId; //府邸房间号  
@property (nonatomic, assign) int roomId; //单个的房间号  主播调用挂断使用





@end

NS_ASSUME_NONNULL_END
