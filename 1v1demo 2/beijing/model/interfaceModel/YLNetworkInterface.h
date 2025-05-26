//
//  YLNetworkInterface.h
//  beijing
//
//  Created by zhou last on 2018/7/2.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonalDataHandle.h"
#import "godnessInfoHandle.h"
#import "myPurseHandle.h"
#import "incomeDetailHandle.h"
#import "personalCenterHandle.h"
#import "userShareCountHandle.h"
#import "shareEarnHandle.h"
#import "anchorChargeSetupHandle.h"
#import "videoPayHandle.h"
#import "feedbackDetailHandle.h"
#import "receiveRedPacketHandle.h"
#import "weixinPayHandle.h"
#import "anchorAddGuildHandle.h"
#import "newAnchorHandle.h"
#import "rankingHandle.h"

typedef void (^JSONObjectBlock)(NSMutableArray *listArray);
typedef void (^JSONBOOLBlock)(BOOL isSuccess);
typedef void (^JSONTimeStampBlock)(int timeStamp);
typedef void (^JSONVIPWeixinPayBlock)(weixinPayHandle *hanle,NSString *apliOrderInfo);
typedef void (^JSONRedPacketBlock)(int total);
typedef void (^JSONanchorAddGuildHandleBlock)(anchorAddGuildHandle *handle);
typedef void (^JSONBalanceLessBlock)(int code);
typedef void (^JSONUnionBlock)(int anchorCount,int totalGold);
typedef void (^JSONFengHaoBlock)(int code,NSString *errorMsg);
typedef void (^JSONDictonaryBlock)(NSDictionary *dic);
typedef void (^JSONTokenStampBlock)(NSString *token);
typedef void (^JSONHandleBlock)(PersonalDataHandle *handle);
typedef void (^JSONVideoPlayBlock)(videoPayHandle *handle);
typedef void (^JSONMapAnchorBlock)(newAnchorHandle *handle);
typedef void (^JSONVideoPushBlock)(NSDictionary *pushDic);
typedef void (^JSONHaveSexBlock)(BOOL isSuccess,BOOL isHaveSex,BOOL suspend,NSString *errorMsg);
typedef void (^JSONReceiveRedPacketBlock)(receiveRedPacketHandle *handle);
typedef void (^JSONPersonalCenterHandleBlock)(personalCenterHandle *handle);
typedef void (^JSONMyPurseHandleBlock)(myPurseHandle *handle);
typedef void (^JSONAcccountBalanceBlock)(int pay,int profit);
typedef void (^JSONFeedBackDetailHandleBlock)(feedbackDetailHandle *handle);
typedef void (^JSONShareCountHandleBlock)(userShareCountHandle *handle);
typedef void (^JSONVideoChatAutographBlock)(NSString *userSig,int roomId,int onlineState);
typedef void (^JSONShareEarnHandleBlock)(shareEarnHandle *handle);
typedef void (^JSONGodNessInfoHandleBlock)(godnessInfoHandle *handle);
typedef void (^JSONanchorChargeHandleBlock)(anchorChargeSetupHandle *handle);
typedef void (^JSONFriendBlock)(NSMutableArray *listArray,NSString *friendApplyCount);
typedef void (^JSONNewIntimateAndGiftBlock)(NSArray *intimates,NSArray *gifts);
typedef void (^JSONIOSVersionBlock)(NSString *t_version,NSString *t_download_url,NSString *t_version_depict);

typedef void (^JSONTencentApiBlock)(NSDictionary *dataDic);
typedef void(^JSONAroraAppId)(NSDictionary *dic);
//微信专用
typedef void (^JSONWechatBlock)(NSString *access_token,NSString *openid,NSString *refresh_token);
typedef void (^JsonWechatBackBlock)(NSString *nickname,NSString *headimgurl,NSString *province,int sex,NSString *city);

@interface YLNetworkInterface : NSObject


+(void)getisPushDynamic:(NSInteger)userid :(JSONBOOLBlock)block;

//发送短信验证码
+ (void)sendPhoneVerificationCode:(NSString *)phone
                      sendVericationBlock:(JSONBOOLBlock)block restype:(int)resType verifyCode:(NSString *)verifyCode;

//获取腾讯云对象存储
+ (void)getTencentTempApiData:(JSONTencentApiBlock)block;

//获取声望配置
+ (void)getAgoraAppId:(JSONAroraAppId)block;

//获取APP风格设置
+ (void)getStyleSetUp:(JSONTokenStampBlock)block;

//获取认证过后的客服微信
+ (void)getIdentificationWeiXin:(int)userId block:(JSONTokenStampBlock)block;

//账号密码登录
+ (void)login:(NSString *)phone smsCode:(NSString *)smsCode t_system_version:(NSString *)t_system_version t_ip_address:(NSString *)t_ip_address t_channel:(NSString *)channelid loginBlock:(JSONHaveSexBlock)block;

//奖励规则
+ (void)getSpreadAward:(int)userId block:(JSONTokenStampBlock)block;

//获取推荐主播
+ (void)getHomeNominateList:(int)userId page:(int)page block:(JSONObjectBlock)block;

