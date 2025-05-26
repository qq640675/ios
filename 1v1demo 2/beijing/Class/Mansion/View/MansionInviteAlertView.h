//
//  MansionInviteAlertView.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/6.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum
{
    InvitiAlertTypeJoinMansion = 0, //邀请加入府邸
    InvitiAlertTypeJoinRoom = 1,  //邀请加入聊天房间
}InvitiAlertType;
@interface MansionInviteAlertView : BaseView<UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, assign) InvitiAlertType inviteType;
@property (nonatomic, strong) UITextField  *searchTF;
@property (nonatomic, strong) UITableView *inviteTableView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, assign) int mansionId;
@property (nonatomic, assign) int mansionRoomId;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int chatType;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) BOOL isInvited;
@property (nonatomic, copy) void (^removeFromSuperViewBlock)(void);

// type:  0邀请加入府邸    1邀请加入房间
- (instancetype)initWithType:(InvitiAlertType)type mansionid:(int)mansionId;
- (instancetype)initWithType:(InvitiAlertType)type mansionRoomId:(int)roomid chatType:(int)chatType;
- (void)show;

@end

NS_ASSUME_NONNULL_END
