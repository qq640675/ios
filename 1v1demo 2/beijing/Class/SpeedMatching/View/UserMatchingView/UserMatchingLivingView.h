//
//  UserMatchingLivingView.h
//  beijing
//
//  Created by yiliaogao on 2019/2/20.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "UserMatchingLivingPersonView.h"
#import "UserMatchingLivingActionView.h"
#import "AnchorMatchingLivingPersonView.h"
#import "ChatLivingTextView.h"
#import "ChatLivingMsgListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserMatchingLivingView : BaseView

@property (nonatomic, strong) ChatLivingMsgListViewController   *msgListVC;
@property (nonatomic, strong) UserMatchingLivingPersonView      *userMatchingLivingPersonView;
@property (nonatomic, strong) UserMatchingLivingActionView      *userMatchingLivingActionView;
@property (nonatomic, strong) AnchorMatchingLivingPersonView    *anchorMatchingLivingPersonView;
@property (nonatomic, strong) ChatLivingTextView                *chatLivingTextView;

@property (nonatomic, strong) UIImageView   *fullVideoImageView;
@property (nonatomic, strong) UIView        *fullVideoBlackView;
@property (nonatomic, strong) UIImageView   *smallRightTopVideoImageView;
@property (nonatomic, strong) UIView        *smallRightTopVideoBlackView;

@property (nonatomic, strong) UserMatchingAnchorModel *anchorModel;
@property (nonatomic, strong) PersonalDataHandle      *personHandle;

//是否是用户接通界面
@property (nonatomic, assign) BOOL      isUserMatching;

//通话时的文字聊天消息
- (void)chatLivingMsgListData:(NSString *)content isSelf:(BOOL)isSelf isSystemMsg:(BOOL)isSystemMsg;

- (void)setIsShowCloseCamera:(BOOL)isShow isBigView:(BOOL)isBig isSelf:(BOOL)isSelf;

@end

NS_ASSUME_NONNULL_END