//获取试看主播列表
+ (void)getTryCompereList:(int)userId page:(int)page block:(JSONObjectBlock)block;

//获取新人主播
+ (void)getNewCompereList:(int)userId page:(int)page block:(JSONObjectBlock)block;

//修改用户性别
+ (void)upateUserSex:(int)userId sex:(int)sex idCard:(NSString *)idCard block:(JSONBOOLBlock)block;

//修改手机号
+ (void)updatePhone:(int)userId phone:(NSString *)phone smsCode:(NSString *)smsCode block:(JSONBOOLBlock)block;

//获取主播视频聊天收费最大值
+ (void)getAnchorVideoCost:(int)userId block:(JSONRedPacketBlock)block;

//ios版本更新
+ (void)getIosVersion:(int)userId block:(JSONIOSVersionBlock)block;

//获取banner
+ (void)getIosBanner:(JSONObjectBlock)block;
+ (void)getAllBannerListSuccess:(void (^)(NSDictionary *data))success;
+ (void)getNewBannerListSuccess:(void (^)(NSDictionary *data))success;

//微信登录
+ (void)newWechatLogin:(NSString *)wxCode t_channel:(NSString *)channelid block:(JSONHaveSexBlock)block;

//账号余额(收入支出)
+ (void)getProfitAndPayTotal:(int)userId year:(int)year month:(int)month block:(JSONAcccountBalanceBlock)block;

//获取地图的主播信息
+ (void)getUserDeta:(int)userId coverSeeUserId:(int)coverSeeUserId lat:(double)lat lng:(double)lng block:(JSONMapAnchorBlock)block;

//账号余额(列表)
+ (void)getUserGoldDetails:(int)userId year:(int)year month:(int)month queryType:(int)queryType page:(int)page block:(JSONObjectBlock)block;

//更新用户登陆时间
+ (void)upLoginTime:(int)userId block:(JSONBOOLBlock)block;

//获取个人资料(含主播)
+ (void)getMydata:(int)userId block:(JSONHandleBlock)block;

//获取后台发起视频的推送消息
+ (void)getUuserCoverCal:(int)userId block:(JSONVideoPushBlock)block;

//获取主播亲密排行和礼物排行
+ (void)getIntimateAndGift:(int)userId block:(JSONNewIntimateAndGiftBlock)block;

//获取主播亲密度列表
+ (void)getAnthorIntimateList:(int)userId page:(int)page block:(JSONObjectBlock)block;

//获取礼物柜
+ (void)getAnthorGiftList:(int)userId block:(JSONObjectBlock)block;

//获取我的相册列表
+ (void)getMyAnnualAlbum:(int)type page:(NSInteger)page block:(JSONObjectBlock)block;

//通话记录
+ (void)getCallLog:(int)userId page:(int)page block:(JSONObjectBlock)block;

//拉取新用户注册推送
+ (void)getPushMsg:(int)userId;

//距离
+ (void)getAnthorDistanceListUserd:(int)userId page:(int)page lat:(double)lat lng:(double)lng block:(JSONObjectBlock)block;

//获取第三方登陆配置信息
+ (void)getLongSetUpList;

// 获取我的关注列表
+ (void)getFollowList:(int)userId page:(int)page block:(JSONObjectBlock)block;
+ (void)getLikeListWithPage:(int)page type:(int)type block:(JSONObjectBlock)block;

//添加关注
+ (void)addAttention:(int)followUserId coverFollowUserId:(int)coverFollowUserId block:(JSONBOOLBlock)block;

//取消关注
+ (void)cancelAtttention:(int)followId coverFollowUserId:(int)coverFollow block:(JSONBOOLBlock)block;

//申请公会
+ (void)applyGuild:(int)userId guildName:(NSString *)guildName adminName:(NSString *)adminName adminPhone:(NSString *)adminPhone anchorNumber:(int)anchorNumber idCard:(NSString *)idCard handImg:(NSString *)handImg block:(JSONBOOLBlock)block;

//获取公会主播贡献列表
+ (void)getContributionList:(int)userId page:(int)page block:(JSONObjectBlock)block;

//获取推荐贡献排行榜(奖励排行)
+ (void)getSpreadBonuses:(int)userId queryType:(NSInteger)queryType block:(JSONObjectBlock)block;

//获取推荐用户排行榜(人数排行)
+ (void)getSpreadUser:(int)userId queryType:(NSInteger)queryType block:(JSONObjectBlock)block;

//统计公会主播数和贡献值
+ (void)getGuildCount:(int)userId block:(JSONUnionBlock)block;

//拉取是否邀请主播加入公会
+ (void)getAnchorAddGuild:(int)userId block:(JSONanchorAddGuildHandleBlock)block;

//主播确认是否加入公会
+ (void)isApplyGuild:(int)userId guildId:(int)guildId isApply:(int)isApply block:(JSONBOOLBlock)block;

//获取公会主播贡献明细统计
+ (void)getAnthorTotal:(int)userId anchorId:(int)anchorId block:(JSONanchorAddGuildHandleBlock)block;

