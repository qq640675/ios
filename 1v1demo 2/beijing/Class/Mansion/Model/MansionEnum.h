//
//  MansionEnum.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/16.
//  Copyright © 2020 zhou last. All rights reserved.
//

#ifndef MansionEnum_h
#define MansionEnum_h

typedef enum {
    MansionChatTypeVideo = 1, //府邸视频聊天
    MansionChatTypeVoice,     //府邸语音聊天
} MansionChatType; //府邸聊天类型


typedef enum {
    MansionMessageTypeUserJoined = 1, //新用户加入房间
    MansionMessageTypeUserLeaved,     //用户离开房间
    MansionMessageTypeKickUser,       //用户被踢出房间
    MansionMessageTypeText,           //文本
    MansionMessageTypeGift,           //礼物
} MansionMessageType; //府邸IM消息类型

typedef enum {
    RankListTypeGoddess = 1,//女神榜
    RankListTypeInvited = 2, //邀请榜
    RankListTypeConsume = 3, //土豪榜
    RankListTypeGuard = 4,   //守护榜
}RankListType;


typedef enum {
    YLRankBtnTypeDay = 1, //日榜
    YLRankBtnTypeWeek,  //周榜
    YLRankBtnTypeMonth, //月榜
    YLRankBtnTypeTotal, //总榜
//    YLRankBtnTypeYesterday, //昨日
//    YLRankBtnTypeLastWeek, //上周
//    YLRankBtnTypeLastMonth, //上月
}YLRankBtnType;


#endif /* MansionEnum_h */
