//
//  MessageListDataModel.m
//  Qiaqia
//
//  Created by yiliaogao on 2019/7/10.
//  Copyright © 2019 yiliaogaoke. All rights reserved.
//

#import "MessageListDataModel.h"
#import "BaseView.h"

@implementation MessageListDataModel

- (instancetype)initWithConversation:(TIMConversation *)conversation {
    self = [super init];
    
    _unReadMsgCount = [conversation getUnReadMessageNum];
    
    NSString *identifier = [conversation getReceiver];
    
    //获取最后一条消息
    TIMMessage *msg = [conversation getLastMsg];
    _timestamp = msg.timestamp;
    TIMElem *elem = [msg getElem:0];
    //文字消息
    if ([elem isKindOfClass:[TIMTextElem class]]) {
        TIMTextElem *textElem = (TIMTextElem *)elem;
        _msgText = textElem.text;
    } else if ([elem isKindOfClass:[TIMImageElem class]]) {
        _msgText = @"[图片]";
    } else if ([elem isKindOfClass:[TIMSoundElem class]]) {
        _msgText = @"[语音]";
    } else if ([elem isKindOfClass:[TIMCustomElem class]]) {
        //自定义消息
        
        TIMCustomElem *customElem = (TIMCustomElem *)elem;
        NSString *jsonStr  = [[NSString alloc] initWithData:customElem.data encoding:NSUTF8StringEncoding];
        if ([jsonStr hasPrefix:@"serverSend&&"]) {
            jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"serverSend&&" withString:@"{"];
        }
        NSDictionary *dic = [SLHelper dictionaryWithJsonString:jsonStr];
        NSString *type = dic[@"type"];
        if ([type isEqualToString:@"0"] || [type isEqualToString:@"1"]) {
            _msgText  = @"[打赏礼物]";
        } else if ([type isEqualToString:@"video_connect"] || [type isEqualToString:@"video_unconnect_user"] || [type isEqualToString:@"video_unconnect_anchor"]) {
            _msgText = @"[通话]";
        } else if ([type isEqualToString:@"voice"]) {
            _msgText = @"[语音]";
        } else if ([type isEqualToString:@"picture"]) {
            _msgText = @"[图片]";
        }
    }
    
    if([conversation getType] == TIM_C2C) {
        TIMUserProfile *user = [[TIMFriendshipManager sharedInstance] queryUserProfile:identifier];
        if (user) {
            _nickName = user.nickname;
            _handImg  = user.faceURL;
            
            TIMFriend *friend = [[TIMFriendshipManager sharedInstance] queryFriend:identifier];
            if (friend.remark) {
                _nickName = friend.remark;
            }
        }
        
        //获取用户信息
//        [[TIMFriendshipManager sharedInstance] getUsersProfile:@[identifier] forceUpdate:YES succ:^(NSArray<TIMUserProfile *> *profiles) {
//            TIMUserProfile *file = [profiles firstObject];
//            
//            if (![file.nickname isEqualToString:user.nickname]) {
//                self.nickName = file.nickname;
//            }
//            if (![file.faceURL isEqualToString:user.faceURL]) {
//                self.handImg = file.faceURL;
//            }
//            
//            TIMFriend *friend = [[TIMFriendshipManager sharedInstance] queryFriend:identifier];
//            if (friend.remark) {
//                self.nickName = friend.remark;
//            }
//        } fail:^(int code, NSString *msg) {
//            
//        }];
    } else if (conversation.getType == TIM_GROUP) {
        TIMGroupInfo *localGroupInfo = [[TIMGroupManager sharedInstance] queryGroupInfo:identifier];
        self.handImg = localGroupInfo.faceURL;
        
//        [[TIMGroupManager sharedInstance] getGroupInfo:@[identifier] succ:^(NSArray *groupList) {
//            TIMGroupInfo *groupInfo = groupList.firstObject;
//            self.handImg = groupInfo.faceURL;
//        } fail:^(int code, NSString *msg) {
//            self.handImg = @"";
//        }];
    }
    
    return self;
}

@end