//公会主播贡献明细列表
+ (void)getContributionDetail:(int)userId anchorId:(int)anchorId page:(int)page block:(JSONObjectBlock)block;

//获取提现方式列表
+ (void)getTakeOutMode:(JSONDictonaryBlock)block;

//获取用户资料
+ (void)getPersonalData:(int)userId personalData:(JSONHandleBlock)block;

//APP主页搜索
+ (void)getSearchList:(int)userId page:(int)page condition:(NSString *)condition block:(JSONObjectBlock)block;

//获取主播个人资料
+ (void)getGodnessUserData:(int)seeUserId coverUserId:(int)coverUserId block:(JSONGodNessInfoHandleBlock)block;

//获取主播播放页数据
+ (void)getAnchorPlayPage:(int)consumeUserId albumId:(int)albumId coverConsumeUserId:(int)coverConsumeUserId queryType:(int)queryType block:(JSONVideoPlayBlock)block;

//用户点赞
+ (void)addLaud:(int)laudUserId coverLaudUserId:(int)coverLaudUserId block:(JSONBOOLBlock)block;

//用户取消点赞
+ (void)cancelLaud:(int)userId coverUserId:(int)coverUserId block:(JSONBOOLBlock)block;

//获取主播评论
+ (void)getEvaluationList:(int)userId block:(JSONObjectBlock)block;

//添加分享次数
+ (void)addShareCount:(int)userId block:(JSONBalanceLessBlock)block;

//获取粉丝列表
+ (void)getOnLineUserList:(int)userId page:(int)page searchType:(int)searchType search:(NSString *)search block:(JSONObjectBlock)block;

//评价主播
+ (void)saveCommentUserId:(int)commUserId coverCommUserId:(int)coverCommUserId commScore:(int)commScore comment:(NSString *)comment lables:(NSString *)lables block:(JSONBOOLBlock)block;

//个人钱包
+ (void)getUserMoney:(int)userId block:(JSONMyPurseHandleBlock)block;

//获取VIP套餐列表
+ (void)getVIPSetMealType:(int)type List:(JSONObjectBlock)block;

//VIP支付
+ (void)vipStoreValue:(int)userId setMealId:(int)setMealId payType:(int)payType payDeployId:(NSInteger)payDeployId block:(JSONVIPWeixinPayBlock)block;

//提现比例
+ (void)getPutforwardDiscount:(JSONObjectBlock)block t_end_type:(int)type;

//充值列表 type: 0支付宝  1微信
+ (void)getRechargeDiscount:(int)payType block:(JSONObjectBlock)block;

//金币充值
+ (void)goldStoreValue:(int)userId setMealId:(int)setMealId payType:(int)payType payDeployId:(NSInteger)payDeployId block:(JSONVIPWeixinPayBlock)block;

//获取用户可提现金币
+ (void)getUsableGold:(int)userId block:(JSONObjectBlock)block;

//更新提现资料
+ (void)modifyPutForwardData:(int)userId t_real_name:(NSString *)t_real_name t_nick_name:(NSString *)t_nick_name t_account_number:(NSString *)t_account_number t_type:(int)t_type t_head_img:(NSString *)t_head_img qrCodeUrl:(NSString *)qrCodeUrl withSmscode:(NSString *)smscode block:(JSONBOOLBlock)block;

//用户赠送礼物
+ (void)userGiveGiftCoverConsumeUserIds:(NSString *)coverConsumeUserIds giftId:(int)giftId giftNum:(int)giftNum block:(JSONBOOLBlock)block;

//修改用户(在离线)状态
+ (void)updateAnchorOnlineUserId:(int)userId type:(int)type;

//勿扰Type
+ (void)setUpChatSwitchType:(int)type switchType:(int)switchType block:(JSONBOOLBlock)block;

//获取贡献金币用户列表
+ (void)getUserMakeMoneyList:(int)userId page:(int)page block:(JSONObjectBlock)block;

//获取我的推广用户列表
+ (void)getShareUserList:(int)userId page:(int)page type:(int)type block:(JSONObjectBlock)block;

//推广赚钱
+ (void)getShareTotal:(int)userId block:(JSONShareEarnHandleBlock)block;

//上传坐标
+ (void)uploadCoordinate:(int)userId lat:(double)lat lng:(double)lng;

//获取附近的用户列表
+ (void)getNearbyList:(int)userId lat:(double)lat lng:(double)lng block:(JSONObjectBlock)block;

//获取视频上传签名
+ (void)getVoideSignBlock:(JSONTokenStampBlock)block;

//申请CPS联盟
+ (void)addCpsMs:(int)userId
         cpsName:(NSString *)cpsName
          cpsUrl:(NSString *)cpsUrl
          active:(int)active
     proportions:(int)proportions
        realName:(NSString *)realName
       takeOutId:(int)takeOutId
   accountNumber:(NSString *)accountNumber
           phone:(NSString *)phone
           block:(JSONBOOLBlock)block;


//魅力榜
+ (void)getGlamourList:(int)userId queryType:(int)queryType block:(void(^)(NSMutableArray *listArray, rankingHandle *myHandle))block;

//消费榜
+ (void)getConsumeList:(int)userId queryType:(int)queryType block:(void(^)(NSMutableArray *listArray, rankingHandle *myHandle))block;

//豪礼榜
+ (void)getCourtesyList:(int)userId queryType:(int)queryType block:(JSONObjectBlock)block;

//主播收益明细
+ (void)getAnchorProfitDetail:(int)userId queryType:(int)queryType block:(JSONObjectBlock)block;

//获取用户贡献列表
+ (void)getMyContributionList:(int)userId page:(int)page block:(JSONObjectBlock)block;

//获取短视频列表
+ (void)getVideoListUserId:(int)userId page:(int)page queryType:(int)queryType block:(JSONObjectBlock)block;

//发红包
+ (void)sendRedEnvelope:(int)consumeUserId coverConsumeUserId:(int)coverConsumeUserId gold:(int)gold block:(JSONBalanceLessBlock)block;

//获取IM签名
+ (void)getImUserSign:(int)userId block:(JSONTokenStampBlock)block;

//非VIP查看私密照片
+ (void)seeImgConsumeUserId:(int)consumeUserId coverConsumeUserId:(int)coverConsumeUserId photoId:(int)photoId block:(JSONFengHaoBlock)block;

//VIP查看私密视频或者照片
+ (void)vipSeeDataUserId:(int)vipUserId sourceId:(int)sourceId;

//非VIP查看私密视频
+ (void)seeVideoConsumeUserId:(int)consumeUserId coverConsumeUserId:(int)coverConsumeUserId videoId:(int)videoId block:(JSONBalanceLessBlock)block;

//非VIP发送文本消息
+ (void)sendTextConsumeUserId:(int)consumeUserId coverConsumeUserId:(int)coverConsumeUserId block:(JSONBalanceLessBlock)block;

//同城列表
+ (void)getCityWideList:(int)userId page:(int)page block:(JSONObjectBlock)block;

//查看微信
+ (void)seeWeiXinConsumeUserId:(int)consumeUserId coverConsumeUserId:(int)coverConsumeUserId block:(JSONDictonaryBlock)block;

//查看QQ
+ (void)seeQQConsumeUserId:(int)consumeUserId coverConsumeUserId:(int)coverConsumeUserId block:(JSONDictonaryBlock)block;

//查看手机号
+ (void)seePhoneConsumeUserId:(int)consumeUserId coverConsumeUserId:(int)coverConsumeUserId block:(JSONDictonaryBlock)block;

//获取礼物列表
+ (void)getGiftList:(JSONObjectBlock)block;

//提交实名认证资料
+ (void)submitIdentificationData:(int)userId t_user_hand:(NSString *)t_user_hand t_nam:(NSString *)t_nam t_id_card:(NSString *)t_id_card block:(JSONBOOLBlock)block;

//新提交认证方式
+ (void)submitNewIdentificationData:(int)userId t_user_video:(NSString *)t_user_video t_user_photo:(NSString *)t_user_photo block:(JSONBOOLBlock)block;
+ (void)submitNewIdentificationData:(int)userId t_weixin:(NSString *)t_weixin t_user_photo:(NSString *)t_user_photo block:(JSONBOOLBlock)block;

//获取后台主播设置
+ (void)getAnthorChargeList:(int)userId block:(JSONObjectBlock)block;

//获取实名认证状态
+ (void)getUserIsIdentification:(int)userId block:(JSONBalanceLessBlock)block;

//用户QQ登陆
+ (void)qqLoginOpenId:(NSString *)openId nickName:(NSString *)nickName handImg:(NSString *)handImg city:(NSString *)city t_system_version:(NSString *)t_system_version ipaddress:(NSString *)ipAddress t_channel:(NSString *)channelid block:(JSONHaveSexBlock)block;

//获取钱包余额
+ (void)getQueryUserBalance:(int)userId block:(JSONRedPacketBlock)block;

//获取钱包消费或者提现明细
+ (void)getWalletDetailType:(NSDictionary *)dic block:(JSONObjectBlock)block;

//获取钱包日明细
+ (void)getWalletDateDetailstate:(int)state userId:(int)userId time:(NSString *)time page:(int)page block:(JSONObjectBlock)block;

//视频聊天签名
+ (void)getVideoChatAutograph:(int)userId anchorId:(int)anchorId block:(JSONVideoChatAutographBlock)block;

+ (void)getVideoChatPriavteMapKey:(int)userId roomId:(int)roomId block:(JSONTokenStampBlock)block;


//申请体现
+ (void)confirmPutforward:(int)dataId userId:(int)userId putForwardId:(int)putForwardId withpaypass:(NSString *)paypass block:(JSONBOOLBlock)block;

//验证昵称是否重复
+ (void)getNickRepeat:(NSString *)nickName;

//获取消息列表
+ (void)getMessageList:(int)userId page:(int)page block:(JSONObjectBlock)block;

//获取我的私藏
+ (void)getMyPrivateList:(int)userId page:(int)page;

//获取主播照片或视频
+ (void)getGodNessPhotoOrVideoList:(int)seeUserId coverUserId:(int)coverUserId page:(int)page block:(JSONObjectBlock)block;

+ (void)requestAnchorPhotoOrVideoWithAnchorId:(int)anchorId type:(int)type page:(int)page success:(void(^)(NSArray *listArray))success fail:(void(^)(void))fail;

//获取标签列表
+ (void)getImageLabelList:(int)userId block:(JSONObjectBlock)block;

//获取主页列表
+ (void)getHomePageList:(int)userId page:(int)page queryType:(int)queryType block:(JSONObjectBlock)block;
+ (void)getHomePageListWithCity:(NSString *)city page:(int)page queryType:(int)queryType block:(JSONObjectBlock)block;

//获取banner列表
+ (void)getBannerList:(JSONObjectBlock)block;

//获取未读消息数
+ (void)getUnreadMessage:(int)userId block:(void (^)(int systemCode,NSString *errorMsg, int mansionCount))block;

//设置为已读
+ (void)setupReadMessage;

//删除消息
+ (void)delMessageId:(int)messageId;

//用户对主播发起聊天
+ (void)launchVideoUserId:(int)launchUserId coverLinkUserId:(int)coverLinkUserId roomId:(int)roomId chatType:(int)chatType block:(JSONBalanceLessBlock)block;

//主播对用户发起聊天
+ (void)anchorLaunchVideoChat:(int)anchorUserId userId:(int)userId roomId:(int)roomId chatType:(int)chatType block:(JSONBalanceLessBlock)block;

//开始计时
+ (void)videoCharBeginTimingAnthorId:(int)anthorId userId:(int)userId roomId:(int)roomId chatType:(int)chatType block:(JSONBalanceLessBlock)block;

//用户或主播挂断链接
+ (void)hangupLink:(int)userId block:(JSONBOOLBlock)block;

//投诉用户
+ (void)saveComplaintUserId:(int)userId coverUserId:(int)coverUserId comment:(NSString *)comment img:(NSString *)img block:(JSONBOOLBlock)block;
+ (void)saveComplaintWithCoverUserId:(int)coverUserId comment:(NSString *)comment img:(NSString *)img phone:(NSString *)phone tcode:(NSString *)tcode block:(JSONBOOLBlock)block;

+ (void)breakLinkRoomId:(int)roomId;
+ (void)breakLinkRoomId:(int)roomId andSuccess:(void (^)(void))success;

//意见反馈
+ (void)addFeedbackUserId:(int)userId phone:(NSString *)phone content:(NSString *)content t_img_url:(NSString *)imgUrl block:(JSONBOOLBlock)block;

//历史反馈列表
+ (void)getFeedBackList:(int)userId page:(int)page block:(JSONObjectBlock)block;

//历史反馈详情
+ (void)getFeedBackById:(int)feedBackId block:(JSONFeedBackDetailHandleBlock)block;

//修改个人资料
+ (void)updatePersonalData:(NSDictionary *)dic editblock:(JSONBOOLBlock)block;

//获取个人浏览记录
+ (void)getBrowseList:(int)userId page:(int)page block:(JSONObjectBlock)block;

//获取标签列表
+ (void)getLabelList:(int)userId block:(JSONObjectBlock)block;

//删除我的相册
+ (void)delMyPhotoId:(int)photoId block:(JSONBOOLBlock)block;

//新增相册数据
+ (void)addMyPhotoAlbum:(int)userId t_title:(NSString *)t_title url:(NSString *)url type:(int)type gold:(int)gold fileId:(NSString *)fileId video_img:(NSString *)video_img block:(JSONBOOLBlock)block;

//获取我的相册
+ (void)getMyPhotoList:(int)userId page:(int)page block:(JSONObjectBlock)block;

//获取个人中心
+ (void)index:(int)userId block:(JSONPersonalCenterHandleBlock)block;

//新增用户标签
+ (void)saveUserLabelUserId:(int)userId labelId:(int)labelId;

//获取主播收费设置
+ (void)getAnchorChargeSetup:(int)userId block:(JSONanchorChargeHandleBlock)block;

//修改主播收费设置
+ (void)updateAnchorChargeSetup:(NSMutableDictionary *)dic block:(JSONBOOLBlock)block;

//获取已收到礼物列表
+ (void)getGiveGiftList:(int)userId page:(int)page block:(JSONObjectBlock)block;

//获取礼物赠送列表
+ (void)getRewardList:(int)userId page:(int)page block:(JSONObjectBlock)block;

//获取用户收未拆开红包统计
+ (void)getRedPacketCount:(int)userId block:(JSONRedPacketBlock)block;

//拆开红包
+ (void)receiveRedPacket:(int)userId block:(JSONReceiveRedPacketBlock)block;

//查看他人个人资料
+ (void)getUserPersonalData:(int)userId;

//删除用户标签
+ (void)delUserLabel:(int)labelId;

//身份验证
+ (void)veriIdentification:(NSString *)realName idenNo:(NSString *)idenNo img:(NSString *)img block:(JSONBOOLBlock)block;

//版本是否上线
+ (void)getIosSwitch:(JSONBOOLBlock)block;

//微信登录
//获取access_token
+ (void)getAccess_token:(NSString *)code wechatBlock:(JSONWechatBlock)block;

//刷新或续期access_token使用
+ (void)refreshAccess_token:(NSString *)refreshToken;

//检验授权凭证（access_token）是否有效
+ (void)checkAccess_token:(NSString *)access_token oppenId:(NSString *)oppenId block:(JSONBOOLBlock)block;

//获取微信个人信息
+ (void)getWechatInfoOpenId:(NSString *)openId acesstoken:(NSString *)accessToken block:(JsonWechatBackBlock)block;

//用户退出
+ (void)logout:(int)userId block:(JSONBOOLBlock)block;

#pragma mark ---- 动态
//获取用户动态列表
+ (void)getDynamicList:(NSInteger)userId
                  page:(NSInteger)page
               reqType:(NSInteger)reqType
                 block:(JSONObjectBlock)block;
//发布动态
+ (void)releaseDynamicData:(NSInteger)userId
                   content:(NSString *)content
                   address:(NSString *)address
                 isVisible:(NSInteger)isVisible
                     files:(id)files
                     block:(JSONBOOLBlock)block;

//点赞
+ (void)dynamicLove:(NSInteger)userId
          dynamicId:(NSInteger)dynamicId
              block:(JSONBOOLBlock)block;

//获取私密金币
+ (void)dynamicPrivatePhotoMoney:(NSInteger)userId block:(JSONObjectBlock)block;
//私密照片视频消费
+ (void)postDynamicPay:(NSInteger)userId fileId:(NSInteger)fileId block:(JSONBalanceLessBlock)block;
//评论列表
+ (void)getDynamicCommentList:(NSInteger)userId page:(NSInteger)page dynamicId:(NSInteger)dynamicId block:(JSONObjectBlock)block;
//发布评论
+ (void)addDynamicComment:(NSInteger)userId coverUserId:(NSInteger)coverUserId dynamicId:(NSInteger)dynamicId comment:(NSString *)comment block:(JSONBalanceLessBlock)block;

//删除评论
+ (void)deleteDynamicComment:(NSInteger)userId commentId:(NSInteger)commentId block:(JSONBalanceLessBlock)block;

//绑定邀请人
+ (void)uniteIdCardWithId:(NSInteger)userId idCard:(NSInteger)idCard block:(JSONBalanceLessBlock)block;

//获取动态最新消息
+ (void)getDynamicNewMsgNumber:(int)userId block:(JSONRedPacketBlock)block;

//获取动态消息列表
+ (void)getUserNewCommentList:(NSInteger)userId block:(JSONObjectBlock)block;

//获取图形验证码
+ (void)getVerifyWithPhone:(NSString *)phone block:(JSONVideoPushBlock)block;

//验证图形
+ (void)getVerifyCodeIsCorrectWithPhone:(NSString *)phone verifyCode:(NSString *)verifyCode block:(JSONBalanceLessBlock)block;

//获取自己的动态列表
+ (void)getMineDynamicList:(NSInteger)userId page:(NSInteger)page block:(JSONObjectBlock)block;

//删除自己的动态
+ (void)dynamicDelete:(NSInteger)userId dynamicId:(NSInteger)dynamicId block:(JSONBOOLBlock)block;

//获取主播个人动态
+ (void)getPriDynamicList:(NSInteger)userId coverUserId:(NSInteger)coverUserId page:(NSInteger)page reqType:(NSInteger)reqType block:(JSONObjectBlock)block;
//获取客户QQ
+ (void)getServiceQQ:(NSInteger)userId block:(JSONDictonaryBlock)block;
//帮助中心列表
+ (void)getHelpCenter:(int)userId block:(JSONObjectBlock)block;
//获取主播详情资料
+ (void)getAnchorWithData:(int)userId anchorId:(int)anchorId block:(JSONGodNessInfoHandleBlock)block;
//账号密码注册
+ (void)registerPwdWithPhone:(NSString *)phone password:(NSString *)password smsCode:(NSString *)smsCode t_channel:(NSString *)channelid block:(JSONBOOLBlock)block;
//找回密码
+ (void)findPwdWithPhone:(NSString *)phone password:(NSString *)password smsCode:(NSString *)smsCode block:(JSONBOOLBlock)block;
//账号密码登录
+ (void)pwdLoginWithPhone:(NSString *)phone password:(NSString *)password block:(JSONHaveSexBlock)block;
//获取主播主封面
+ (void)getAnthorCoverImage:(JSONDictonaryBlock)block;


//获取分享域名
+ (void)getShareUrlAddress:(JSONDictonaryBlock)block;

//单独上传封面
+ (void)uploadCoverImage:(NSString *)imageUrl isFirst:(NSInteger)first block:(JSONDictonaryBlock)block;
//设置主封面
+ (void)setMainCoverImage:(NSInteger)coverImgId block:(JSONDictonaryBlock)block;
//删除封面
+ (void)deleteCoverImage:(NSInteger)coverImgId block:(JSONDictonaryBlock)block;
//获取支付类型
+ (void)getPayType:(JSONObjectBlock)block;
// 广告
+ (void)getAdTableWithType:(NSInteger)type userId:(int)userId page:(NSInteger)page timeout:(int)timeOut success:(void (^)(NSArray *dataAttay))success fail:(void (^) (void))fail;
//获取im sig
+ (void)getDataWithUserImSig:(int)userId block:(JSONTokenStampBlock)block;


//谁看过我
+ (void)getCoverBrowseListWithUserId:(NSString *)userId page:(NSInteger)page Success:(void (^)(NSArray *dataArray, NSString *totelNum))success fail:(void (^)(void))fail;

//lsl update start
//获取别人的资料数据
+ (void)getUserInfoByIdUser:(NSInteger)userId block:(JSONPersonalCenterHandleBlock)block;
//lsl update end

+ (void)getSelectCharAnotherWithAnchorId:(int)anchorId success:(JSONObjectBlock)block;


+ (void)getVIPUserInfoWithType:(int)chatType success:(void(^)(NSInteger userId))success;
+ (void)breakLinkRoomId:(int)roomId success:(void (^)(BOOL isSuccess))isSuccess;
+ (void)verificationPhoneSmsCode:(int)userId phone:(NSString *)phone smsCode:(NSString *)smsCode block:(JSONBOOLBlock)block;
+ (void)getAnoCoverImgSuccess:(void (^) (NSArray *imageArray))success;

+ (void)addBlackUserWithId:(NSString *)userId success:(void (^)(void))success;
+ (void)delBlackUserWithId:(NSString *)userId success:(void (^)(void))success;
+ (void)getBlackUserListWithPage:(NSInteger)page Success:(void (^)(NSArray *dataArray))success fail:(void (^)(void))fail;

//im敏感词汇
+ (void)getDataWithImSensitiveWorld:(NSInteger)userId block:(JSONDictonaryBlock)block;
+ (void)getSounRecordingSwitchAndCache;
+ (void)saveSounRecordingWithTime:(NSString *)time otherId:(NSString *)otherId path:(NSString *)path success:(void (^)(void))success;

+ (void)getAnthorTopping:(NSInteger)userId block:(JSONDictonaryBlock)block;

+ (void)qiniuPictureIdentify:(UIImage *)image result:(void (^)(bool isPulp))result;
+ (void)getVideoScreenshotStatusSuccess:(void (^)(NSDictionary *dataDic))success;
+ (void)addVideoScreenshotInfoWithParam:(NSDictionary *)param;

//轮询
+ (void)getVideoStatusWithUserId:(int)userId anchorId:(int)anchorId roomId:(int)roomId result:(void (^)(bool isSuccess))result;
+ (void)getGuardWithAnchorId:(NSInteger)anchorId Success:(void(^)(NSDictionary *dataDic))success;
+ (void)privateLetterNumberSuccess:(void(^)(bool isCase, NSString *num, bool isGold, NSString *goldNum))success;


+ (void)greetToAnchorWithAnchorId:(int)anchorId success:(void (^)(void))success;

+ (void)vipStoreWeMiniPPayValue:(int)userId setMealId:(int)setMealId payType:(int)payType payDeployId:(NSInteger)payDeployId success:(void(^)(NSDictionary *payData))success;
+ (void)goldStoreWeMiniPPayValue:(int)userId setMealId:(int)setMealId payType:(int)payType payDeployId:(NSInteger)payDeployId success:(void(^)(NSDictionary *payData))success;

+ (void)submitIdentificationDataWithParam:(NSDictionary *)param success:(void(^)(void))success;
+ (void)vipSwitchWithAnchorId:(int)anchorId Success:(void(^)(int resultCode, NSString *message))success;

+ (void)setFirstAlbumWithId:(int)albumId success:(void (^)(void))success;
+ (void)disableUser:(int)userId success:(void (^)(void))success;
+ (void)getFirstCharge:(int)userId queryType:(NSInteger)queryType block:(JSONObjectBlock)block;



//mansion 府邸 -------------------------------------------------------------
#pragma mark - mansion
+ (void)getMansionHouseSwitchResult:(void (^)(bool houseSwitch, int mansionId, NSString * mansionMoney, NSString *t_mansion_house_coverImg))result;
+ (void)inviteMansionHouseAnchorWithMansionId:(int)mansionId anchorId:(int)anchorId;
+ (void)getMansionHouseFollowListWithPage:(int)page mansionId:(int)mansionId searchKey:(NSString *)searchKey mansionRoomId:(int)mansionRoomId type:(int)type success:(void (^)(NSArray *dataArray))success fail:(void (^)(void))fail;
+ (void)delMansionHouseAnchorWithMansionid:(int)mansionId anchorId:(int)anchorId success:(void (^)(void))success;
+ (void)getMansionHouseInviteListWithPage:(int)page success:(void (^)(NSArray *dataArray))success fail:(void (^)(void))fail;
+ (void)agreeMansionHouseInviteIsAgree:(int)isAgree mansionId:(int)mansionId success:(void(^)(void))success;
+ (void)getMansionHouseInfoWithId:(int)mansionid success:(void (^)(NSArray *dataArray))success;
+ (void)getMansionHouseListWithPage:(int)page success:(void (^)(NSArray *dataArray))success fail:(void (^)(void))fail;
+ (void)anchorOutOfMansionHouseWithMansionid:(int)mansionId success:(void (^)(void))success;
+ (void)addMansionHouseRoomWithId:(int)mansionId roomName:(NSString *)name chatType:(int)type success:(void (^)(int mansionRoomId))success;
+ (void)setMansionHouseCoverImgWithId:(int)mansionId imagePath:(NSString *)path success:(void (^)(void))success;
+ (void)launchMansionVideoChatWithRoomId:(int)roomId chatType:(int)type anchorId:(int)anchorId;
+ (void)videoMansionChatBeginTimingWithMansionRoomId:(int)mansionRoomId roomId:(int)roomId chatType:(int)type success:(void (^)(void))success fail:(void (^)(void))fail;
+ (void)breakMansionLinkWithMansionRoomId:(int)mansionRoomId roomId:(int)roomId breakUserId:(int)breakUserId result:(void(^)(void))result;
+ (void)closeMansionLinkWithMansionRoomId:(int)mansionRoomid;
+ (void)getMansionHouseVideoInfoWithMansionRoomId:(int)mansionRoomid success:(void(^)(NSDictionary *roomInfo))success;
//-------------------------------------------------------------------------

+ (void)getFirstChargeInfoSuccess:(void (^)(NSDictionary *dataDic))success;
+ (void)getRefereeSuccess:(void (^)(int resultCode))success;
+ (void)getIMToUserMesListSuccess:(void (^)(NSArray *msgArray))success;
+ (void)sendIMToUserMesWithMessage:(NSString *)message success:(void (^)(void))success;
+ (void)getAgoraRoomSignWithRoomId:(int)roomId Success:(void (^)(NSString *rtcToken))success fail:(void (^)(void))fail;
+ (void)getServiceIdSuccess:(void (^)(NSArray *idArray))success;
+ (void)getInvitedListWithQueryType:(int)queryType block:(void(^)(NSMutableArray *listArray, rankingHandle *myHandle))block;
+ (void)getUserGuardListWithQueryType:(int)queryType block:(void(^)(NSMutableArray *listArray, rankingHandle *myHandle))block;
+ (void)receiveRankGoldWithId:(int)awardId btnType:(int)btnType rankType:(int)rankType success:(void(^)(void))success;
+ (void)getSystemConfigAndSave;
+ (void)getRankConfigWithBtnType:(int)btnType rankType:(int)rankType success:(void (^)(NSDictionary *dataDic))success;
+ (void)getShareRewardConfigListSuccess:(void (^)(NSDictionary *dataDic))success;
+ (void)receiveShareRewardGoldWithId:(NSString *)t_reward_id success:(void(^)(void))success;

+ (void)getUserRankInfoSuccess:(void (^)(NSArray *awardArray))success;
+ (void)getNewFirstChargeInfoSuccess:(void (^)(NSDictionary *dataDic))success;

+ (void)getNewEvaluationListWithId:(NSInteger)userId Success:(void (^)(NSArray *dataArr))success;
+ (void)getUserGuardGiftListWithId:(NSInteger)userId Success:(void (^)(NSArray *dataArr))success;
+ (void)getVideoComsumerInfoWithRoomId:(NSString *)roomId userId:(int)userId success:(void (^)(NSDictionary *dataDic))success;
+ (void)getcertifyStatusSuccess:(void (^)(NSDictionary *dataDic))success;

+ (void)acquire:(NSString *)cname success:(void (^)(NSString *data))success;

+ (void)startEvent:(NSString *)resourceId cname:(NSString *)cname token:(NSString *)token subscribeAudioUids:(NSString *)subscribeAudioUids success:(void (^)(NSString *data))success;
+ (void)stopEvent:(NSString *)sid resourceId:(NSString *)resourceId success:(void (^)(void))success;

+ (void)getWithdrawRule:(int)userId block:(JSONTokenStampBlock)block;

+ (void)getManagerGold:(int)userId block:(JSONTokenStampBlock)block;

+ (void)getDataWithOcrFilter:(NSInteger)userId block:(JSONDictonaryBlock)block;

+ (void)addOcrScreenshotInfoWithParam:(NSDictionary *)param result:(void (^)(bool isSuccess))result;
+ (void)requestAutoExamineSetup:(void (^)(void))success fail:(void (^)(void))fail;

// 获取临时请求地址   在现有访问域名失效的情况下使用
//+ (void)getTemporaryIP;


+ (void)has_extractauth:(int)userId block:(JSONBOOLBlock)block;
+ (void)has_paypass:(int)userId block:(JSONBOOLBlock)block;
+ (void)up_paypass:(int)userId oldpass:(NSString *)oldpass newpass:(NSString *)newpass block:(JSONBOOLBlock)block;
+ (void)sendMoneyCode:(NSString *)userid
  sendVericationBlock:(JSONBOOLBlock)block;

+ (void)getThirdSetupAction:(int)timeOut success:(void (^)(NSDictionary *dataInfo))success fail:(void (^) (void))fail;
@end
