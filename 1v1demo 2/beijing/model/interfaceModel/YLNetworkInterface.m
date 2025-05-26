 //
//  YLNetworkInterface.m
//  beijing
//
//  Created by zhou last on 2018/7/2.
//  Copyright © 2018年 zhou last. All rights reserved.
//
#import "HAMCSHA1.h"
#import "YLNetworkInterface.h"
#import "APIManager.h"
#import <SVProgressHUD.h>
#import "YLUserDefault.h"
#import <MJExtension.h>
#import "PersonalDataHandle.h" //获取个人资料
#import "NSString+Extension.h"
#import "imageLabelHandle.h"
#import "homePageListHandle.h"
#import "attentionInfoHandle.h"
#import "browseHistoryHandle.h"
#import "myAlbumHandle.h"
#import <AFHTTPSessionManager.h>
#import "feedBackHandle.h"
#import "videoPictureHandle.h"
#import "videoListHandle.h"
#import "giftListHandle.h"
#import "sytemMsgHandle.h"
#import "vipSetMealHandle.h"
#import "YLNetworkInterface.h"
#import "accountHandle.h"
#import "shareUserHandle.h"
#import "userCommentHandle.h"
#import "searchListHandle.h"
#import "fansListHandle.h"
#import "bannerHandle.h"
#import "ContributionListHandle.h"

#import "conversationHandle.h"
#import "newBalanceHandle.h"
#import "newAlbumHandle.h"
#import "newIntimateHandle.h"
#import "JChatConstants.h"
#import "UIView+Toast.h"
#import "distanceHandle.h"
#import "mapInfoHandle.h"
#import "DynamicCommentListModel.h"
#import "DefineConstants.h"
#import "DynamicMsgListModel.h"
#import "HelpCenterListModel.h"
#import "SLHelper.h"
#import "SLDefaultsHelper.h"
#import "WatchedModel.h"
#import "LXTAlertView.h"
#import "YLSocketExtension.h"
#import "ToolManager.h"
#import "YLInsufficientManager.h"

#import "MansionMyFollowListModel.h"
#import "MansionInviteListModel.h"
#import "MansionAnchorModel.h"
#import "MansionJoinedModel.h"

// ------------ 登录说明
//发送验证码
#define sendPhoneVerificationCodeURL @"/app/sendPhoneVerificationCode.html"
//账号登录
#define loginURL  @"/app/login.html"
//微信登录
#define weixinLoginUrl @"/app/weixinLogin.html"
//QQ登录
#define qqLoginURL @"/app/qqLogin.html"
//用户登出
#define logoutURL @"/app/logout.html"
//修改手机号
#define updatePhoneURL @"/app/updatePhone.html"
//获取APP风格设置
#define getStyleSetUpURL @"/app/getStyleSetUp.html"
//奖励规则
#define getSpreadAwardURL @"/app/getSpreadAward.html"
//更新用户登陆时间
#define upLoginTimeURL @"/app/upLoginTime.html"
//APP主页搜索
#define getSearchListURL @"/app/getSearchList.html"
//获取推荐贡献排行榜(奖励排行)
#define getSpreadBonusesURL @"/app/getSpreadBonuses.html"
//获取认证过会的后台微信
#define getIdentificationWeiXinURL @"/app/getIdentificationWeiXin.html"
//获取推荐用户排行榜(人数排行)
#define getSpreadUserURL @"/app/getSpreadUser.html"
#define getUserGuardList @"/app/getUserGuardList.html"
//首冲排行
#define getFirstChargeURL  @"/app/getFirstCharge.html"
//获取贡献金币用户列表
#define getUserMakeMoneyListURL @"/app/getUserMakeMoneyList.html"
//获取通话记录
#define getCallLogURL @"/app/getCallLog.html"
//获取地图主播信息
#define getUserDetaURL @"/app/getUserDeta.html"
//获取发起视频的推送消息
#define getUuserCoverCallURL @"/app/getUuserCoverCall.html"
//获取后台收费设置
#define getAnthorChargeListURL @"/app/getAnthorChargeList.html"
//获取主播亲密排行和礼物排行
#define getIntimateAndGiftURL @"/app/getIntimateAndGift.html"
//获取主播亲密度列表
#define getAnthorIntimateListURL @"/app/getAnthorIntimateList.html"
//获取礼物柜
#define getAnthorGiftListURL @"/app/getAnthorGiftList.html"
//获取banner
#define getIosBannerListURL @"/app/getIosBannerList.html"
#define getAllBannerList @"/app/getAllBannerList.html"
#define getNewBannerList @"/app/getNewBannerList.html"
//获取个人资料(含主播)
#define getMydataURL @"/app/getMydata.html"
//获取我的相册列表
#define getMyAnnualAlbumURL @"/app/getMyAnnualAlbum.html"
//获取距离
#define getAnthorDistanceList @"/app/getAnthorDistanceList.html"
//获取主播视频聊天收费最大值
#define getAnchorVideoCostURL @"/app/getAnchorVideoCost.html"
//获取用户贡献列表
#define getMyContributionListURL @"/app/getMyContributionList.html"
//获取版本是否上线
#define getIosSwitchURL @"/app/getIosSwitch.html"
//用户点赞
#define addLaudURL  @"/app/addLaud.html"
//用户取消点赞
#define cancelLaudURL  @"/app/cancelLaud.html"
//分享
//获取第三方登陆配置信息
#define getLongSetUpListURL @"/app/getLongSetUpList.html"
//获取VIP套餐列表
#define getVIPSetMealListURL @"/app/getVIPSetMealList.html"
//获取提现方式列表
#define getTakeOutModeURL @"/app/getTakeOutMode.html"
//申请CPS联盟
#define addCpsMsURL @"/app/addCpsMs.html"
//魅力榜
#define getGlamourListURL @"/app/getGlamourList.html"
//消费榜
#define getConsumeListURL @"/app/getConsumeList.html"
//豪礼榜
#define getCourtesyListURL @"/app/getCourtesyList.html"
//获取IM签名
#define getImUserSigUrl @"/app/getImUserSig.html"
//VIP支付
#define vipStoreValueURL @"/app/vipStoreValue.html"
//金币充值
 #define goldStoreValueURL @"/app/goldStoreValue.html"
//获取用户可提现金币
#define getUsableGoldURL @"/app/getUsableGold.html"

#define getWithdrawRuleApi @"/app/getWithdrawRule.html"

//更新提现资料
#define modifyPutForwardDataURL @"/app/modifyPutForwardData.html"
//修改用户性别
#define upateUserSexURL @"/app/upateUserSex.html"

//------------- 主页
//获取主页列表
 #define getHomePageListURL @"/app/getHomePageList.html"
//获取主播播放页数据
 #define getAnchorPlayPageURL @"/app/getAnchorPlayPage.html"
//获取banner列表
#define getBannerListURL @"/app/getBannerList.html"
//加载粉丝列表(加载用户列表)
#define getOnLineUserListURL @"/app/getOnLineUserList.html"
//拉取新用户注册推送
#define getPushMsgUrl @"/app/getPushMsg.html"
//获取推荐主播
#define getHomeNominateListURL @"/app/getHomeNominateList.html"
//获取试看主播列表
#define getTryCompereListURL @"/app/getTryCompereList.html"
//获取新人主播
#define getNewCompereListURL @"/app/getNewCompereList.html"

//获取我的关注列表
#define getFollowListURL @"/app/getFollowList.html"
#define getLikeListURL @"/app/getCoverFollowList.html"
//获取礼物赠送列表
#define getRewardListURL @"/app/getRewardList.html"
//获取短视频列表
#define getVideoListURL @"/app/getVideoList.html"
//同城列表
#define getCityWideListURL @"/app/getCityWideList.html"
//钱包头部统计(账号余额s收入支出)
#define getProfitAndPayTotalURL @"/app/getProfitAndPayTotal.html"
//获取钱包明细(账号余额收入支出列表)
#define getUserGoldDetailsURL @"/app/getUserGoldDetails.html"
//申请公会
#define applyGuildURL @"/app/applyGuild.html"
//获取公会主播贡献列表
#define getContributionListURL @"/app/getContributionList.html"
//统计公会主播数和贡献值
#define getGuildCountURL @"/app/getGuildCount.html"
//拉取是否邀请主播加入公会
#define getAnchorAddGuildURL  @"/app/getAnchorAddGuild.html"
//主播确认是否加入公会
#define isApplyGuildURL @"/app/isApplyGuild.html"
//获取公会主播贡献明细统计
#define getAnthorTotalURL @"/app/getAnthorTotal.html"
//公会主播贡献明细列表
#define getContributionDetailURL @"/app/getContributionDetail.html"
// ------------ 关注
//添加关注
#define saveFollowURL @"/app/saveFollow.html"
//取消关注
#define delFollowURL @"/app/delFollow.html"
//privateMapKey
#define getVideoChatPriavteMapKeyURL @"/app/getVideoChatPriavteMapKey.html"
//------------ 消息
//获取消息列表
#define getMessageListURL @"/app/getMessageList.html"
//获取未读消息数
#define getUnreadMessageURL @"/app/getUnreadMessage.html"
//设置为已读
#define setupReadURL @"/app/setupRead.html"
//删除消息
#define delMessageURL @"/app/delMessage.html"
//用户对主播发起聊天
 #define launchVideoChatURL @"/app/launchVideoChat.html"
//主播对用户发起聊天
#define anchorLaunchVideoChatURL @"/app/anchorLaunchVideoChat.html"
//开始计时
#define videoCharBeginTimingURL @"/app/videoCharBeginTiming.html"
//用户或主播挂断链接
#define userHangupLinkURL @"/app/userHangupLink.html"
//----------- 个人中心
//投诉用户
#define saveComplaintURL @"/app/saveComplaint.html"
//意见反馈
#define addFeedbackURL @"/app/addFeedback.html"
//历史反馈列表
#define getFeedBackListURL @"/app/getFeedBackList.html"
//历史反馈详情
#define getFeedBackByIdURL @"/app/getFeedBackById.html"
//删除用户标签
#define delUserLabelURL @"/app/delUserLabel.html"
//修改个人资料
#define updatePersonalDataURL @"/app/updatePersonalData.html"
//勿扰
#define setUpChatSwitchURL @"/app/setUpChatSwitch.html"
//获取标签列表
#define getLabelListURL @"/app/getLabelList.html"
//新增用户标签
#define saveUserLabelURL @"/app/saveUserLabel.html"
//获取主播收费设置
#define getAnchorChargeSetupURL @"/app/getAnchorChargeSetup.html"
//修改主播收费设置
#define updateAnchorChargeSetupURL  @"/app/updateAnchorChargeSetup.html"
//查看主播个人资料
#define getUserDataURL  @"/app/getUserData.html"
//获取以收到礼物列表
#define getGiveGiftListURL  @"/app/getGiveGiftList.html"
//获取未拆开的红包
#define getRedPacketCountURL  @"/app/getRedPacketCount.html"
//拆开红包
#define receiveRedPacketURL  @"/app/receiveRedPacket.html"
//获取主播评论标签列表
#define getEvaluationListURL  @"/app/getEvaluationList.html"
//获取视频上传签名
#define getVoideSignURL  @"/app/getVoideSign.html"
//获取他人照片或者视频列表
#define getDynamicListURL  @"/app/getAlbumList.html"
//查看他人个人资料
#define getUserPersonalDataURL  @"/app/getUserPersonalData.html"
//验证昵称是否重复
#define getNickRepeatURL  @"/app/getNickRepeat.html"
//获取个人资料
#define getPersonalDataURL  @"/app/getPersonalData.html"
//添加分享次数
#define addShareCountURL  @"/share/addShareCount.html"
//申请体现
#define confirmPutforwardURL @"/app/confirmPutforward.html"
//获取钱包消费或者提现明细
#define getWalletDetailURL @"/app/getWalletDetail.html"
//获取钱包日明细
#define getWalletDateDetailsURL @"/app/getWalletDateDetails.html"
//评价主播
#define saveCommentURL @"/app/saveComment.html"
//获取个人浏览记录
#define getBrowseListURL @"/app/getBrowseList.html"
//删除我的相册
#define delMyPhotoURL @"/app/delMyPhoto.html"
//获取我的相册
#define getMyPhotoListURL @"/app/getMyPhotoList.html"
//新增相册数据
#define addMyPhotoAlbumURL @"/app/addMyPhotoAlbum.html"
//获取我的私藏
#define getMyPrivateURL @"/app/getMyPrivate.html"
//视频聊天签名
#define getVideoChatAutographURL @"/app/getVideoChatAutograph.html"
//主播收益明细
#define getAnchorProfitDetailURL @"/app/getAnchorProfitDetail.html"
//个人钱包
#define getUserMoneyURL @"/app/getUserMoney.html"
//获取个人中心
#define indexURL @"/app/index.html"
//获取用户是否新用户
#define getUserNewURL @"/app/getUserNew.html"
//提交实名认证资料
#define submitIdentificationDataURL @"/app/submitIdentificationData.html"
//获取实名认证状态
#define getUserIsIdentificationURL @"/app/getUserIsIdentification.html"
//获取钱包余额
#define getQueryUserBalanceURL @"/app/getQueryUserBalance.html"
//提现比例
#define getPutforwardDiscountURL @"/app/getPutforwardDiscount.html"
//充值列表
#define getRechargeDiscountURL @"/app/getRechargeDiscount.html"
//用户赠送礼物
#define userGiveGiftURL @"/app/userGiveGift.html"
//用户或者主播挂断链接
#define breakLinkURL  @"/app/breakLink.html"
//版本更新
#define getIosVersionURL @"/app/getIosVersion.html"
//--------------- 消费
//发红包
#define sendRedEnvelopeURL @"/app/sendRedEnvelope.html"
//非VIP查看私密照片
#define seeImgConsumeURL @"/app/seeImgConsume.html"
//非VIP查看私密视频
#define seeVideoConsumeURL @"/app/seeVideoConsume.html"
//VIP查看私密视频或者照片
#define vipSeeDataURL @"/app/vipSeeData.html"
//非VIP发送文本消息
#define sendTextConsumeURL @"/app/sendTextConsume.html"
//查看微信
#define seeWeiXinConsumeURL @"/app/seeWeiXinConsume.html"
//查看微信
#define seeQQConsumeURL @"/app/seeQQConsume.html"
//查看手机号
#define seePhoneConsumeURL @"/app/seePhoneConsume.html"
//获取礼物列表
#define getGiftListURL @"/app/getGiftList.html"
//获取我的推广用户列表
#define getShareUserListURL @"/app/getShareUserList.html"
//推广赚钱
#define getShareTotalURL @"/app/getShareTotal.html"
//--------------- 附加接口
//修改用户(在离线)状态
#define updateAnchorOnlineURL @"/app/updateAnchorOnline.html"
//--------------- 附近
//上传坐标
#define uploadCoordinateURL @"/app/uploadCoordinate.html"
//获取附近的用户列表
#define getNearbyListURL @"/app/getNearbyList.html"

/*--------------------动态接口 2018-12-28 by liusenlin---------------------*/
//获取动态列表
#define getUserDynamicList @"/app/getUserDynamicList.html"
//获取主播个人动态列表
#define getPrivateDynamicList @"/app/getPrivateDynamicList.html"
//获取自己的动态
#define getOwnDynamicList  @"/app/getOwnDynamicList.html"
//添加点赞
#define giveTheThumbsUp @"/app/giveTheThumbsUp.html"
//发布动态
#define releaseDynamic  @"/app/releaseDynamic.html"
//获取设置私密金币
#define getPrivatePhotoMoney  @"/app/getPrivatePhotoMoney.html"
//动态图片或者视频消费
#define dynamicPay  @"/app/dynamicPay.html"
//动态评论列表
#define getCommentList  @"/app/getCommentList.html"
//动态发布评论
#define discussDynamic  @"/app/discussDynamic.html"
//删除动态评论
#define delComment      @"/app/delComment.html"
//绑定邀请码
#define uniteIdCard     @"/app/uniteIdCard.html"
//获取动态最新消息
#define getUserDynamicNotice     @"/app/getUserDynamicNotice.html"
//获取动态最新消息列表
#define getUserNewComment     @"/app/getUserNewComment.html"
//获取图形验证图
#define getVerify             @"/app/getVerify.html"
//验证图形验证码
#define getVerifyCodeIsCorrect   @"/app/getVerifyCodeIsCorrect.html"
//删除动态
#define deleteDynamic   @"/app/delDynamic.html"
//获取客户qq
#define serviceQQ       @"/app/getServiceQQ.html"

//帮助中心列表
#define getHelpCenterList    @"/app/getHelpContre.html"
//获取主播信息
#define getAnchorData        @"/app/getAnchorData.html"
//账号密码注册
#define registerPwd          @"/app/register.html"
//找回密码
#define findPwd              @"/app/upPassword.html"
//账号密码登录
#define pwdLogin             @"/app/userLogin.html"
//获取主播封面
#define anthorCover          @"/app/getUserCoverImg.html"
//获取分享域名地址
#define getShareUrl          @"/share/getSpreadUrl.html"

//上传封面
#define uploadDiscover       @"/app/replaceCoverImg.html"
//设置主封面
#define mainDiscover         @"/app/setMainCoverImg.html"
//删除封面
#define delDicover           @"/app/delCoverImg.html"
//支付方式列表
#define getPayTypeList       @"/app/getPayDeployList.html"
//广告
#define getAdTable           @"/app/getAdTable.html"

//三方设置
#define getThirdSetup          @"/app/getThirdSetup.html"

//获取im的标示
#define getNewImUserSign         @"/app/getNewImUserSign.html"
// 被浏览记录列表
#define getCoverBrowseList   @"/app/getCoverBrowseList.html"
// 语音通话页面 获取用户头像和昵称
#define getUserInfoById      @"/app/getUserInfoById.html"
#define getSelectCharAnother @"/app/getSelectCharAnother.html"

#define getVIPUserInfo       @"/app/getVIPUserInfo.html"
#define getOnlineAnoInfo     @"/app/getOnlineAnoInfo.html"
//验证验证码是否正确
#define getPhoneSmsStatus    @"/app/getPhoneSmsStatus.html"
// 用户一键随机获取主播的封面图 5张
#define getAnoCoverImg @"/app/getAnoCoverImg.html"
// 添加黑名单
#define addBlackUser @"/app/addBlackUser.html"
// 移除黑名单
#define delBlackUser @"/app/delBlackUser.html"
// 黑名单列表
#define getBlackUserList @"/app/getBlackUserList.html"

//im消息敏感词汇
#define getImFilter     @"/app/getImFilter.html"

#define getOcrFilter     @"/app/getOcrFilter.html"
//语音通话是否需要录音
#define getSounRecordingSwitch @"/app/getSounRecordingSwitch.html"
//上传录音文件
#define saveSounRecording @"/app/saveSounRecording.html"
//主播置顶
#define getTopping         @"/app/setOperatingTopping.html"

//视屏截图鉴黄-------
//获取鉴黄结果
#define getQiNiuKey   @"/app/getQiNiuKey.html"
//获取是否需要截图的状态
#define getVideoScreenshotStatus @"/app/getVideoScreenshotStatus.html"
//上传鉴黄成功的图片
#define addVideoScreenshotInfo @"/app/addVideoScreenshotInfo.html"
#define addOcrScreenshotInfo @"/app/addOcrScreenshotInfo.html"
//轮询
#define getVideoStatus @"/app/getVideoStatus.html"
//守护礼物信息
#define getGuard @"/app/getGuard.html"
//免费私信条数
#define privateLetterNumber @"/app/privateLetterNumber.html"
#define greetToAnchor @"/app/greet.html"
#define vipSwitch @"/app/svipSwitch.html"
//设置为视频封面
#define setFirstAlbum @"/app/setFirstAlbum.html"
//封号
#define userDisable @"/app/userDisable.html"
//查看是否绑定
#define getReferee @"/app/getReferee.html"
//新版本微信登录
#define userWeixinLogin @"/app/userWeixinLogin.html"
#define getIMToUserMesList @"/app/getIMToUserMesList.html"
#define sendIMToUserMes @"/app/sendIMToUserMes.html"
#define getAgoraRoomSign @"/app/getAgoraRoomSign.html"
#define getServiceId @"/app/getServiceId.html"
#define receiveRankGold @"/app/receiveRankGold.html"
#define getSystemConfig @"/app/getSystemConfig.html"
#define getAutoExamineSetup @"/app/getAutoExamineSetup.html"
#define getRankConfig @"/app/getRankConfig.html"
#define getShareRewardConfigList @"/app/getShareRewardConfigList.html"
#define receiveShareRewardGold @"/app/receiveShareRewardGold.html"
#define getUserRankInfo @"/app/getUserRankInfo.html"
#define getNewFirstChargeInfo @"/app/getNewFirstChargeInfo.html"
#define getNewEvaluationList @"/app/getNewEvaluationList.html"
#define getUserGuardGiftList @"/app/getUserGuardGiftList.html"
#define getVideoComsumerInfo @"/app/getVideoComsumerInfo.html"
#define getcertifyStatus @"/app/getcertifyStatus.html"


#define getExtractAuth @"/app/getExtractAuth.html"
#define getHasPayPass @"/app/getHasPayPass.html"
#define upPayPassword @"/app/upPayPassword.html"
#define sendMoneyVerificationCode @"/app/sendMoneyVerificationCode.html"

#define isPushDynamic @"/app/isPushDynamic.html"

//腾讯临时密钥获取
#define getTencentTempApi @"/app/getTencentCloudConfig.html"
//声网appid
#define getAgoraAppid @"/app/getRtcConfig.html"

#define getTencentCloudConfig "/app/getTencentCloudConfig.html"



#define OperationSuccess 1
#define OperationFail   0
#define otherFail   2

//#define appid @"wxce672b86d746edf9"



#define code [dataBody[@"m_istatus"]intValue]

@interface YLNetworkInterface ()

@end

@implementation YLNetworkInterface

#pragma mark ---- 腾讯云对象存储
+ (void)getTencentTempApiData:(JSONTencentApiBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getTencentTempApi];

    [APIManager requestWithChatPath:urlStr Param:@{@"userId":@"0"} success:^(id dataBody) {
        if (code == OperationSuccess) {
            block(dataBody[@"m_object"]);
        }else{
            block(nil);
        }
    } failed:^(NSString *error) {
        block(nil);
    }];
}

+ (void)getAgoraAppId:(JSONAroraAppId)block{
//    NSString *urlStr = [self getServiceIPUrl:getAgoraAppid];
//    [APIManager requestGETWithChatPath:urlStr Param:@{} success:^(id dataBody) {
//        
//        if (code == OperationSuccess) {
//            block(dataBody[@"m_object"]);
//        }else{
//            block(nil);
//        }
//        
//    } failed:^(NSString *error) {
//        block(nil);
//    }];
    
}

#pragma mark +++++++++++++++++++++++++++++++ 登录注册
#pragma mark ---- 发送短信验证码
+ (void)sendPhoneVerificationCode:(NSString *)phone
              sendVericationBlock:(JSONBOOLBlock)block restype:(int)resType verifyCode:(NSString *)verifyCode
{
    NSString *urlStr = [self getServiceIPUrl:sendPhoneVerificationCodeURL];
    
    [SVProgressHUD showWithStatus:@"正在发送验证码..."];
    [APIManager requestWithChatPath:urlStr Param:@{@"phone":phone,@"resType":[NSNumber numberWithInt:resType],@"verifyCode":verifyCode} success:^(id dataBody) {
        [SVProgressHUD dismiss];

        if (code == OperationSuccess) {
            [SVProgressHUD showInfoWithStatus:@"短信发送成功,请注意查收"];

            block(YES);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            
            block(NO);
        }
    } failed:^(NSString *error) {
        [SVProgressHUD dismiss];
        block(NO);
    }];
}

+ (void)getStyleSetUp:(JSONTokenStampBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getStyleSetUpURL];

    [APIManager requestWithChatPath:urlStr Param:@{@"userId":@([YLUserDefault userDefault].t_id)} success:^(id dataBody) {

        if (code == OperationSuccess) {
            block([dataBody[@"m_object"] objectForKey:@"t_mark"]);
        }else{
            block(@"one");
        }
    } failed:^(NSString *error) {
        block(@"one");
    }];
}

#pragma mark ---- 账号密码登录
+ (void)login:(NSString *)phone
      smsCode:(NSString *)smsCode
t_system_version:(NSString *)t_system_version
 t_ip_address:(NSString *)t_ip_address
    t_channel:(NSString *)channelid
   loginBlock:(JSONHaveSexBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:loginURL];
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    [SVProgressHUD showWithStatus:@"正在登录中..."];
    [APIManager requestWithChatPath:urlStr      Param:@{@"phone":phone,@"smsCode":smsCode,@"t_phone_type":@"iPhone",@"t_system_version":t_system_version,@"t_ip_address":t_ip_address,@"deviceNumber":identifierStr,@"shareUserId":@([channelid integerValue]),@"ip":[SLHelper getIPaddress]}
                       success:^(id dataBody) {

        [SVProgressHUD dismiss];
        
        if (code == OperationSuccess) {
            [self judgeLogin:dataBody block:block];
        }else if(code == 0){
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO,NO,NO,@"");
        }else if (code == -200){
            [SVProgressHUD showInfoWithStatus:@"该设备已注册过账号，请勿重复注册"];
            block(NO,NO,NO,@"");
        }else if (code == -1){
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO,NO,NO,@"");
        }else{
            block(NO,NO,YES,dataBody[@"m_strMessage"]);
        }
    } failed:^(NSString *error) {
        [SVProgressHUD dismiss];
        block(NO,NO,NO,@"");
    }];
}


+ (void)judgeLogin:(id)dataBody block:(JSONHaveSexBlock)block
{
    NSDictionary *m_objectDic = dataBody[@"m_object"];
    
    if ([m_objectDic[@"t_token"] isKindOfClass:[NSString class]]) {
        NSString *t_token = m_objectDic[@"t_token"];
        if (t_token.length > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:t_token forKey:@"T_TOKEN"];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"T_TOKEN"];
    }
    
    NSString *nickName = [NSString stringWithFormat:@"%@",m_objectDic[@"t_nickName"]];
    NSString *headImage = [NSString stringWithFormat:@"%@",m_objectDic[@"t_handImg"]];
    
    //保存昵称和头像地址
    [SLDefaultsHelper saveSLDefaults:nickName key:@"user_nick_name"];
    if (![headImage isEqualToString:@"(null)"]) {
        [SLDefaultsHelper saveSLDefaults:headImage key:@"user_head_image"];
    } else {
        [SLDefaultsHelper saveSLDefaults:@"" key:@"user_head_image"];
    }
    
    [YLUserDefault saveUserDefault:m_objectDic[@"gold"] t_id:m_objectDic[@"t_id"] t_is_vip:m_objectDic[@"t_is_vip"] t_role:m_objectDic[@"t_role"]];
    
    [YLUserDefault saveCity:[NSString stringWithFormat:@"%@", m_objectDic[@"t_city"]]];
    
    
//    NSString *t_phone_status = [NSString stringWithFormat:@"%@", m_objectDic[@"t_phone_status"]];
//    [[NSUserDefaults standardUserDefaults] setObject:t_phone_status forKey:@"t_phone_status"];
     
     
     
    if (![m_objectDic objectForKey:@"t_sex"]) {
        if (block) {
            block(YES,NO,NO,@"");
        }
        
    }
    Class sexClass = [[m_objectDic objectForKey:@"t_sex"] class];
    if (![sexClass isEqual:[NSString class]] && ![sexClass isEqual:[NSNull class]])
    {
        int sex = [[m_objectDic objectForKey:@"t_sex"] intValue];
        if (sex == 1 || sex == 0) {
            [YLUserDefault saveSex:m_objectDic[@"t_sex"]];
            if (block) {
                block(YES,YES,NO,@"");
            }
            
        }else{
            if (block) {
                block(YES,NO,NO,@"");
            }
        }
    }else{
        //为null类型
        if (block) {
            block(YES,NO,NO,@"");
        }
    }
}

#pragma mark ---- 修改手机号
+ (void)updatePhone:(int)userId phone:(NSString *)phone smsCode:(NSString *)smsCode block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:updatePhoneURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"phone":phone,@"smsCode":smsCode} success:^(id dataBody) {
        if (code == OperationSuccess) {
            [SVProgressHUD showInfoWithStatus:@"手机号修改成功"];
            block(YES);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO);
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark --- 验证短信验证码是否正确
+ (void)verificationPhoneSmsCode:(int)userId phone:(NSString *)phone smsCode:(NSString *)smsCode block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getPhoneSmsStatus];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"phone":phone,@"smsCode":smsCode} success:^(id dataBody) {
        if (code == OperationSuccess) {
            block(YES);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO);
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark --- 获取认证过后的客服微信
+ (void)getIdentificationWeiXin:(int)userId block:(JSONTokenStampBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getIdentificationWeiXinURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSString *m_object = dataBody[@"m_object"];
            
            block(m_object);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        
    }];
}



#pragma mark ---- 距离

/**
 距离
id
 @param userId 用户id
 @param page 页面
 @param lat 经度
 @param lng 纬度
 @param block 返回数组
 */
+ (void)getAnthorDistanceListUserd:(int)userId page:(int)page lat:(double)lat lng:(double)lng block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getAnthorDistanceList];
    
    NSMutableArray *listArray = [NSMutableArray array];
    //,@"lat":[NSNumber numberWithDouble:lat],@"lng":[NSNumber numberWithDouble:lng]
    [APIManager requestWithChatPath:urlStr
                         Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]}
                        success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            NSArray *dataArray = m_objectDic[@"data"];
            
            for (NSDictionary *dic in dataArray) {
                distanceHandle *handle = [distanceHandle mj_objectWithKeyValues:dic];
                handle.page = [m_objectDic[@"total"] intValue];
                
                [listArray addObject:handle];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        block(listArray);
    } failed:^(NSString *error) {
    }];
}

#pragma mark --- 获取主播视频聊天收费最大值
+ (void)getAnchorVideoCost:(int)userId block:(JSONRedPacketBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getAnchorVideoCostURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            int m_object = [dataBody[@"m_object"] intValue];
            
            block(m_object);
        }else{
            block(0);
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 获取未读消息数

+ (void)getUnreadMessage:(int)userId block:(void (^)(int systemCode,NSString *errorMsg, int mansionCount))block
{
    NSString *urlStr = [self getServiceIPUrl:getUnreadMessageURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {

        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            NSDictionary *dataDic = m_objectDic[@"data"];
            int mansionCount = [[NSString stringWithFormat:@"%@", m_objectDic[@"mansionCount"]] intValue];
            block([m_objectDic[@"totalCount"] intValue],dataDic[@"t_message_content"], mansionCount);
        }else{
            block(0,@"点击查看更多消息!", 0);
        }
    } failed:^(NSString *error) {
        block(0,@"点击查看更多消息!", 0);
    }];
}

#pragma mark ---- 同城列表
+ (void)getCityWideList:(int)userId page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getCityWideListURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            NSArray *dataArray = m_objectDic[@"data"];
            
            for (NSDictionary *dic in dataArray) {
                attentionInfoHandle *attentionHandle = [attentionInfoHandle mj_objectWithKeyValues:dic];
                attentionHandle.pageCount       = [m_objectDic[@"pageCount"] intValue];
                
                [listArray addObject:attentionHandle];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        block(listArray);
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 主播收益明细

/**
 主播收益明细

 @param userId 主播编号
 @param queryType 1.日2.周3.月4.总
 */
+ (void)getAnchorProfitDetail:(int)userId queryType:(int)queryType block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getAnchorProfitDetailURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId],@"queryType":[NSNumber numberWithInt:queryType]}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             NSArray *m_objectArray = dataBody[@"m_object"];
            
             for (int i = 0; i < [m_objectArray count]; i++) {
                 NSDictionary *dic = m_objectArray[i];
                 rankingHandle *handle = [rankingHandle mj_objectWithKeyValues:dic];
                 
                 if (i > 0) {
                     rankingHandle *oldHandle = listArray[i-1];
                     handle.newGold = oldHandle.gold - handle.gold;
                 }
                 
                 [listArray addObject:handle];
             }
             
         }
         block(listArray);
     } failed:^(NSString *error) {
     }];
}

#pragma mark ---- 获取后台主播设置
+ (void)getAnthorChargeList:(int)userId block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getAnthorChargeListURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId]}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             NSArray *m_objectArray = dataBody[@"m_object"];
             
             for (NSDictionary *dic in m_objectArray) {
                 anchorChargeSetupHandle *handle = [anchorChargeSetupHandle mj_objectWithKeyValues:dic];
                 
                 [listArray addObject:handle];
             }
             
             block(listArray);
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }
     } failed:^(NSString *error) {
     }];
}

#pragma mark---- 拉取新用户注册推送
+ (void)getPushMsg:(int)userId
{
    NSString *urlStr = [self getServiceIPUrl:getPushMsgUrl];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId]}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {

         }else{

         }
     } failed:^(NSString *error) {
     }];
}

#pragma mark ---- 投诉用户
/**
 投诉用户

 @param userId 投诉人
 @param coverUserId 被投诉人
 @param comment 投诉内容
 @param img 投诉图片(多张图片已,隔开)
 */
+ (void)saveComplaintUserId:(int)userId coverUserId:(int)coverUserId comment:(NSString *)comment img:(NSString *)img block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:saveComplaintURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId],@"coverUserId":[NSNumber numberWithInt:coverUserId],@"comment":comment,@"img":img}
                            success:^(id dataBody)
    {
        if (code == OperationSuccess) {
            block(YES);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO);
        }
    } failed:^(NSString *error) {
        block(NO);
    }];
}


+ (void)saveComplaintWithCoverUserId:(int)coverUserId comment:(NSString *)comment img:(NSString *)img phone:(NSString *)phone tcode:(NSString *)tcode block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:saveComplaintURL];
    NSDictionary *param = @{@"userId":[NSNumber numberWithInt:[YLUserDefault userDefault].t_id],
                            @"coverUserId":[NSNumber numberWithInt:coverUserId],
                            @"comment":comment,
                            @"img":img,
                            @"t_phone":[NSString stringWithFormat:@"%@",phone],
                            @"t_code":[NSString stringWithFormat:@"%@", tcode]
    };
    
    [APIManager requestWithChatPath:urlStr
                              Param:param
                            success:^(id dataBody)
    {
        if (code == OperationSuccess) {
            block(YES);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO);
        }
    } failed:^(NSString *error) {
        block(NO);
    }];
}

#pragma mark ---- 意见反馈

/**
 意见反馈

 @param userId 用户id
 @param phone 电话
 @param content 意见反馈内容
 @param imgUrl 用逗号分隔的图片地址
 @param block 返回提交成功与否
 */
+ (void)addFeedbackUserId:(int)userId phone:(NSString *)phone content:(NSString *)content t_img_url:(NSString *)imgUrl block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:addFeedbackURL];
    NSDictionary *dic = @{@"userId":[NSNumber numberWithInt:userId],@"t_phone":phone,@"content":content,@"t_img_url":imgUrl};
    
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             [SVProgressHUD showInfoWithStatus:@"您的意见反馈已提交成功"];
             block(YES);
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
             block(NO);
         }
     } failed:^(NSString *error) {
         block(NO);
     }];
}

#pragma mark ---- 历史意见反馈列表
+ (void)getFeedBackList:(int)userId page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getFeedBackListURL];
    NSDictionary *dic = @{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]};
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             NSArray *data = [dataBody[@"m_object"] objectForKey:@"data"];
             for (NSDictionary *dic in data) {
                 feedBackHandle *handle = [feedBackHandle mj_objectWithKeyValues:dic];

                 [listArray addObject:handle];
             }
             
             block(listArray);
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
             block(listArray);
         }
     } failed:^(NSString *error) {
         block(listArray);
     }];
}


#pragma mark ---- 历史反馈详情
+ (void)getFeedBackById:(int)feedBackId block:(JSONFeedBackDetailHandleBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getFeedBackByIdURL];
    NSDictionary *dic = @{@"feedBackId":[NSNumber numberWithInt:feedBackId],@"userId":@([YLUserDefault userDefault].t_id)};
    
//    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             NSDictionary *dic = dataBody[@"m_object"];
             feedbackDetailHandle *handle = [feedbackDetailHandle mj_objectWithKeyValues:dic];

             block(handle);
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
//             block(listArray);
         }
     } failed:^(NSString *error) {
     }];
}


#pragma mark ---- 设置为已读
+ (void)setupReadMessage
{
    NSString *urlStr = [self getServiceIPUrl:setupReadURL];

    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInteger:[YLUserDefault userDefault].t_id]} success:^(id dataBody)
    {
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 删除消息
+ (void)delMessageId:(int)messageId
{
    NSString *urlStr = [self getServiceIPUrl:delMessageURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"messageId":[NSNumber numberWithInt:messageId],@"userId":@([YLUserDefault userDefault].t_id)} success:^(id dataBody)
     {
     } failed:^(NSString *error) {
         
     }];
}

#pragma mark ---- 获取banner列表
+ (void)getBannerList:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getBannerListURL];
    
    NSMutableArray *bannerListArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":@([YLUserDefault userDefault].t_id)} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSArray *m_objectArray = dataBody[@"m_object"];
            
            for (NSDictionary *dic in m_objectArray) {
                bannerHandle *handle = [bannerHandle mj_objectWithKeyValues:dic];
                
                [bannerListArray addObject:handle];
            }
        }
        block(bannerListArray);
    } failed:^(NSString *error) {
        
    }];
}

+(void)getisPushDynamic:(NSInteger)userid :(JSONBOOLBlock)block{
    NSString *urlStr = [self getServiceIPUrl:isPushDynamic];
    
    NSMutableArray *bannerListArray = [NSMutableArray array];
    
    [APIManager requestGETWithChatPath:urlStr Param:@{@"userId":@(userid)} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *m_objectArray = dataBody[@"m_object"];
            if ([m_objectArray safeBoolForKey:@"exists"]){
                block(YES);
            }else{
                block(NO);
            }
          
        }
       
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 获取我的关注列表
+ (void)getFollowList:(int)userId page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getFollowListURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]} success:^(id dataBody) {

        [SVProgressHUD dismiss];
        
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            NSArray *dataArray = m_objectDic[@"data"];
            
            for (NSDictionary *dic in dataArray) {
                attentionInfoHandle *attentionHandle = [attentionInfoHandle mj_objectWithKeyValues:dic];
                attentionHandle.pageCount       = [m_objectDic[@"pageCount"] intValue];
                
                [listArray addObject:attentionHandle];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        
        block(listArray);
    } failed:^(NSString *error) {
    }];
}

+ (void)getLikeListWithPage:(int)page type:(int)type block:(JSONObjectBlock)block {
    NSString *urlStr = [self getServiceIPUrl:getLikeListURL];
    NSDictionary *param = @{@"userId":[NSNumber numberWithInt:[YLUserDefault userDefault].t_id],
                            @"page":[NSNumber numberWithInt:page],
                            @"type":[NSString stringWithFormat:@"%d", type]
    };
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:param success:^(id dataBody) {

        [SVProgressHUD dismiss];
        
        if (code == OperationSuccess) {
            NSArray *dataArray = dataBody[@"m_object"];
            
            for (NSDictionary *dic in dataArray) {
                attentionInfoHandle *attentionHandle = [attentionInfoHandle mj_objectWithKeyValues:dic];
                [listArray addObject:attentionHandle];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        
        block(listArray);
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 添加关注

/**
 添加关注

 @param followUserId 关注人
 @param coverFollowUserId 被关注人
 */
+ (void)addAttention:(int)followUserId coverFollowUserId:(int)coverFollowUserId block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:saveFollowURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:followUserId],@"coverFollowUserId":[NSNumber numberWithInt:coverFollowUserId]} success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            block(YES);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO);
        }
    } failed:^(NSString *error) {
        block(NO);
    }];
}

#pragma mark ---- 取消关注

/**
 取消关注

 @param followId 关注人
 @param coverFollow 被关注人
 */
+ (void)cancelAtttention:(int)followId coverFollowUserId:(int)coverFollow block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:delFollowURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:followId],@"coverFollow":[NSNumber numberWithInt:coverFollow]} success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            block(YES);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO);
        }
    } failed:^(NSString *error) {
        block(NO);
    }];
}

#pragma mark ---- 获取消息列表
+ (void)getMessageList:(int)userId page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getMessageListURL];
    
    NSMutableArray *msgListArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]} success:^(id dataBody) {
        
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            
            if (m_objectDic.allKeys.count != 0) {
                for (NSDictionary *dic in m_objectDic[@"data"]) {
                    sytemMsgHandle *handle = [sytemMsgHandle mj_objectWithKeyValues:dic];
                    handle.pageCount       = [m_objectDic[@"pageCount"] intValue];

                    [msgListArray addObject:handle];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:@"暂无系统消息"];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:@"获取系统消息失败"];
        }
        block(msgListArray);
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 获取我的私藏
+ (void)getMyPrivateList:(int)userId page:(int)page
{
    NSString *urlStr = [self getServiceIPUrl:getMyPrivateURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            
        }else{
            
        }
    } failed:^(NSString *error) {
    }];
}


#pragma mark ---- 奖励规则
+ (void)getSpreadAward:(int)userId block:(JSONTokenStampBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getSpreadAwardURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            NSDictionary *dic = dataBody[@"m_object"];
            
            block(dic[@"t_award_rules"]);
        }
    } failed:^(NSString *error) {
    }];
    
}


#pragma mark ---- 获取后台发起视频的推送消息
+ (void)getUuserCoverCal:(int)userId block:(JSONVideoPushBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getUuserCoverCallURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {

        if (code == OperationSuccess) {
            id obj = dataBody[@"m_object"];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                block(obj);
            }
        }
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 获取地图的主播信息
+ (void)getUserDeta:(int)userId coverSeeUserId:(int)coverSeeUserId lat:(double)lat lng:(double)lng block:(JSONMapAnchorBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getUserDetaURL];

    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"coverSeeUserId":[NSNumber numberWithInt:coverSeeUserId],@"lat":[NSNumber numberWithDouble:lat],@"lng":[NSNumber numberWithDouble:lng]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            newAnchorHandle *anchorHandle = [newAnchorHandle mj_objectWithKeyValues:m_objectDic];
            block(anchorHandle);
        }else{
            block(nil);
        }
    } failed:^(NSString *error) {
        block(nil);
    }];
}

#pragma mark +++++++++++++++++++++++++++++++ 个人中心
#pragma mark ---- 获取个人资料
+ (void)getPersonalData:(int)userId personalData:(JSONHandleBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getPersonalDataURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {

        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            PersonalDataHandle *pdataHandle = [PersonalDataHandle mj_objectWithKeyValues:m_objectDic];

            block(pdataHandle);
        }else{
//            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 获取个人资料(含主播)
+ (void)getMydata:(int)userId block:(JSONHandleBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getMydataURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {
        
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            PersonalDataHandle *pdataHandle = [PersonalDataHandle mj_objectWithKeyValues:m_objectDic];
            
            
            block(pdataHandle);
        }else{
//            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
    }];
}


#pragma mark ---- 账号余额(收入支出)
+ (void)getProfitAndPayTotal:(int)userId year:(int)year month:(int)month block:(JSONAcccountBalanceBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getProfitAndPayTotalURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"year":[NSNumber numberWithInt:year],@"month":[NSNumber numberWithInt:month]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            //pay 支出金币 profit 收益金币
            block([m_objectDic[@"pay"] intValue],[m_objectDic[@"profit"] intValue]);
        }else{
            block(0,0);//错误 收入支出返回0
        }
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 账号余额(列表)

/**
 账号余额(列表)

 @param userId 用户编号
 @param year 年
 @param month 月
 @param queryType 查询类型 -1：全部 0.收入 1.支出
 @param page 页码
 */
+ (void)getUserGoldDetails:(int)userId year:(int)year month:(int)month queryType:(int)queryType page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getUserGoldDetailsURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"year":[NSNumber numberWithInt:year],@"month":[NSNumber numberWithInt:month],@"queryType":[NSNumber numberWithInt:queryType],@"page":[NSNumber numberWithInt:page]} success:^(id dataBody) {
        
        if (code == OperationSuccess) {
        if (![dataBody[@"m_object"] isKindOfClass:[NSDictionary class]]) return;
        NSDictionary *m_objectDic = dataBody[@"m_object"];
        
            
        if (m_objectDic.allKeys.count != 0) {
            for (NSDictionary *dic in m_objectDic[@"data"]) {
                newBalanceHandle *handle = [newBalanceHandle mj_objectWithKeyValues:dic];
                handle.pageCount         = [m_objectDic[@"pageCount"] intValue];
                
                [listArray addObject:handle];
            }
        }
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        block(listArray);
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 验证昵称是否重复
+ (void)getNickRepeat:(NSString *)nickName
{
    NSString *urlStr = [self getServiceIPUrl:getNickRepeatURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"nickName":nickName,@"userId":@([YLUserDefault userDefault].t_id)} success:^(id dataBody) {

        if (code == OperationSuccess) {
//            NSDictionary *m_objectDic = dataBody[@"m_object"];
//            PersonalDataHandle *pdataHandle = [PersonalDataHandle mj_objectWithKeyValues:m_objectDic];
        }else{
        }
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 申请体现

/**
 申请体现

 @param dataId 提现或者充值数据ID
 @param userId 用户编号
 */
+ (void)confirmPutforward:(int)dataId userId:(int)userId putForwardId:(int)putForwardId withpaypass:(NSString *)paypass block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:confirmPutforwardURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"paypass":paypass,@"dataId":[NSNumber numberWithInt:dataId],@"userId":[NSNumber numberWithInt:userId],@"putForwardId":[NSNumber numberWithInt:putForwardId]}
                            success:^(id dataBody) {

        if (code == OperationSuccess) {

            [SVProgressHUD showInfoWithStatus:@"申请提现成功"];
            block(YES);
        }else{
            if (dataBody[@"m_strMessage"] != nil)
            {
                if (code == 99) {
                    block(NO);
                }
                
                [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"申请提现失败"];
            }
        }
    } failed:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:@"申请提现失败"];
    }];
}

#pragma mark ---- 获取钱包消费或者提现明细

/**
 获取钱包消费或者提现明细

queyType 1.收入明细 2.支出明细 3.充值明细 4.提现明细
userId 用户编号
year 年
month 月
state (提现明细时传递)状态  0.未审核1.提现成功2.提现失败
page 页码
 */
+ (void)getWalletDetailType:(NSDictionary *)dic block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getWalletDetailURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr
                              Param:dic
                            success:^(id dataBody)
    {
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            if (m_objectDic.allKeys.count != 0) {

                for (NSDictionary *dic in m_objectDic[@"data"]) {
                    incomeDetailHandle *handle = [incomeDetailHandle mj_objectWithKeyValues:dic];
                    if ([m_objectDic.allKeys containsObject:@"monthTotal"]) {
                        handle.monthTotal = [m_objectDic[@"monthTotal"] intValue];
                    }
                    
                    [listArray addObject:handle];
                }
            }
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
                                
        block(listArray);
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 更新提现资料

/**
 更新提现资料

 @param userId 用户编号
 @param t_real_name 真实姓名
 @param t_nick_name 三方昵称
 @param t_account_number 支付宝账号或者微信的openId
 @param t_type 类型：0.支付宝1.微信
 */
+ (void)modifyPutForwardData:(int)userId t_real_name:(NSString *)t_real_name t_nick_name:(NSString *)t_nick_name t_account_number:(NSString *)t_account_number t_type:(int)t_type t_head_img:(NSString *)t_head_img qrCodeUrl:(NSString *)qrCodeUrl withSmscode:(NSString *)smscode block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:modifyPutForwardDataURL];
    

    [APIManager requestWithChatPath:urlStr
                         Param:@{@"userId":[NSNumber numberWithInt:userId]
                           ,@"t_real_name":t_real_name,@"smsCode":smscode
                            ,@"t_head_img":t_head_img
                       ,@"t_account_number":t_account_number
                               ,@"t_type":[NSNumber numberWithInt:t_type]
                                 ,@"qrCodeUrl":qrCodeUrl
                                 }
                            success:^(id dataBody)
    {
        if (code == OperationSuccess) {
            [SVProgressHUD showInfoWithStatus:@"绑定成功"];
            block(YES);
        }else{
            if (dataBody[@"m_strMessage"] != nil)
            {
                [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"绑定失败"];
            }
            block(NO);
        }
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 获取钱包日明细

/**
 获取钱包日明细

 @param state 1.收入明细 2.支出明细 3.充值明细
 @param userId 用户id
 @param time 年月日 2018-06-14
 @param page 页码
 */
+ (void)getWalletDateDetailstate:(int)state userId:(int)userId time:(NSString *)time page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getWalletDateDetailsURL];
    NSDictionary *dic = @{@"state":[NSNumber numberWithInt:state],@"userId":[NSNumber numberWithInt:userId],@"time":time,@"page":[NSNumber numberWithInt:page]};
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr
                         Param:dic
                       success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            if (m_objectDic.allKeys.count != 0) {
                for (NSDictionary *dic in m_objectDic[@"data"]) {
                    incomeDetailHandle *handle = [incomeDetailHandle mj_objectWithKeyValues:dic];
                    handle.pageCount         = [m_objectDic[@"pageCount"] intValue];

                    [listArray addObject:handle];
                }
            }
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        
        block(listArray);
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 视频聊天签名
+ (void)getVideoChatAutograph:(int)userId anchorId:(int)anchorId block:(JSONVideoChatAutographBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getVideoChatAutographURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"anthorId":[NSNumber numberWithInt:anchorId]} success:^(id dataBody) {
        
        if (code == OperationSuccess) {
            NSDictionary *objectDic = dataBody[@"m_object"];
            
//            NSString *userSig = objectDic[@"userSig"];
            NSString *userSig = [NSString stringWithFormat:@"%@", objectDic[@"rtcToken"]];
            int roomId = [objectDic[@"roomId"] intValue];
            
            int onlineState = 0;
            if ([objectDic.allKeys containsObject:@"onlineState"]) {
                onlineState = [objectDic[@"onlineState"] intValue];
            }
            
            //如果1需要提醒用户充值
            block(userSig,roomId,onlineState);
        } else if (code == -7) {
            [SVProgressHUD dismiss];
            [LXTAlertView vipWithContet:dataBody[@"m_strMessage"]];
            if (block) {
                block(@"-1", -1, -1);
            }
        } else {
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        
    }];
}

+ (void)getVideoChatPriavteMapKey:(int)userId roomId:(int)roomId block:(JSONTokenStampBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getVideoChatPriavteMapKeyURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"roomId":[NSNumber numberWithInt:roomId]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSString *m_object = dataBody[@"m_object"];
            
            block(m_object);
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 获取主播个人资料
+ (void)getGodnessUserData:(int)seeUserId coverUserId:(int)coverUserId block:(JSONGodNessInfoHandleBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getUserDataURL];
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:seeUserId],@"coverUserId":[NSNumber numberWithInt:coverUserId]} success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {

            NSDictionary *dic = dataBody[@"m_object"];
            godnessInfoHandle *handle = [godnessInfoHandle mj_objectWithKeyValues:dic];
            
            block(handle);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 获取主播播放页数据
/**
 获取主播播放页数据

 @param consumeUserId 查看人编号
 @param coverConsumeUserId 被查看人编号
 */
+ (void)getAnchorPlayPage:(int)consumeUserId albumId:(int)albumId coverConsumeUserId:(int)coverConsumeUserId queryType:(int)queryType block:(JSONVideoPlayBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getAnchorPlayPageURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:consumeUserId],@"albumId":[NSNumber numberWithInt:albumId],
                                                   @"coverConsumeUserId":[NSNumber numberWithInt:coverConsumeUserId],@"queryType":@(queryType)}
                            success:^(id dataBody)
     {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            NSDictionary *dic = dataBody[@"m_object"];
            videoPayHandle *handle = [videoPayHandle mj_objectWithKeyValues:dic];

            block(handle);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
    }];
}


#pragma mark ---- 加载粉丝列表

/**
 加载粉丝列表

 @param userId 当前人用户编号
 @param page 当前页码
 @param searchType -1:全部 0.女 1.男
 @param search 昵称 or id号
 */
+ (void)getOnLineUserList:(int)userId page:(int)page searchType:(int)searchType search:(NSString *)search block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getOnLineUserListURL];
    
    NSDictionary *dic = @{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page],@"searchType":[NSNumber numberWithInt:searchType]};
    if (![NSString isNullOrEmpty:search]) {
        dic = @{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page],@"searchType":[NSNumber numberWithInt:searchType],@"search":search};
    }
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];

            for (NSDictionary *dic in m_objectDic[@"data"]) {
                fansListHandle *handle = [fansListHandle mj_objectWithKeyValues:dic];
                handle.pageCount       = [m_objectDic[@"pageCount"] intValue];

                
                [listArray addObject:handle];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        block(listArray);
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 获取主播评论
+ (void)getEvaluationList:(int)userId block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getEvaluationListURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSArray *m_objectArray = dataBody[@"m_object"];
            for (NSDictionary *dic in m_objectArray) {
                userCommentHandle *handle = [userCommentHandle mj_objectWithKeyValues:dic];

                [listArray addObject:handle];
            }
        }
        block(listArray);
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 获取我的相册列表
+ (void)getMyAnnualAlbum:(int)type page:(NSInteger)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getMyAnnualAlbumURL];
    
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:[YLUserDefault userDefault].t_id],@"page":@(page),@"type":[NSString stringWithFormat:@"%d", type]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSMutableArray *listArray = [NSMutableArray array];
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            NSArray *array = m_objectDic[@"data"];
            
            for (NSDictionary *dic in array) {
                newAlbumHandle *handle = [newAlbumHandle mj_objectWithKeyValues:dic];
                
                [listArray addObject:handle];
            }
            block(listArray);
            
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 获取主播照片或视频
+ (void)getGodNessPhotoOrVideoList:(int)seeUserId coverUserId:(int)coverUserId page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getDynamicListURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:seeUserId],@"coverUserId":[NSNumber numberWithInt:coverUserId],@"page":[NSNumber numberWithInt:page]} success:^(id dataBody) {

        if (code == OperationSuccess) {
            NSArray *dataArray = [dataBody[@"m_object"] objectForKey:@"data"];
            for (NSDictionary *dic in dataArray) {
                videoPictureHandle *handle = [videoPictureHandle mj_objectWithKeyValues:dic];
                handle.pageCount = [[dataBody[@"m_object"] objectForKey:@"pageCount"]intValue];
                [listArray addObject:handle];
            }
        }
        block(listArray);
    } failed:^(NSString *error) {
        block(listArray);
    }];
}

//type: 0图片  1视频
+ (void)requestAnchorPhotoOrVideoWithAnchorId:(int)anchorId type:(int)type page:(int)page success:(void(^)(NSArray *listArray))success fail:(void(^)(void))fail {
    NSString *urlStr = [self getServiceIPUrl:getDynamicListURL];
    NSDictionary *param = @{@"userId":[NSNumber numberWithInt:[YLUserDefault userDefault].t_id],
                            @"coverUserId":[NSNumber numberWithInt:anchorId],
                            @"fileType":@(type),
                            @"page":[NSNumber numberWithInt:page]};
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:param success:^(id dataBody) {

        if (code == OperationSuccess) {
            NSArray *dataArray = [dataBody[@"m_object"] objectForKey:@"data"];
            for (NSDictionary *dic in dataArray) {
                videoPictureHandle *handle = [videoPictureHandle mj_objectWithKeyValues:dic];
                handle.pageCount = [[dataBody[@"m_object"] objectForKey:@"pageCount"]intValue];
                [listArray addObject:handle];
            }
            if (success) {
                success(listArray);
            }
        } else {
            if (fail) {
                fail();
            }
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        if (fail) {
            fail();
        }
    }];
}

#pragma mark ---- 评价主播
+ (void)saveCommentUserId:(int)commUserId coverCommUserId:(int)coverCommUserId commScore:(int)commScore comment:(NSString *)comment lables:(NSString *)lables block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:saveCommentURL];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":[NSNumber numberWithInt:commUserId],@"coverCommUserId":[NSNumber numberWithInt:coverCommUserId],@"commScore":[NSNumber numberWithInt:commScore]}];
    
    if (comment.length != 0) {
        [dic setValue:comment forKey:@"comment"];
    }
    
    if (lables.length != 0) {
        [dic setValue:lables forKey:@"lables"];
    }
    [SVProgressHUD showWithStatus:@"提交数据中..."];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        
        if (code == OperationSuccess) {
            [SVProgressHUD showInfoWithStatus:@"评价成功"];
            
            block(YES);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO);
        }
    } failed:^(NSString *error) {
    }];

}

#pragma mark ---- 获取钱包余额
+ (void)getQueryUserBalance:(int)userId block:(JSONRedPacketBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getQueryUserBalanceURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {

        if (code == OperationSuccess) {
            NSDictionary *dic = dataBody[@"m_object"];
            
            if ([NSString isNullOrEmpty:dic[@"amount"]]) {
                block(0);
            }else{
                int balance = [dic[@"amount"] intValue];
                
                block(balance);
            }
        }else{
            block(0);
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 提现比例
+ (void)getPutforwardDiscount:(JSONObjectBlock)block t_end_type:(int)type
{
    NSString *urlStr = [self getServiceIPUrl:getPutforwardDiscountURL];
    
    NSMutableArray *putforwardArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"t_end_type":@(type),@"userId":@([YLUserDefault userDefault].t_id)} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSArray *m_objectArray = dataBody[@"m_object"];
            
            for (NSDictionary *dic in m_objectArray) {
                vipSetMealHandle *handle = [vipSetMealHandle mj_objectWithKeyValues:dic];
                
                [putforwardArray addObject:handle];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        block(putforwardArray);
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 充值列表
+ (void)getRechargeDiscount:(int)payType block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getRechargeDiscountURL];
    
    NSMutableArray *rechargeListArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"t_end_type":[NSNumber numberWithInt:payType],@"userId":@([YLUserDefault userDefault].t_id)} success:^(id dataBody) {

        if (code == OperationSuccess) {
            NSArray *m_objectArray = dataBody[@"m_object"];
            
            for (NSDictionary *dic in m_objectArray) {
                vipSetMealHandle *handle = [vipSetMealHandle mj_objectWithKeyValues:dic];
                
                if (handle) {
                    [rechargeListArray addObject:handle];
                }
            }
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        block(rechargeListArray);
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 用户赠送礼物

/**
 用户赠送礼物

 @param coverConsumeUserIds 被消费者
 @param giftId 礼物编号
 @param giftNum 数量
 */
+ (void)userGiveGiftCoverConsumeUserIds:(NSString *)coverConsumeUserIds giftId:(int)giftId giftNum:(int)giftNum block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:userGiveGiftURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":@([YLUserDefault userDefault].t_id),@"coverConsumeUserId":[NSString stringWithFormat:@"%@", coverConsumeUserIds],@"giftId":[NSNumber numberWithInt:giftId],@"giftNum":[NSNumber numberWithInt:giftNum]} success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            block(YES);
        }else{
            if ([dataBody[@"m_istatus"]intValue] == -1 && block) {
                block(NO);
            }
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        if (block) {
            block(NO);
        }
    }];
}

#pragma mark ---- 获取主播亲密排行和礼物排行(userid 主播->用户编号)
+ (void)getIntimateAndGift:(int)userId block:(JSONNewIntimateAndGiftBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getIntimateAndGiftURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            NSArray *intimatesArray = m_objectDic[@"intimates"];
            NSArray *giftsArray = m_objectDic[@"gifts"];
            
            block(intimatesArray,giftsArray);
        }else{
            block(@[],@[]);
        }
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 获取主播亲密度列表
+ (void)getAnthorIntimateList:(int)userId page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getAnthorIntimateListURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            
            NSArray *dataArray = m_objectDic[@"data"];
            for (NSDictionary *dic in dataArray) {
                newIntimateHandle *handle = [newIntimateHandle mj_objectWithKeyValues:dic];
                handle.pageCount = [m_objectDic[@"pageCount"]intValue];
                
                [listArray addObject:handle];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        
        block(listArray);
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 获取礼物柜
+ (void)getAnthorGiftList:(int)userId block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getAnthorGiftListURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {

        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            
            NSArray *dataArray = m_objectDic[@"data"];
            for (NSDictionary *dic in dataArray) {
                newIntimateHandle *handle = [newIntimateHandle mj_objectWithKeyValues:dic];
                handle.total = [m_objectDic[@"total"]intValue];
                
                [listArray addObject:handle];
            }
        }else{
//            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        
        block(listArray);
    } failed:^(NSString *error) {
    }];
}



#pragma mark ---- 修改用户(在离线)状态
/**
 修改用户(在离线)状态

 @param userId 用户编号
 @param type 0.在线1.在聊2.离线
 */
+ (void)updateAnchorOnlineUserId:(int)userId type:(int)type
{
    NSString *urlStr = [self getServiceIPUrl:userGiveGiftURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"type":[NSNumber numberWithInt:type]} success:^(id dataBody) {
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 获取IM签名
+ (void)getImUserSign:(int)userId block:(JSONTokenStampBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getImUserSigUrl];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSString *m_objectDic = dataBody[@"m_object"];
            
            block(m_objectDic);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
    }];
}
#pragma mark ---- 获取我的推广用户列表
+ (void)getShareUserList:(int)userId page:(int)page type:(int)type block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getShareUserListURL];
   
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page],@"type":[NSNumber numberWithInt:type]} success:^(id dataBody) {
        NSDictionary *m_object= dataBody[@"m_object"];
        
        if (code == OperationSuccess) {
            for (NSDictionary *dic in m_object[@"data"]) {
                shareUserHandle *historyHandle = [shareUserHandle mj_objectWithKeyValues:dic];
                historyHandle.pageCount = [m_object[@"pageCount"] intValue];
                
                [listArray addObject:historyHandle];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        block(listArray);
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 推广赚钱
+ (void)getShareTotal:(int)userId block:(JSONShareEarnHandleBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getShareTotalURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {

        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            
            shareEarnHandle *handle = [shareEarnHandle mj_objectWithKeyValues:m_objectDic];

            block(handle);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 上传坐标
+ (void)uploadCoordinate:(int)userId lat:(double)lat lng:(double)lng
{
    NSString *urlStr = [self getServiceIPUrl:uploadCoordinateURL];
    
    NSString *latstr = [NSString stringWithFormat:@"%.6f",lat];
    NSString *lngstr = [NSString stringWithFormat:@"%.6f",lng];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"lat":latstr,@"lng":lngstr} success:^(id dataBody) {

    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 获取附近的用户列表
//获取附近的用户列表
+ (void)getNearbyList:(int)userId lat:(double)lat lng:(double)lng block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getNearbyListURL];
    NSMutableArray *listArray = [NSMutableArray array];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"lng":[NSNumber numberWithDouble:lng],@"lat":[NSNumber numberWithDouble:lat]} success:^(id dataBody) {
        if (code == OperationSuccess){
            if (dataBody) {
                NSArray *m_objectDic = dataBody[@"m_object"];
                
                for (NSDictionary *dic in m_objectDic) {
                    mapInfoHandle *handle = [mapInfoHandle mj_objectWithKeyValues:dic];
                    [listArray addObject:handle];
                }
                block(listArray);
            }
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 获取视频上传签名
+ (void)getVoideSignBlock:(JSONTokenStampBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getVoideSignURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":@([YLUserDefault userDefault].t_id)} success:^(id dataBody) {
        if (code == OperationSuccess) {
            if (dataBody) {
                NSString *sign = dataBody[@"m_object"];
                
                block(sign);
            }
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 获取推荐贡献排行榜(奖励排行)
+ (void)getSpreadBonuses:(int)userId queryType:(NSInteger)queryType block:(JSONObjectBlock)block
{
    NSMutableArray *listArray = [NSMutableArray array];

    NSString *urlStr = [self getServiceIPUrl:getSpreadBonusesURL];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"queryType":@(queryType)} success:^(id dataBody) {
        if (code == OperationSuccess) {
            if (dataBody) {
                NSArray *m_objectDic = dataBody[@"m_object"];
                
                for (int i = 0; i < [m_objectDic count]; i++) {
                    NSDictionary *dic = m_objectDic[i];
                    anchorAddGuildHandle *handle = [anchorAddGuildHandle mj_objectWithKeyValues:dic];
                    handle.type = 1;
                    handle.index= i+1;
                    [listArray addObject:handle];
                }}
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        block(listArray);
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 获取推荐用户排行榜(人数排行)
+ (void)getSpreadUser:(int)userId queryType:(NSInteger)queryType block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getSpreadUserURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"queryType":@(queryType)} success:^(id dataBody) {
        if (code == OperationSuccess) {
            if (dataBody) {
            NSArray *m_objectDic = dataBody[@"m_object"];

            for (int i = 0; i < [m_objectDic count]; i++) {
                NSDictionary *dic = m_objectDic[i];
                anchorAddGuildHandle *handle = [anchorAddGuildHandle mj_objectWithKeyValues:dic];
                handle.type = 2;
                handle.index= i+1;
                [listArray addObject:handle];
            }}
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        block(listArray);
    } failed:^(NSString *error) {
        
    }];
    
}

#pragma mark --- 获取贡献金币用户列表
+ (void)getUserMakeMoneyList:(int)userId page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getUserMakeMoneyListURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            if (dataBody) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];

            if (m_objectDic.allKeys.count != 0) {
            NSArray *dataArray = m_objectDic[@"data"];
            for (NSDictionary *dic in dataArray) {
                shareUserHandle *handle = [shareUserHandle mj_objectWithKeyValues:dic];
                handle.pageCount       = [m_objectDic[@"pageCount"] intValue];
                handle.spreadMoney = [NSString stringWithFormat:@"%d",[dic[@"t_redpacket_gold"] intValue]];
                
                [listArray addObject:handle];
            }
            }else{
            [SVProgressHUD showInfoWithStatus:@"暂无数据"];
            }
            }
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        block(listArray);
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 获取用户贡献列表
+ (void)getMyContributionList:(int)userId page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getMyContributionListURL];
    
    NSMutableArray *ContributionListArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]} success:^(id dataBody) {
        
        NSDictionary *m_objectDic = dataBody[@"m_object"];
        
        if (m_objectDic.allKeys.count != 0) {
            NSArray *dataArray = m_objectDic[@"data"];
             for (NSDictionary *dic in dataArray) {
                 ContributionListHandle *handle = [ContributionListHandle mj_objectWithKeyValues:dic];

                 [ContributionListArray addObject:handle];
             }
        }
        
        block(ContributionListArray);
    }failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 获取推荐主播
+ (void)getHomeNominateList:(int)userId page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getHomeNominateListURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];

            if (m_objectDic.allKeys.count != 0) {
                NSArray *dataArray = m_objectDic[@"data"];

                for (NSDictionary *dic in dataArray) {
                    homePageListHandle *handle = [homePageListHandle mj_objectWithKeyValues:dic];
                    handle.pageCount = [m_objectDic[@"pageCount"] intValue];
                    [listArray addObject:handle];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:@"暂无数据"];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:@"请求失败"];
        }
        block(listArray);
    } failed:^(NSString *error) {
        block(listArray);
    }];
}

#pragma mark ---- 获取试看主播列表
+ (void)getTryCompereList:(int)userId page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getTryCompereListURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            
            if (m_objectDic.allKeys.count != 0) {
                NSArray *dataArray = m_objectDic[@"data"];
                
                for (NSDictionary *dic in dataArray) {
                    homePageListHandle *handle = [homePageListHandle mj_objectWithKeyValues:dic];
                    handle.pageCount       = [m_objectDic[@"pageCount"] intValue];
                    
                    [listArray addObject:handle];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:@"暂无数据"];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:@"请求失败"];
        }
        block(listArray);
    } failed:^(NSString *error) {
        block(listArray);
    }];
}

#pragma mark ---- 获取新人主播
+ (void)getNewCompereList:(int)userId page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getNewCompereListURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            
            if (m_objectDic.allKeys.count != 0) {
                NSArray *dataArray = m_objectDic[@"data"];
                
                for (NSDictionary *dic in dataArray) {
                    homePageListHandle *handle = [homePageListHandle mj_objectWithKeyValues:dic];
                    handle.pageCount       = [m_objectDic[@"pageCount"] intValue];
                    
                    [listArray addObject:handle];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:@"暂无数据"];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:@"请求失败"];
        }
        block(listArray);
    } failed:^(NSString *error) {
        block(listArray);
    }];
}

#pragma mark ---- 获取短视频列表

/**
 获取短视频列表

 @param userId 当前登陆用户的Id
 @param page 当前页码
 @param queryType 1.3版 请求类型 -1：全部 0.免费1.私密
 @param block 返回数组
 */
+ (void)getVideoListUserId:(int)userId page:(int)page queryType:(int)queryType block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getVideoListURL];
    
    NSMutableArray *videoListArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page],@"queryType":[NSNumber numberWithInt:queryType]} success:^(id dataBody) {
        
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            
            if (m_objectDic.allKeys.count != 0) {
                NSArray *dataArray = m_objectDic[@"data"];
                
                for (NSDictionary *dic in dataArray) {
                    videoListHandle *handle = [videoListHandle mj_objectWithKeyValues:dic];
                    handle.pageCount       = [m_objectDic[@"pageCount"] intValue];
                    
                    [videoListArray addObject:handle];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:@"暂无数据"];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:@"请求失败"];
        }
        block(videoListArray);
    } failed:^(NSString *error) {
        block(videoListArray);
    }];
}

#pragma mark ---- 发红包

/**
 发红包

 @param consumeUserId 消费者
 @param coverConsumeUserId 被消费者
 @param gold 金币数
 */
+ (void)sendRedEnvelope:(int)consumeUserId coverConsumeUserId:(int)coverConsumeUserId gold:(int)gold block:(JSONBalanceLessBlock)block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":[NSNumber numberWithInt:consumeUserId],@"coverConsumeUserId":[NSNumber numberWithInt:coverConsumeUserId]}];
    
    if (gold > 0) {
        [dic setValue:[NSNumber numberWithInt:gold] forKey:@"gold"];
    }
    
    NSString *urlStr = [self getServiceIPUrl:sendRedEnvelopeURL];

    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            block(1);
        }else if(code == -1){
//            [SVProgressHUD showInfoWithStatus:@"余额不足,请充值!"];
            block(-1);
        }else{
            block(0);
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 非VIP查看私密照片

/**
 非VIP查看私密照片

 @param consumeUserId 消费者
 @param coverConsumeUserId 被消费者
 @param photoId 照片编号
 */
+ (void)seeImgConsumeUserId:(int)consumeUserId coverConsumeUserId:(int)coverConsumeUserId photoId:(int)photoId block:(JSONFengHaoBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:seeImgConsumeURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:consumeUserId],@"coverConsumeUserId":[NSNumber numberWithInt:coverConsumeUserId],@"photoId":[NSNumber numberWithInt:photoId]} success:^(id dataBody) {
        if (code >= OperationSuccess) {
            block(1,@"");
        }else if(code == OperationFail){
            [SVProgressHUD showInfoWithStatus:@"查看私密照片失败"];
            block(0,@"");
        }else{
//            [SVProgressHUD showInfoWithStatus:@"余额不足,请充值！"];

            block(-1,dataBody[@"m_strMessage"]);
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- VIP查看私密视频或者照片
+ (void)vipSeeDataUserId:(int)vipUserId sourceId:(int)sourceId
{
    NSString *urlStr = [self getServiceIPUrl:vipSeeDataURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:vipUserId],@"sourceId":[NSNumber numberWithInt:sourceId]}
                            success:^(id dataBody)
    {
        
    } failed:^(NSString *error) {
        
    }];
}


#pragma mark ---- 非VIP查看私密视频

/**
 非VIP查看私密视频

 @param consumeUserId 消费者
 @param coverConsumeUserId 被消费者
 @param videoId 视频编号
 */
+ (void)seeVideoConsumeUserId:(int)consumeUserId coverConsumeUserId:(int)coverConsumeUserId videoId:(int)videoId block:(JSONBalanceLessBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:seeVideoConsumeURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:consumeUserId],@"coverConsumeUserId":[NSNumber numberWithInt:coverConsumeUserId],@"videoId":[NSNumber numberWithInt:videoId]} success:^(id dataBody) {
        if (code >= OperationSuccess) {
            block(1);
        }else if(code == OperationFail){
            [SVProgressHUD showInfoWithStatus:@"查看私密视频失败"];
            block(0);
        }else{
//            [SVProgressHUD showInfoWithStatus:@"余额不足,请充值！"];
            block(-1);
        }
    } failed:^(NSString *error) {
        block(0);
    }];
}

#pragma mark ---- 非VIP发送文本消息

/**
 非VIP发送文本消息

 @param consumeUserId 消费者
 @param coverConsumeUserId 被消费者
 */
+ (void)sendTextConsumeUserId:(int)consumeUserId coverConsumeUserId:(int)coverConsumeUserId block:(JSONBalanceLessBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:sendTextConsumeURL];

    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:consumeUserId],@"coverConsumeUserId":[NSNumber numberWithInt:coverConsumeUserId]}
                            success:^(id dataBody)
     {

         if (code == -1){
//             [SVProgressHUD showInfoWithStatus:@"余额不足,请充值!"];
             block(-1);
         }else if (code == 0){
             [SVProgressHUD showInfoWithStatus:@"对方未设置收费"];
             block(0);
         }else if (code == -5){
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
             block(0);
         }else if (code == 3) {
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
             block(3);
         }else{
             block(1);
         }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 查看微信
/**
 查看微信
 
 @param consumeUserId 消费者
 @param coverConsumeUserId 被消费者
 */
+ (void)seeWeiXinConsumeUserId:(int)consumeUserId coverConsumeUserId:(int)coverConsumeUserId block:(JSONDictonaryBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:seeWeiXinConsumeURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:consumeUserId],@"coverConsumeUserId":[NSNumber numberWithInt:coverConsumeUserId]}
                            success:^(id dataBody)
     {
         //0 失败 -1 余额不足 1消费成功 2vip 免费
         if (code >= OperationSuccess) {
             block(dataBody);
         }else if(code == OperationFail){
             [SVProgressHUD showInfoWithStatus:@"查看微信失败"];
         }else{
//             [SVProgressHUD showInfoWithStatus:@"余额不足,请充值！"];
             block(dataBody);
         }
     } failed:^(NSString *error) {

     }];
}

#pragma mark ---- 查看QQ
/**
 查看微信
 
 @param consumeUserId 消费者
 @param coverConsumeUserId 被消费者
 */
+ (void)seeQQConsumeUserId:(int)consumeUserId coverConsumeUserId:(int)coverConsumeUserId block:(JSONDictonaryBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:seeQQConsumeURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:consumeUserId],@"coverConsumeUserId":[NSNumber numberWithInt:coverConsumeUserId]}
                            success:^(id dataBody)
     {
         //0 失败 -1 余额不足 1消费成功 2vip 免费
         if (code >= OperationSuccess) {
             block(dataBody);
         }else if(code == OperationFail){
             [SVProgressHUD showInfoWithStatus:@"查看微信失败"];
         }else{
             //             [SVProgressHUD showInfoWithStatus:@"余额不足,请充值！"];
             block(dataBody);
         }
     } failed:^(NSString *error) {
         
     }];
}

#pragma mark ---- 查看手机号

/**
 查看手机号
 
 @param consumeUserId 消费者
 @param coverConsumeUserId 被消费者
 */
+ (void)seePhoneConsumeUserId:(int)consumeUserId coverConsumeUserId:(int)coverConsumeUserId block:(JSONDictonaryBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:seePhoneConsumeURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:consumeUserId],@"coverConsumeUserId":[NSNumber numberWithInt:coverConsumeUserId]}
                            success:^(id dataBody)
     {
         //0 失败 -1 余额不足 1消费成功 2vip 免费
         if (code >= OperationSuccess) {
             block(dataBody);
         }else if(code == OperationFail){
             [SVProgressHUD showInfoWithStatus:@"查看微信失败"];
         }else{
             block(dataBody);
         }

     } failed:^(NSString *error) {
         
     }];
}

//获取礼物列表
+ (void)getGiftList:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getGiftListURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":@([YLUserDefault userDefault].t_id)}
                            success:^(id dataBody)
     {
         NSMutableArray *giftListArray = [NSMutableArray array];
         if (code == OperationSuccess) {
             NSArray *m_objectDic = dataBody[@"m_object"];
             
             if (m_objectDic.count != 0) {
                 for (NSDictionary *dic in m_objectDic) {
                     giftListHandle *handle = [giftListHandle mj_objectWithKeyValues:dic];
                     
                     [giftListArray addObject:handle];
                 }
             }else{
                 [SVProgressHUD showInfoWithStatus:@"暂无数据"];
             }
             block(giftListArray);
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];

         }
     } failed:^(NSString *error) {
         
     }];
}


#pragma mark ---- 身份验证

/**
 身份验证

 @param realName 真实姓名
 @param idenNo 身份证号
 @param base64 图片base64
 */
+ (void)veriIdentification:(NSString *)realName
                    idenNo:(NSString *)idenNo
                       img:(NSString *)base64
                     block:(JSONBOOLBlock)block
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"key"] = bascicXY_Key;
    dict[@"secret"]= bascicXY_Secret;
    dict[@"trueName"] = realName;
    dict[@"idenNo"] = idenNo;
    dict[@"img"] = base64;
    dict[@"typeId"]=@"3013";// 代表身份证
    dict[@"format"]=@"json";
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://netocr.com/verapi/veridenOrd.do" parameters:dict headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        int status = [[dic[@"messageString"] objectForKey:@"status"]intValue];
        
        if (status == 0) {
            NSArray *thiArray = dic[@"infoList"];
            NSArray *veritemArray = [[thiArray firstObject] objectForKey:@"veritem"];
            
            for (NSDictionary *dicsss in veritemArray) {
                if ([[dicsss objectForKey:@"desc"] isEqualToString:@"verify_result_status"]) {
                    NSString *user_check_descContent = [dicsss objectForKey:@"content"];
                    if ([user_check_descContent isEqualToString:@"1"]) {
                        block(YES);
                        return;
                    } else {
                        block(NO);
                        return;
                    }
                }
            }
            block(NO);
        }else{
            block(NO);
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(NO);
        [SVProgressHUD dismiss];
        
    }];
}

#pragma mark ---- 提交实名认证资料
/**
 提交实名认证资料

 @param userId 用户编号
 @param t_user_hand 图片路径
 @param t_nam 名称
 @param t_id_card 身份证号
 */
+ (void)submitIdentificationData:(int)userId t_user_hand:(NSString *)t_user_hand t_nam:(NSString *)t_nam t_id_card:(NSString *)t_id_card block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:submitIdentificationDataURL];

    NSDictionary *dic = @{@"userId":[NSNumber numberWithInt:userId],@"t_user_photo":t_user_hand,@"t_nam":t_nam,@"t_id_card":t_id_card,@"t_type":@"0"};

    [APIManager requestWithChatPath:urlStr
                              Param:dic
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             [SVProgressHUD showInfoWithStatus:@"认证成功"];
             block(YES);
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];

             block(NO);
         }
     } failed:^(NSString *error) {

     }];
}

/**
 新认证方式

 @param userId 用户id
 @param t_user_video 身份证正面照片
 @param t_user_photo 主播的正面照片
 @param block 返回提交
 */
+ (void)submitNewIdentificationData:(int)userId t_user_video:(NSString *)t_user_video t_user_photo:(NSString *)t_user_photo block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:submitIdentificationDataURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId],@"t_user_video":t_user_video,@"t_user_photo":t_user_photo,@"t_type":@"0"}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             [SVProgressHUD showInfoWithStatus:@"您的资料已经提交成功"];
             block(YES);
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
             
             block(NO);
         }
     } failed:^(NSString *error) {
         
     }];
}

+ (void)submitNewIdentificationData:(int)userId t_weixin:(NSString *)t_weixin t_user_photo:(NSString *)t_user_photo block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:submitIdentificationDataURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId],@"t_user_video":@"",@"t_weixin":t_weixin,@"t_user_photo":t_user_photo, @"t_type":@"0"}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             [SVProgressHUD showInfoWithStatus:@"您的资料已经提交成功"];
             block(YES);
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
             
             block(NO);
         }
     } failed:^(NSString *error) {
         
     }];
}

#pragma mark ---- 通话记录
+ (void)getCallLog:(int)userId page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getCallLogURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             NSDictionary *m_objectDic = dataBody[@"m_object"];
  
             for (NSDictionary *dic in m_objectDic[@"data"]) {
                 conversationHandle *imageLHandle = [conversationHandle mj_objectWithKeyValues:dic];
                 imageLHandle.pageCount       = [m_objectDic[@"pageCount"] intValue];
                 [listArray addObject:imageLHandle];
             }
         }
         
         block(listArray);
     } failed:^(NSString *error) {
     }];
}

#pragma mark ---- 获取实名认证状态
+ (void)getUserIsIdentification:(int)userId block:(JSONBalanceLessBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getUserIsIdentificationURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId]}
                            success:^(id dataBody)
     {

         if (code == OperationSuccess) {
             NSDictionary *dic = dataBody[@"m_object"];
             
             block([[dic objectForKey:@"t_certification_type"] intValue]);
         } else {
             if (code == -1) {
                 block(2);
             }
         }
     } failed:^(NSString *error) {
     }];
}

#pragma mark ---- 获取标签列表
+ (void)getImageLabelList:(int)userId block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getLabelListURL];
    
    NSMutableArray *listArray = [NSMutableArray array];

    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId], @"useType":@"1"} success:^(id dataBody) {
        
        if (code == OperationSuccess) {
            NSArray *m_objectArray = dataBody[@"m_object"];
            
            for (NSDictionary *dic in m_objectArray) {
                imageLabelHandle *imageLHandle = [imageLabelHandle mj_objectWithKeyValues:dic];

                [listArray addObject:imageLHandle];
            }
        }else{
//            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        block(listArray);

    } failed:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark ----- 修改个人资料

+ (void)updatePersonalData:(NSDictionary *)dic editblock:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:updatePersonalDataURL];
    
//    [SVProgressHUD showWithStatus:@"修改资料..."];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {

        [SVProgressHUD dismiss];
        
        if (code == OperationSuccess) {
            
            [SVProgressHUD showInfoWithStatus:@"编辑资料成功"];
            block(YES);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            
            block(NO);
        }
    } failed:^(NSString *error) {
        [SVProgressHUD dismiss];
        block(NO);
    }];
}

#pragma mark ----- APP主页搜索

/**
 APP主页搜索

 @param userId 用户id
 @param page 页码
 @param condition 搜索条件 (昵称或ID号)
 */
+ (void)getSearchList:(int)userId page:(int)page condition:(NSString *)condition block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getSearchListURL];
    
    NSMutableArray *searchListArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page],@"condition":condition} success:^(id dataBody) {
        if (code == OperationSuccess) {
            
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            for (NSDictionary *dic in m_objectDic[@"data"]) {
                searchListHandle *handle = [searchListHandle mj_objectWithKeyValues:dic];
                
                [searchListArray addObject:handle];
            }
        }else{
//            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        block(searchListArray);
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 获取标签列表
+ (void)getLabelList:(int)userId block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getLabelListURL];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId], @"useType":@"2"} success:^(id dataBody) {

        [SVProgressHUD dismiss];
                
        NSMutableArray *labelListArray = [NSMutableArray array];
        if (code == OperationSuccess) {
            for (NSDictionary *dic in dataBody[@"m_object"]) {
                imageLabelHandle *handle = [imageLabelHandle mj_objectWithKeyValues:dic];

                [labelListArray addObject:handle];
            }
        }
        block(labelListArray);
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 新增用户标签
+ (void)saveUserLabelUserId:(int)userId labelId:(int)labelId
{
    NSString *urlStr = [self getServiceIPUrl:saveUserLabelURL];

    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId],@"labelId":[NSNumber numberWithInt:labelId]}
                            success:^(id dataBody)
    {
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 获取主播收费设置
+ (void)getAnchorChargeSetup:(int)userId block:(JSONanchorChargeHandleBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getAnchorChargeSetupURL];
    
    [APIManager requestWithChatPath:urlStr
                               Param:@{@"anchorId":[NSNumber numberWithInt:userId],@"userId":@([YLUserDefault userDefault].t_id)}
                             success:^(id dataBody)
     {

         if (code == OperationSuccess) {
             if (![dataBody[@"m_object"] isKindOfClass:[NSDictionary class]]) {
                 [SVProgressHUD showInfoWithStatus:@"收费设置查询异常"];
                 return ;
             }
             NSDictionary *m_objectDic = dataBody[@"m_object"];
             anchorChargeSetupHandle *handle = [anchorChargeSetupHandle mj_objectWithKeyValues:m_objectDic];
             
             block(handle);
         }else if (code == -1){
             [SVProgressHUD showInfoWithStatus:@"收费设置收费异常"];
         }
     } failed:^(NSString *error) {
         
     }];
}

#pragma mark ---- 修改主播收费设置
+ (void)updateAnchorChargeSetup:(NSMutableDictionary *)dic block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:updateAnchorChargeSetupURL];
    
    [APIManager requestWithChatPath:urlStr
                               Param:dic
                              success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             [SVProgressHUD showInfoWithStatus:@"修改成功"];
             block(YES);
         }else{
             if (code == -1) {
                 [SVProgressHUD showInfoWithStatus:@"您暂无设置此视频聊天金币数的权限"];
             } else {
                 [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
             }
             block(NO);
         }
     } failed:^(NSString *error) {
         block(NO);
     }];
}

#pragma mark ---- 获取已收到礼物列表
+ (void)getGiveGiftList:(int)userId page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getGiveGiftListURL];
    
    NSMutableArray *giftListArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             NSDictionary *m_objectDic = dataBody[@"m_object"];
             for (NSDictionary *dic in m_objectDic[@"data"]) {
                 giftListHandle *handle = [giftListHandle mj_objectWithKeyValues:dic];
                 
                 [giftListArray addObject:handle];
             }
         }
         
         block(giftListArray);
     } failed:^(NSString *error) {
     }];
}

#pragma mark ---- 获取礼物赠送列表

+ (void)getRewardList:(int)userId page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getRewardListURL];
    
    NSMutableArray *giftListArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {

             NSDictionary *m_objectDic = dataBody[@"m_object"];
             for (NSDictionary *dic in m_objectDic[@"data"]) {
                 giftListHandle *handle = [giftListHandle mj_objectWithKeyValues:dic];

                 [giftListArray addObject:handle];
             }
         }
         
         block(giftListArray);
     } failed:^(NSString *error) {
     }];
}

#pragma mark ---- 获取用户收未拆开红包统计
+ (void)getRedPacketCount:(int)userId block:(JSONRedPacketBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getRedPacketCountURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId]}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             NSDictionary *dic = dataBody[@"m_object"];
             int total = [dic[@"total"] intValue];
             
             block(total);
         }else{
             block(0);
         }
     } failed:^(NSString *error) {
     }];
}

#pragma mark ---- 拆开红包
+ (void)receiveRedPacket:(int)userId block:(JSONReceiveRedPacketBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:receiveRedPacketURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId]}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             NSDictionary *dic = dataBody[@"m_object"];
             receiveRedPacketHandle *handle = [receiveRedPacketHandle mj_objectWithKeyValues:dic];
             handle.t_redpacket_gold = [dic[@"t_redpacket_gold"] intValue];
             
             block(handle);
         }
     } failed:^(NSString *error) {
     }];
}

#pragma mark ---- 用户对主播发起聊天

/**
 用户对主播发起聊天

 @param launchUserId 发起人
 @param coverLinkUserId 被链接人
 @param roomId 房间号
 @param block 返回code
 */
+ (void)launchVideoUserId:(int)launchUserId coverLinkUserId:(int)coverLinkUserId roomId:(int)roomId chatType:(int)chatType block:(JSONBalanceLessBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:launchVideoChatURL];
    
    NSDictionary *dic = @{@"userId":[NSNumber numberWithInt:launchUserId],
                          @"coverLinkUserId":[NSNumber numberWithInt:coverLinkUserId],
                          @"roomId":[NSNumber numberWithInt:roomId],
                          @"chatType":[NSNumber numberWithInt:chatType]
                          };
    
    [APIManager requestWithChatPath:urlStr
                              Param:dic
                            success:^(id dataBody)
     {
        [SVProgressHUD dismiss];
         BOOL isSucces = NO;
         //-4：用户余额不足 -3：对方勿扰-2:你拨打的用户正忙,请稍后在拨 -1:对方不在线 1:已开始链接
         if (code == -4 || code == -1) {
             NSString *tip = @"发起视频聊天失败";
             if (chatType == 2) {
                 tip = @"发起语音聊天失败";
             }
             [SVProgressHUD showInfoWithStatus:tip];
         }else if (code == -5){
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }else if (code == -3){
             [SVProgressHUD showInfoWithStatus:@"对方设置已设为勿扰"];
         }else if (code == -2){
             [SVProgressHUD showInfoWithStatus:@"你拨打的用户正忙,请稍后在拨"];
         }else if (code == -7) {
             [SVProgressHUD dismiss];
             [LXTAlertView vipWithContet:dataBody[@"m_strMessage"]];
         }else if (code == -10 ) {
             [SVProgressHUD showInfoWithStatus:@"当前连接已断开，请稍后再试"];
             [[YLSocketExtension shareInstance] disconnect];
             [[YLSocketExtension shareInstance] connectHost];
             return;
         }else{
             isSucces = YES;
         }
         block(code);
     } failed:^(NSString *error) {
         block(NO);
     }];
}

#pragma mark ---- 主播对用户发起聊天

/**
 主播对用户发起聊天

 @param anchorUserId 主播编号
 @param userId 用户编号
 @param roomId 房间号
 */
+ (void)anchorLaunchVideoChat:(int)anchorUserId userId:(int)userId roomId:(int)roomId chatType:(int)chatType block:(JSONBalanceLessBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:anchorLaunchVideoChatURL];
    
    NSDictionary *dic = @{@"anchorUserId":[NSNumber numberWithInt:anchorUserId],
                          @"userId":[NSNumber numberWithInt:userId],
                          @"roomId":[NSNumber numberWithInt:roomId],
                          @"chatType":[NSNumber numberWithInt:chatType]
                          };
    
    [APIManager requestWithChatPath:urlStr
                              Param:dic
                            success:^(id dataBody)
     {
        [SVProgressHUD dismiss];
         BOOL isSucces = NO;
         //-4：用户余额不足 -3：对方勿扰-2:你拨打的用户正忙,请稍后在拨 -1:对方不在线 1:已开始链接
         if (code == -3){
             [SVProgressHUD showInfoWithStatus:@"对方设置已设为勿扰"];
         }else if (code == -7){
             [SVProgressHUD dismiss];
             [LXTAlertView vipWithContet:dataBody[@"m_strMessage"]];
         }else if (code == -5){
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }else if (code == -2){
             [SVProgressHUD showInfoWithStatus:@"你拨打的用户正忙,请稍后在拨"];
         }else if(code == 1){
             isSucces = YES;
         }else if (code == -10 ) {
             [SVProgressHUD showInfoWithStatus:@"当前连接已断开，请稍后再试"];
             [[YLSocketExtension shareInstance] disconnect];
             [[YLSocketExtension shareInstance] connectHost];
         }else{
             isSucces = NO;
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }
         block(code);
     } failed:^(NSString *error) {
         block(NO);
     }];
}

#pragma mark ---- 用户或主播挂断链接
+ (void)hangupLink:(int)userId block:(JSONBOOLBlock)block
{
//    NSString *urlStr = [self getServiceIPUrl:userHangupLinkURL];
//
//    [APIManager requestWithChatPath:urlStr
//                              Param:@{@"userId":[NSNumber numberWithInt:userId]}
//                            success:^(id dataBody)
//     {
//         if (code == OperationSuccess) {
//             block(YES);
//         }else{
//             block(NO);
//         }
//     } failed:^(NSString *error) {
//     }];

}

#pragma mark ---- 开始计时

/**
 开始计时

 @param anthorId 主播编号
 @param userId 用户编号
 @param roomId 房间号
 @param block 返回成功与否
 */
+ (void)videoCharBeginTimingAnthorId:(int)anthorId userId:(int)userId roomId:(int)roomId chatType:(int)chatType block:(JSONBalanceLessBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:videoCharBeginTimingURL];
    
    NSDictionary *dic = @{@"anthorId":[NSNumber numberWithInt:anthorId],
                          @"userId":[NSNumber numberWithInt:userId],
                          @"roomId":[NSNumber numberWithInt:roomId],
                          @"chatType":[NSNumber numberWithInt:chatType]
                          };

    [APIManager requestWithChatPath:urlStr
                              Param:dic
                            success:^(id dataBody)
     {

        NSLog(@"_____黑屏测试  调用计时接口： 参数：%@ \n 结果：%@",dic, dataBody);
         [SVProgressHUD dismiss];
         if (code == OperationSuccess) {
             block(1);
         } else if (code == -1) {
             block(-1);
         } else if (code == -4) {
             block(-4);
         }else {
             block(code);
             if (code != -7) {
                 [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
             }
         }
         
     } failed:^(NSString *error) {
         block(0);
     }];
}

#pragma mark ---- ios版本更新
+ (void)getIosVersion:(int)userId block:(JSONIOSVersionBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getIosVersionURL];
    
    int version_type = [[NSString stringWithFormat:@"%@", APP_create_version] intValue];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"version_type":@(version_type)} success:^(id dataBody) {
        NSDictionary *m_object= dataBody[@"m_object"];
        
        if (code == OperationSuccess) {
            if (![m_object isKindOfClass:[NSNull class]]) {
                NSString *version = m_object[@"t_version"];
                NSString *t_download_url = m_object[@"t_download_url"];
                NSString *t_version_depict = m_object[@"t_version_depict"];
                
                block(version,t_download_url,t_version_depict);
            }
        }else{
//            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 用户或者主播挂断链接
+ (void)breakLinkRoomId:(int)roomId
{
    NSString *urlStr = [self getServiceIPUrl:breakLinkURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"roomId":[NSNumber numberWithInt:roomId],@"userId":@([YLUserDefault userDefault].t_id)}
                            success:^(id dataBody)
     {
         //-4：用户余额不足 -3：对方勿扰-2:你拨打的用户正忙,请稍后在拨 -1:对方不在线 1:已开始链接

         if (code == OperationSuccess) {
             
         }
     } failed:^(NSString *error) {
     }];
}

+ (void)breakLinkRoomId:(int)roomId andSuccess:(void (^)(void))success {
    NSString *urlStr = [self getServiceIPUrl:breakLinkURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"roomId":[NSNumber numberWithInt:roomId],@"userId":@([YLUserDefault userDefault].t_id)}
                            success:^(id dataBody)
     {
         //-4：用户余额不足 -3：对方勿扰-2:你拨打的用户正忙,请稍后在拨 -1:对方不在线 1:已开始链接

         if (code == OperationSuccess && success) {
             success();
         }
     } failed:^(NSString *error) {
     }];
}

#pragma mark ---- 获取提现方式列表
+ (void)getTakeOutMode:(JSONDictonaryBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getTakeOutModeURL];
    [APIManager requestWithChatPath:urlStr
                              Param:@{}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             NSDictionary *m_objectDic = dataBody[@"m_object"];
             
             block(m_objectDic);
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }
         
     } failed:^(NSString *error) {
     }];
}

#pragma mark ---- 申请CPS联盟

/**
 申请CPS联盟
 
 @param userId 申请人编号
 @param cpsName cps名称
 @param cpsUrl cps地址
 @param active 活跃用户
 @param proportions 分成比例
 @param realName 真实姓名
 @param takeOutId 提现方式编号
 @param accountNumber 提现账号
 @param phone 联系电话
 */
+ (void)addCpsMs:(int)userId
         cpsName:(NSString *)cpsName
          cpsUrl:(NSString *)cpsUrl
          active:(int)active
     proportions:(int)proportions
        realName:(NSString *)realName
       takeOutId:(int)takeOutId
   accountNumber:(NSString *)accountNumber
           phone:(NSString *)phone
           block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:addCpsMsURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId],
                                      @"cpsName":cpsName,
                                      @"cpsUrl":cpsUrl,
                                      @"active":[NSNumber numberWithInt:active],
                                      @"proportions":[NSNumber numberWithInt:proportions],
                                      @"realName":realName,
                                      @"takeOutId":[NSNumber numberWithInt:takeOutId],
                                      @"accountNumber":accountNumber,
                                      @"phone":phone}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             block(YES);
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
             block(NO);
         }
     } failed:^(NSString *error) {
     }];
}


#pragma mark ---- 魅力榜
/**
 魅力榜

 @param userId 用户id
 @param queryType 1.日榜2.周榜3.月榜4.总榜
 */
+ (void)getGlamourList:(int)userId queryType:(int)queryType block:(void(^)(NSMutableArray *listArray, rankingHandle *myHandle))block
{
    NSString *urlStr = [self getServiceIPUrl:getGlamourListURL];
    NSMutableArray *listArray = [NSMutableArray array];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId],@"queryType":[NSNumber numberWithInt:queryType]}
                            success:^(id dataBody)
     {
        rankingHandle *selfHandle = nil;
         if (code == OperationSuccess) {
             NSArray *m_objectArray = dataBody[@"m_object"];
             for (int i = 0; i < [m_objectArray count]; i++) {
                 NSDictionary *dic = m_objectArray[i];
                 rankingHandle *handle = [rankingHandle mj_objectWithKeyValues:dic];
                 handle.rankNum = i+1;
                 if (i > 0) {
                     rankingHandle *oldHandle = listArray[i-1];
                     handle.newGold = oldHandle.gold - handle.gold;
                 }
                 if (handle.t_id == [YLUserDefault userDefault].t_id) {
                     selfHandle = handle;
                 }
                 [listArray addObject:handle];
             }
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }
         block(listArray, selfHandle);
     } failed:^(NSString *error) {
     }];
}

#pragma mark ---- 消费榜
/**
 消费榜
 
 @param userId 用户id
 @param queryType 1.日榜2.周榜3.月榜4.总榜
 */
+ (void)getConsumeList:(int)userId queryType:(int)queryType block:(void(^)(NSMutableArray *listArray, rankingHandle *myHandle))block
{
    NSString *urlStr = [self getServiceIPUrl:getConsumeListURL];
    NSMutableArray *listArray = [NSMutableArray array];

    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId],@"queryType":[NSNumber numberWithInt:queryType]}
                            success:^(id dataBody)
     {

        rankingHandle *selfHandle = nil;
         if (code == OperationSuccess) {
             NSArray *m_objectArray = dataBody[@"m_object"];
             for (int i = 0; i < [m_objectArray count]; i++) {
                 NSDictionary *dic = m_objectArray[i];
                 rankingHandle *handle = [rankingHandle mj_objectWithKeyValues:dic];
                 handle.rankNum = i+1;
                 if (i > 0) {
                     rankingHandle *oldHandle = listArray[i-1];
                     handle.newGold = oldHandle.gold - handle.gold;
                 }
                 if (handle.t_id == [YLUserDefault userDefault].t_id) {
                     selfHandle = handle;
                 }
                 [listArray addObject:handle];
             }
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }
         block(listArray, selfHandle);
     } failed:^(NSString *error) {
     }];
}


+ (void)getInvitedListWithQueryType:(int)queryType block:(void(^)(NSMutableArray *listArray, rankingHandle *myHandle))block
{
    NSString *urlStr = [self getServiceIPUrl:getSpreadUserURL];
    NSDictionary *param = @{@"userId":@([YLUserDefault userDefault].t_id),
                            @"queryType":[NSNumber numberWithInt:queryType]};
    NSMutableArray *listArray = [NSMutableArray array];

    [APIManager requestWithChatPath:urlStr
                              Param:param
                            success:^(id dataBody)
     {
        rankingHandle *selfHandle = nil;
         if (code == OperationSuccess) {
             NSArray *m_objectArray = dataBody[@"m_object"];
             for (int i = 0; i < [m_objectArray count]; i++) {
                 NSDictionary *dic = m_objectArray[i];
                 rankingHandle *handle = [rankingHandle mj_objectWithKeyValues:dic];
                 handle.rankNum = i+1;
                 if (i > 0) {
                     rankingHandle *oldHandle = listArray[i-1];
                     handle.newGold = oldHandle.gold - handle.gold;
                 }
                 if (handle.t_id == [YLUserDefault userDefault].t_id) {
                     selfHandle = handle;
                 }
                 [listArray addObject:handle];
             }
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }
         block(listArray, selfHandle);
     } failed:^(NSString *error) {
     }];
}

+ (void)getUserGuardListWithQueryType:(int)queryType block:(void(^)(NSMutableArray *listArray, rankingHandle *myHandle))block
{
    NSString *urlStr = [self getServiceIPUrl:getUserGuardList];
    NSDictionary *param = @{@"userId":@([YLUserDefault userDefault].t_id),
                            @"queryType":[NSNumber numberWithInt:queryType]};
    NSMutableArray *listArray = [NSMutableArray array];

    [APIManager requestWithChatPath:urlStr
                              Param:param
                            success:^(id dataBody)
     {
        rankingHandle *selfHandle = nil;
         if (code == OperationSuccess) {
             NSArray *m_objectArray = dataBody[@"m_object"];
             for (int i = 0; i < [m_objectArray count]; i++) {
                 NSDictionary *dic = m_objectArray[i];
                 rankingHandle *handle = [rankingHandle mj_objectWithKeyValues:dic];
                 handle.rankNum = i+1;
                 if (i > 0) {
                     rankingHandle *oldHandle = listArray[i-1];
                     handle.newGold = oldHandle.gold - handle.gold;
                 }
                 if (handle.t_id == [YLUserDefault userDefault].t_id) {
                     selfHandle = handle;
                 }
                 [listArray addObject:handle];
             }
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }
         block(listArray, selfHandle);
     } failed:^(NSString *error) {
     }];
}

#pragma mark ---- 豪礼榜
/**
 豪礼榜
 
 @param userId 用户id
 @param queryType 1.日榜2.周榜3.月榜4.总榜
 */
+ (void)getCourtesyList:(int)userId queryType:(int)queryType block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getCourtesyListURL];
    NSMutableArray *listArray = [NSMutableArray array];

    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId],@"queryType":[NSNumber numberWithInt:queryType]}
                            success:^(id dataBody)
     {

         if (code == OperationSuccess) {
             NSArray *m_objectArray = dataBody[@"m_object"];
             for (int i = 0; i < [m_objectArray count]; i++) {
                 NSDictionary *dic = m_objectArray[i];
                 rankingHandle *handle = [rankingHandle mj_objectWithKeyValues:dic];
                 
                 if (i > 0) {
                     rankingHandle *oldHandle = listArray[i-1];
                     handle.newGold = oldHandle.gold - handle.gold;
                 }
                 
                 [listArray addObject:handle];
             }
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }
         block(listArray);
     } failed:^(NSString *error) {
     }];
}




#pragma mark ---- 查看他人个人资料
+ (void)getUserPersonalData:(int)userId
{
    NSString *urlStr = [self getServiceIPUrl:getUserPersonalDataURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId]}
                            success:^(id dataBody)
     {
     } failed:^(NSString *error) {
     }];
}

#pragma mark ---- 删除用户标签
+ (void)delUserLabel:(int)labelId
{
    NSString *urlStr = [self getServiceIPUrl:delUserLabelURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"labelId":[NSNumber numberWithInt:labelId],@"userId":@([YLUserDefault userDefault].t_id)}
                            success:^(id dataBody)
     {
     } failed:^(NSString *error) {
     }];
}

#pragma mark ---- 获取个人浏览记录
+ (void)getBrowseList:(int)userId page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getBrowseListURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             NSDictionary *m_objectDic = dataBody[@"m_object"];
             for (NSDictionary *dic in m_objectDic[@"data"]) {
                 browseHistoryHandle *handle = [browseHistoryHandle mj_objectWithKeyValues:dic];
                 handle.pageCount       = [m_objectDic[@"pageCount"] intValue];
                 
                 [listArray addObject:handle];
             }
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }
         
         block(listArray);
     } failed:^(NSString *error) {
     }];
}



#pragma mark ---- 新增相册数据
+ (void)addMyPhotoAlbum:(int)userId t_title:(NSString *)t_title url:(NSString *)url type:(int)type gold:(int)gold fileId:(NSString *)fileId video_img:(NSString *)video_img block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:addMyPhotoAlbumURL];
    
    
    NSDictionary *dic = @{@"userId":[NSNumber numberWithInt:userId],@"t_title":t_title,@"url":url,@"type":[NSNumber numberWithInt:type],@"gold":[NSNumber numberWithInt:gold]};
    
    if (type == 1) {
        dic = @{@"userId":[NSNumber numberWithInt:userId],@"t_title":t_title,@"url":url,@"type":[NSNumber numberWithInt:type],@"gold":[NSNumber numberWithInt:gold],@"fileId":fileId,@"video_img":video_img};
    }
    
    [SVProgressHUD showWithStatus:@"正在创建相册..."];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            [SVProgressHUD showInfoWithStatus:@"相册创建成功"];
            block(YES);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO);
        }
    } failed:^(NSString *error) {
        [SVProgressHUD dismiss];
        block(NO);
    }];

}

#pragma mark ---- 删除我的相册
+ (void)delMyPhotoId:(int)photoId block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:delMyPhotoURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"photoId":[NSNumber numberWithInt:photoId],@"userId":@([YLUserDefault userDefault].t_id)}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             [SVProgressHUD showInfoWithStatus:@"删除相册成功"];
             block(YES);
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];

             block(NO);
         }
     } failed:^(NSString *error) {
     }];
}

#pragma mark ---- 获取我的相册
+ (void)getMyPhotoList:(int)userId page:(int)page block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getMyPhotoListURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             NSDictionary *m_objectDic = dataBody[@"m_object"];
             NSArray *dataArray = m_objectDic[@"data"];
             
             for (NSDictionary *dic in dataArray) {
                 myAlbumHandle *handle = [myAlbumHandle mj_objectWithKeyValues:dic];

                 [listArray addObject:handle];
             }
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }
         
         block(listArray);
     } failed:^(NSString *error) {
     }];
}

#pragma mark ---- 获取个人中心
+ (void)index:(int)userId block:(JSONPersonalCenterHandleBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:indexURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId]}
                            success:^(id dataBody)
     {
        [SVProgressHUD dismiss];
        NSLog(@"___index:%@", dataBody);
         if (code == OperationSuccess) {
             NSDictionary *dic = dataBody[@"m_object"];
             
             personalCenterHandle *pcenterHandle = [personalCenterHandle mj_objectWithKeyValues:dic];
             [YLUserDefault savePhone:pcenterHandle.t_phone];
             
             block(pcenterHandle);
         }else{
             block(nil);
         }
     } failed:^(NSString *error) {
         block(nil);
     }];
}

#pragma mark ----- 勿扰
+ (void)setUpChatSwitchType:(int)type switchType:(int)switchType block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:setUpChatSwitchURL];
    NSDictionary *dic = @{@"userId":[NSNumber numberWithInt:[YLUserDefault userDefault].t_id],
                          @"chatType":[NSNumber numberWithInt:type],
                          @"switchType":[NSNumber numberWithInt:switchType]};
    [APIManager requestWithChatPath:urlStr
                              Param:dic
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             block(YES);
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
             block(NO);
         }
     } failed:^(NSString *error) {
     }];
}

#pragma mark ------ 获取主页列表
+ (void)getHomePageList:(int)userId page:(int)page queryType:(int)queryType block:(JSONObjectBlock)block
{
    NSString *url = [self getServiceIPUrl:getHomePageListURL];
    NSMutableArray *homePageListArray = [NSMutableArray array];
    
    NSDictionary *dic = @{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page],@"queryType":[NSNumber numberWithInt:queryType]};
    
    [APIManager requestWithChatPath:url Param:dic success:^(id dataBody) {

        NSDictionary *m_objectDic = dataBody[@"m_object"];
        if (![m_objectDic isKindOfClass:[NSNull class]]) {
            NSArray *dataArra = m_objectDic[@"data"];
            
            if (code == OperationSuccess) {
                for (NSDictionary *dic in dataArra) {
                    homePageListHandle *homePageHandle = [homePageListHandle mj_objectWithKeyValues:dic];
                    homePageHandle.pageCount       = [m_objectDic[@"pageCount"] intValue];

                    [homePageListArray addObject:homePageHandle];
                }
                
                block(homePageListArray);
            }else{
                block(homePageListArray);
            }
        }
    } failed:^(NSString *error) {
        block(homePageListArray);
    }];
}

+ (void)getHomePageListWithCity:(NSString *)city page:(int)page queryType:(int)queryType block:(JSONObjectBlock)block
{
    NSString *url = [self getServiceIPUrl:getHomePageListURL];
    NSMutableArray *homePageListArray = [NSMutableArray array];
    
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id),
                          @"t_city":[NSString stringWithFormat:@"%@", city],
                          @"page":[NSNumber numberWithInt:page],
                          @"queryType":[NSNumber numberWithInt:queryType]};
    
    [APIManager requestWithChatPath:url Param:dic success:^(id dataBody) {

        NSDictionary *m_objectDic = dataBody[@"m_object"];
        if (![m_objectDic isKindOfClass:[NSNull class]]) {
            NSArray *dataArra = m_objectDic[@"data"];
            
            if (code == OperationSuccess) {
                for (NSDictionary *dic in dataArra) {
                    homePageListHandle *homePageHandle = [homePageListHandle mj_objectWithKeyValues:dic];
                    homePageHandle.pageCount       = [m_objectDic[@"pageCount"] intValue];

                    [homePageListArray addObject:homePageHandle];
                }
                
                block(homePageListArray);
            }else{
                block(homePageListArray);
            }
        }
    } failed:^(NSString *error) {
        block(homePageListArray);
    }];
}

#pragma mark ---- 申请公会
/**
 申请公会

 @param userId 用户编号
 @param guildName 公会名称
 @param adminName 管理员姓名
 @param adminPhone 管理员电话
 @param anchorNumber 申请主播数
 @param idCard 身份证号码
 @param handImg 认证头像
 */
+ (void)applyGuild:(int)userId guildName:(NSString *)guildName adminName:(NSString *)adminName adminPhone:(NSString *)adminPhone anchorNumber:(int)anchorNumber idCard:(NSString *)idCard handImg:(NSString *)handImg block:(JSONBOOLBlock)block
{
    NSString *url = [self getServiceIPUrl:applyGuildURL];

    NSDictionary *dic = @{@"userId":[NSNumber numberWithInt:userId],@"guildName":guildName,@"adminName":adminName,@"adminPhone":adminPhone,@"anchorNumber":[NSNumber numberWithInt:anchorNumber],@"idCard":idCard,@"handImg":handImg};
    
    [APIManager requestWithChatPath:url Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            [SVProgressHUD showInfoWithStatus:@"申请成功,等待审核"];
            
            block(YES);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO);
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ----- 获取公会主播贡献列表
+ (void)getContributionList:(int)userId page:(int)page block:(JSONObjectBlock)block
{
    NSString *url = [self getServiceIPUrl:getContributionListURL];

    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:url Param:@{@"userId":[NSNumber numberWithInt:userId],@"page":[NSNumber numberWithInt:page]} success:^(id dataBody) {

        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            for (NSDictionary *dic in m_objectDic[@"data"]) {
                ContributionListHandle *handle = [ContributionListHandle mj_objectWithKeyValues:dic];
                handle.pageCount  = [m_objectDic[@"pageCount"] intValue];
                
                [listArray addObject:handle];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        
        block(listArray);
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 统计公会主播数和贡献值
+ (void)getGuildCount:(int)userId block:(JSONUnionBlock)block
{
    NSString *url = [self getServiceIPUrl:getGuildCountURL];
    
    [APIManager requestWithChatPath:url Param:@{@"userId":[NSNumber numberWithInt:userId]}
                            success:^(id dataBody)
    {
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            
            int anchorCount = [m_objectDic[@"anchorCount"] intValue];
            int totalGold   = [m_objectDic[@"totalGold"] intValue];
            
            block(anchorCount,totalGold);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(0,0);
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 拉取是否邀请主播加入公会
+ (void)getAnchorAddGuild:(int)userId block:(JSONanchorAddGuildHandleBlock)block
{
    NSString *url = [self getServiceIPUrl:getAnchorAddGuildURL];
    
    [APIManager requestWithChatPath:url Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            
            if (m_objectDic.allKeys.count != 0) {
                anchorAddGuildHandle *handle = [anchorAddGuildHandle mj_objectWithKeyValues:m_objectDic];
                
                block(handle);
            }else{
                block(nil);
            }
        }else{
//            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(nil);
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 主播确认是否加入公会

/**
 主播确认是否加入公会

 @param userId 主播编号
 @param guildId 公会编号
 @param isApply 是否加入公会 0.否 1.是
 */
+ (void)isApplyGuild:(int)userId guildId:(int)guildId isApply:(int)isApply block:(JSONBOOLBlock)block
{
    NSString *url = [self getServiceIPUrl:isApplyGuildURL];
    
    [APIManager requestWithChatPath:url Param:@{@"userId":[NSNumber numberWithInt:userId],@"guildId":[NSNumber numberWithInt:guildId],@"isApply":[NSNumber numberWithInt:isApply]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            if (isApply == 1) {
                [SVProgressHUD showInfoWithStatus:@"您已成功加入公会"];
            }else{
                [SVProgressHUD showInfoWithStatus:@"您已拒绝加入公会"];
            }
            
            block(YES);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO);
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 获取公会主播贡献明细统计

/**
 获取公会主播贡献明细统计

 @param userId 用户编号
 @param anchorId 主播编号
 */
+ (void)getAnthorTotal:(int)userId anchorId:(int)anchorId block:(JSONanchorAddGuildHandleBlock)block
{
    NSString *url = [self getServiceIPUrl:getAnthorTotalURL];

    [APIManager requestWithChatPath:url Param:@{@"userId":[NSNumber numberWithInt:userId],@"anchorId":[NSNumber numberWithInt:anchorId]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            anchorAddGuildHandle *handle = [anchorAddGuildHandle mj_objectWithKeyValues:m_objectDic];

            block(handle);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 公会主播贡献明细列表
+ (void)getContributionDetail:(int)userId anchorId:(int)anchorId page:(int)page block:(JSONObjectBlock)block
{
    NSString *url = [self getServiceIPUrl:getContributionDetailURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:url Param:@{@"userId":[NSNumber numberWithInt:userId],@"anchorId":[NSNumber numberWithInt:anchorId],@"page":[NSNumber numberWithInt:page]} success:^(id dataBody) {

        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            
            for (NSDictionary *dic in m_objectDic[@"data"]) {
                anchorAddGuildHandle *handle = [anchorAddGuildHandle mj_objectWithKeyValues:dic];
                handle.pageCount         = [m_objectDic[@"pageCount"] intValue];
                
                [listArray addObject:handle];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        block(listArray);
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 添加分享次数
+ (void)addShareCount:(int)userId block:(JSONBalanceLessBlock)block
{
    NSString *url = [self getServiceIPUrl:addShareCountURL];
    
    [APIManager requestWithChatPath:url Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            block([dataBody[@"m_object"] intValue]);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 个人钱包
+ (void)getUserMoney:(int)userId block:(JSONMyPurseHandleBlock)block
{
    NSString *url = [self getServiceIPUrl:getUserMoneyURL];
    
    [APIManager requestWithChatPath:url Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {
        
        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            myPurseHandle *handle = [myPurseHandle mj_objectWithKeyValues:m_objectDic];

            block(handle);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
    }];
}

#pragma mark ------ 微信登录逻辑
//通过code获取access_token
+ (void)getAccess_token:(NSString *)TokeCode wechatBlock:(JSONWechatBlock)block
{
    [APIManager requestGETWithChatPath:@"https://api.weixin.qq.com/sns/oauth2/access_token" Param:@{@"appid":bascicWechatAppId,@"secret":bascicWechatSecret,@"code":TokeCode,@"grant_type":@"authorization_code"} success:^(id dataBody) {
        NSString *access_token = dataBody[@"access_token"];
        NSString *openid = dataBody[@"openid"];
        NSString *refresh_token = dataBody[@"refresh_token"];
        
        block(access_token,openid,refresh_token);
    } failed:^(NSString *error) {
    }];
}

//刷新或续期access_token使用
+ (void)refreshAccess_token:(NSString *)refreshToken
{
    [APIManager requestGETWithChatPath:@"https://api.weixin.qq.com/sns/oauth2/refresh_token" Param:@{@"appid":bascicWechatAppId,@"refreshToken":refreshToken,@"grant_type":@"refresh_token"} success:^(id dataBody) {
    } failed:^(NSString *error) {
    }];
}

//检验授权凭证（access_token）是否有效
+ (void)checkAccess_token:(NSString *)access_token oppenId:(NSString *)oppenId block:(JSONBOOLBlock)block
{
    [APIManager requestGETWithChatPath:@"https://api.weixin.qq.com/sns/auth" Param:@{@"access_token":access_token,@"openid":oppenId} success:^(id dataBody) {
        
        int errcode = [dataBody[@"errcode"]intValue];
        
        if (errcode == 0) {
            block(YES);
        }else{
            block(NO);
        }
    } failed:^(NSString *error) {
        block(NO);
    }];
}

//获取微信个人信息
+ (void)getWechatInfoOpenId:(NSString *)openId acesstoken:(NSString *)accessToken block:(JsonWechatBackBlock)block
{
    //typedef void (^JsonWechatBackBlock)(NSString *nickname,NSString *headimgurl,NSString *province,NSString *sex,NSString *city);

    [APIManager requestGETWithChatPath:@"https://api.weixin.qq.com/sns/userinfo" Param:@{@"access_token":accessToken,@"openid":openId} success:^(id dataBody) {
        NSString *nickname = dataBody[@"nickname"];
        NSString *headimgurl = dataBody[@"headimgurl"];
        NSString *province = dataBody[@"province"];
        int sex = [dataBody[@"sex"]intValue];
        NSString *city = dataBody[@"city"];
        
        block(nickname,headimgurl,province,sex,city);
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 更新用户登陆时间
+ (void)upLoginTime:(int)userId block:(JSONBOOLBlock)block
{
    NSString *url = [self getServiceIPUrl:upLoginTimeURL];
    [APIManager requestWithChatPath:url Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {
        
        if (code == OperationSuccess) {
            block(YES);
        }else{
            block(NO);
        }
    } failed:^(NSString *error) {
    }];
}


#pragma mark ---- 微信登录

/**
  微信登录

 @param openId 微信openId
 @param nickName 昵称
 @param handImg 头像
 @param t_system_version iPhone
 @param ipAddress ip地址
 @param block 返回code
 */
//TODO, ipcodehandle - start
+ (void)wechatLogin:(NSString *)openId nickName:(NSString *)nickName handImg:(NSString *)handImg  t_system_version:(NSString *)t_system_version ipAddress:(NSString *)ipAddress t_channel:(NSString *)channelid block:(JSONHaveSexBlock)block
{
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString *url = [self getServiceIPUrl:weixinLoginUrl];
    
    [APIManager requestWithChatPath:url Param:@{@"openId":openId,@"nickName":nickName,@"handImg":handImg,@"t_phone_type":@"iPhone",@"t_system_version":t_system_version,@"t_ip_address":ipAddress,@"deviceNumber":identifierStr,@"shareUserId":@([SLHelper getPasteboardCode]),@"ip":[SLHelper getIPaddress]} success:^(id dataBody) {

        if (code == OperationSuccess) {
            [self judgeLogin:dataBody block:block];
        }else if(code == 0){
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO,NO,NO,@"");
        }else if (code == -200){
            [SVProgressHUD showInfoWithStatus:@"该设备已注册过账号，请勿重复注册！"];
            block(NO,NO,NO,@"");
        }else{
            block(NO,NO,YES,dataBody[@"m_strMessage"]);
        }
    } failed:^(NSString *error) {
        block(NO,NO,NO,@"");
    }];
}

+ (void)newWechatLogin:(NSString *)wxCode t_channel:(NSString *)channelid block:(JSONHaveSexBlock)block
{
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString *url = [self getServiceIPUrl:userWeixinLogin];
    
    NSDictionary *param = @{@"weixinCode":[NSString stringWithFormat:@"%@", wxCode],
    @"t_phone_type":@"iPhone",
    @"t_system_version":[NSString defaultUserAgentString],
    @"t_ip_address":[NSString getWANIP],
    @"deviceNumber":identifierStr,
                            @"shareUserId":[NSString stringWithFormat:@"%ld", (long)[channelid integerValue]],
    @"ip":[SLHelper getIPaddress]};
    
    [APIManager requestWithChatPath:url Param:param success:^(id dataBody) {

        if (code == OperationSuccess) {
            [self judgeLogin:dataBody block:block];
        }else if(code == 0){
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO,NO,NO,@"");
        }else if (code == -200){
            [SVProgressHUD showInfoWithStatus:@"该设备已注册过账号，请勿重复注册！"];
            block(NO,NO,NO,@"");
        }else{
            block(NO,NO,YES,dataBody[@"m_strMessage"]);
        }
    } failed:^(NSString *error) {
        block(NO,NO,NO,@"");
    }];
}

#pragma mark ---- QQ登录
+ (void)qqLoginOpenId:(NSString *)openId nickName:(NSString *)nickName handImg:(NSString *)handImg city:(NSString *)city t_system_version:(NSString *)t_system_version ipaddress:(NSString *)ipAddress t_channel:(NSString *)channelid block:(JSONHaveSexBlock)block
{
    NSString *url = [self getServiceIPUrl:qqLoginURL];
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSDictionary *dic = @{@"openId":openId,@"nickName":nickName,@"handImg":handImg,@"city":city,@"t_system_version":t_system_version,@"t_ip_address":ipAddress,@"t_phone_type":@"iPhone",@"deviceNumber":identifierStr,@"shareUserId":@([channelid integerValue]),@"ip":[SLHelper getIPaddress]};

    [APIManager requestWithChatPath:url Param:dic success:^(id dataBody)
    {
        if (code == OperationSuccess) {
            [self judgeLogin:dataBody block:block];
        }else if(code == 0){
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            //登录失败的错误信息
            
            block(NO,NO,NO,@"");
        }else if(code == -200){
            [SVProgressHUD showInfoWithStatus:@"该设备已注册过账号，请勿重复注册！"];
            block(NO,NO,NO,@"");
        }else{
            //被封号
            block(NO,NO,YES,dataBody[@"m_strMessage"]);
        }
    } failed:^(NSString *error) {
        //这里可以不需要
        block(NO,NO,NO,@"");
    }];

}
//TODO, ipcodehandle - end

//获取第三方登陆配置信息
+ (void)getLongSetUpList
{
    NSString *url = [self getServiceIPUrl:getLongSetUpListURL];
    [APIManager requestWithChatPath:url Param:@{} success:^(id dataBody) {
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- VIP支付
/**
 VIP支付

 @param userId 用户编号
 @param setMealId 套餐编号
 @param payType -1.支付宝 -2.微信
 */
+ (void)vipStoreValue:(int)userId setMealId:(int)setMealId payType:(int)payType payDeployId:(NSInteger)payDeployId block:(JSONVIPWeixinPayBlock)block
{
    NSString *url = [self getServiceIPUrl:vipStoreValueURL];
    [APIManager requestWithChatPath:url
                         Param:@{@"userId":[NSNumber numberWithInt:userId],
                               @"setMealId":[NSNumber numberWithInt:setMealId],
                               @"payType":[NSNumber numberWithInt:payType],
                                 @"payDeployId":@(payDeployId)
                                 }
                       success:^(id dataBody)
    {
        if (code == OperationSuccess) {
            if (payType == -1) {
                //支付宝
                NSString *m_object = dataBody[@"m_object"];

                block(nil,m_object);
            } else if (payType == -2) {
                //微信
                NSDictionary *m_objectDic = dataBody[@"m_object"];
                
                weixinPayHandle *handle = [weixinPayHandle mj_objectWithKeyValues:m_objectDic];
                
                block(handle,@"");
            } else {
                //网页支付
                if (payType == -3 || payType == -4 || payType == -13 || payType == -14 || payType == -17 || payType == -18 || payType == -19 || payType == -20 || payType == -21 || payType == -22) {
                    NSDictionary *m_objectDic = dataBody[@"m_object"];
                    NSString *url = m_objectDic[@"return_msg"];
                    block(nil,url);
                }else if ( payType == -12) {
                    NSDictionary *m_objectDic = dataBody[@"m_object"];
                    
                    NSString *miniapp_data = m_objectDic[@"miniapp_data"];
                    NSData *jsonData = [miniapp_data dataUsingEncoding:NSUTF8StringEncoding];

                    NSError *error;
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                          options:NSJSONReadingMutableContainers
                                          error:&error];
                    NSString *url = dictionary[@"scheme_code"];
                    block(nil,url);
                }else if ( payType == -11) {
                    NSDictionary *m_objectDic = dataBody[@"m_object"];
                    NSString *url = m_objectDic[@"qr_code"];
                    block(nil,url);
                }  else {
                    NSString *url = dataBody[@"m_object"];
                    block(nil,url);
                }
            }
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma mark ---- 获取用户可提现金币
+ (void)getUsableGold:(int)userId block:(JSONObjectBlock)block
{
    NSString *url = [self getServiceIPUrl:getUsableGoldURL];
    NSMutableArray *accountListArray = [NSMutableArray array];
    [APIManager requestWithChatPath:url
                              Param:@{@"userId":[NSNumber numberWithInt:userId]}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             NSDictionary *m_objectDic = dataBody[@"m_object"];
             
             for (NSDictionary *dic in m_objectDic[@"data"]) {
                 accountHandle *handle = [accountHandle mj_objectWithKeyValues:dic];
                 
                 [accountListArray addObject:handle];
             }
         }else{
//             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }
         block(accountListArray);
     } failed:^(NSString *error) {
         
     }];
}

+ (void)getWithdrawRule:(int)userId block:(JSONTokenStampBlock)block
{
    NSString *url = [self getServiceIPUrl:getWithdrawRuleApi];
    [APIManager requestWithChatPath:url
                              Param:@{@"userId":[NSNumber numberWithInt:userId]}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             NSDictionary *m_objectDic = dataBody[@"m_object"];
             block(dataBody[@"m_strMessage"]);
         }else{
//             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }
     } failed:^(NSString *error) {
         
     }];
}

+ (void)getManagerGold:(int)userId block:(JSONTokenStampBlock)block
{
    NSString *url = [self getServiceIPUrl:@"/app/getManagerGold.html"];
    [APIManager requestWithChatPath:url
                              Param:@{@"userId":[NSNumber numberWithInt:userId]}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             NSDictionary *m_objectDic = dataBody[@"m_object"];
             block(dataBody[@"m_strMessage"]);
         }else{
//             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }
     } failed:^(NSString *error) {
         
     }];
}


/**
 金币充值
 
 @param userId 用户编号
 @param setMealId 套餐编号
 @param payType -1.支付宝 -2.微信
 */
+ (void)goldStoreValue:(int)userId setMealId:(int)setMealId payType:(int)payType payDeployId:(NSInteger)payDeployId block:(JSONVIPWeixinPayBlock)block
{
    NSString *url = [self getServiceIPUrl:goldStoreValueURL];
    [APIManager requestWithChatPath:url
                              Param:@{@"userId":[NSNumber numberWithInt:userId],
                                      @"setMealId":[NSNumber numberWithInt:setMealId],
                                      @"payType":[NSNumber numberWithInt:payType],
                                      @"payDeployId":@(payDeployId)}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             if (payType == -2) {
                 //微信
                 NSDictionary *m_objectDic = dataBody[@"m_object"];
                 
                 weixinPayHandle *handle = [weixinPayHandle mj_objectWithKeyValues:m_objectDic];
                 
                 block(handle,@"");
             } else if (payType == -1) {
                 //支付宝
                 NSString *m_object = dataBody[@"m_object"];
                 
                 block(nil,m_object);
             } else {
                 //网页支付
                 if (payType == -3 || payType == -4 || payType == -13 || payType == -14 || payType == -17 || payType == -18 || payType == -19 || payType == -20 || payType == -21 || payType == -22) {
                     NSDictionary *m_objectDic = dataBody[@"m_object"];
                     NSString *url = m_objectDic[@"return_msg"];
                     block(nil,url);
                 }else if ( payType == -12) {
                     NSDictionary *m_objectDic = dataBody[@"m_object"];
                     
                     NSString *miniapp_data = m_objectDic[@"miniapp_data"];
                     NSData *jsonData = [miniapp_data dataUsingEncoding:NSUTF8StringEncoding];

                     NSError *error;
                     NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                           options:NSJSONReadingMutableContainers
                                           error:&error];
                     NSString *url = dictionary[@"scheme_code"];
                     block(nil,url);
                 }else if ( payType == -11) {
                     NSDictionary *m_objectDic = dataBody[@"m_object"];
                     NSString *url = m_objectDic[@"qr_code"];
                     block(nil,url);
                 }  else {
                     NSString *url = dataBody[@"m_object"];
                     block(nil,url);
                 }
             }
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }
     } failed:^(NSString *error) {
         
     }];
}

#pragma mark ---- 用户点赞
+ (void)addLaud:(int)laudUserId coverLaudUserId:(int)coverLaudUserId block:(JSONBOOLBlock)block
{
    NSString *url = [self getServiceIPUrl:addLaudURL];
    [APIManager requestWithChatPath:url Param:@{@"userId":[NSNumber numberWithInt:laudUserId],@"coverLaudUserId":[NSNumber numberWithInt:coverLaudUserId]} success:^(id dataBody) {

        if (code == OperationSuccess) {
            block(YES);
        }else{
            block(NO);
        }
    } failed:^(NSString *error) {
    }];
}
#pragma mark ---- 用户取消点赞
+ (void)cancelLaud:(int)userId coverUserId:(int)coverUserId block:(JSONBOOLBlock)block
{
    NSString *url = [self getServiceIPUrl:cancelLaudURL];
    [APIManager requestWithChatPath:url Param:@{@"userId":[NSNumber numberWithInt:userId],@"coverUserId":[NSNumber numberWithInt:coverUserId]} success:^(id dataBody) {

        if (code == OperationSuccess) {
            block(YES);
        }else{
            block(NO);
        }
    } failed:^(NSString *error) {
    }];
}

#pragma ---- 版本是否上线
+ (void)getIosSwitch:(JSONBOOLBlock)block
{
    NSString *url = [self getServiceIPUrl:getIosSwitchURL];
    [APIManager requestWithChatPath:url Param:@{} success:^(id dataBody) {
        if (code == OperationSuccess) {
            block(YES);
        }else{
            block(YES);
        }
    } failed:^(NSString *error) {
        block(YES);
    }];
}

#pragma mark ---- 获取VIP套餐列表
+ (void)getVIPSetMealType:(int)type List:(JSONObjectBlock)block
{
    NSString *url = [self getServiceIPUrl:getVIPSetMealListURL];
    NSMutableArray *mealListArray = [NSMutableArray array];
    [APIManager requestWithChatPath:url
                              Param:@{@"userId":@([YLUserDefault userDefault].t_id),@"t_vip_type":[NSString stringWithFormat:@"%d", type]}
                       success:^(id dataBody)
     {
         if (code == OperationSuccess) {

             for (NSDictionary *dic in dataBody[@"m_object"]) {
                 
                 vipSetMealHandle *MealHandle = [vipSetMealHandle mj_objectWithKeyValues:dic];
                 [mealListArray addObject:MealHandle];
             }
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }
         block(mealListArray);
     } failed:^(NSString *error) {
         [SVProgressHUD showInfoWithStatus:@"请求VIp套餐失败！"];
     }];
}

//修改用户性别
+ (void)upateUserSex:(int)userId sex:(int)sex idCard:(NSString *)idCard block:(JSONBOOLBlock)block
{
    NSString *id_card = @"0";
    if (idCard.length > 0) {
        id_card = idCard;
    }
    NSString *url = [self getServiceIPUrl:upateUserSexURL];
    NSDictionary *param = @{@"userId":[NSNumber numberWithInt:userId],
                            @"sex":[NSNumber numberWithInt:sex],
                            @"id_card":[NSString stringWithFormat:@"%@", id_card]
    };
    [APIManager requestWithChatPath:url Param:param success:^(id dataBody)
    {
        if (code == OperationSuccess) {
            [YLUserDefault saveSex:[NSString stringWithFormat:@"%d",sex]];
            block(YES);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];

            block(NO);
        }
    } failed:^(NSString *error) {
        block(NO);
    }];
}

#pragma mark ---- 获取banner
+ (void)getIosBanner:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getIosBannerListURL];
    
    NSMutableArray *bannerListArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:[YLUserDefault userDefault].t_id], @"t_banner_type" : @"1"} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSArray *m_objectArray = dataBody[@"m_object"];
            
            for (NSDictionary *dic in m_objectArray) {
                bannerHandle *handle = [bannerHandle mj_objectWithKeyValues:dic];
                
                [bannerListArray addObject:handle];
            }
        }
        block(bannerListArray);
    } failed:^(NSString *error) {
    }];
}

+ (void)getAllBannerListSuccess:(void (^)(NSDictionary *data))success {
    NSString *urlStr = [self getServiceIPUrl:getAllBannerList];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:[YLUserDefault userDefault].t_id]} success:^(id dataBody) {
        
        if (code == OperationSuccess && [dataBody[@"m_object"] isKindOfClass:[NSDictionary class]] && success) {
            NSDictionary *dic = dataBody[@"m_object"];
            success(dic);
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)getNewBannerListSuccess:(void (^)(NSDictionary *data))success {
    NSString *urlStr = [self getServiceIPUrl:getNewBannerList];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:[YLUserDefault userDefault].t_id]} success:^(id dataBody) {
        
        if (code == OperationSuccess && [dataBody[@"m_object"] isKindOfClass:[NSDictionary class]] && success) {
            NSDictionary *dic = dataBody[@"m_object"];
            success(dic);
        }
    } failed:^(NSString *error) {
    }];
}


#pragma mark ---- 用户退出
+ (void)logout:(int)userId block:(JSONBOOLBlock)block
{
    NSString *url = [self getServiceIPUrl:logoutURL];
    
    [APIManager requestWithChatPath:url Param:@{@"userId":[NSNumber numberWithInt:userId],} success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             block(YES);
         }else{
             block(NO);
         }
     } failed:^(NSString *error) {
         block(NO);
     }];
}

#pragma mark ---- 获取动态列表
+ (void)getDynamicList:(NSInteger)userId page:(NSInteger)page reqType:(NSInteger)reqType block:(JSONObjectBlock)block {
    NSString *url = [self getServiceIPUrl:getUserDynamicList];
    [APIManager requestWithChatPath:url Param:@{@"userId":@(userId),@"page":@(page),@"reqType":@(reqType)} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *dict = (NSDictionary *)dataBody;
            block(dict[@"m_object"][@"data"]);
        } else {
            block(nil);
        }
    } failed:^(NSString *error) {
        block(nil);
    }];
}

#pragma mark ---- 获取主播个人动态
+ (void)getPriDynamicList:(NSInteger)userId coverUserId:(NSInteger)coverUserId page:(NSInteger)page reqType:(NSInteger)reqType block:(JSONObjectBlock)block {
    NSString *url = [self getServiceIPUrl:getPrivateDynamicList];
    [APIManager requestWithChatPath:url Param:@{@"userId":@(userId),@"coverUserId":@(coverUserId),@"page":@(page),@"reqType":@(reqType)} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *dict = (NSDictionary *)dataBody;
            block(dict[@"m_object"][@"data"]);
        } else {
            block(nil);
        }
    } failed:^(NSString *error) {
        block(nil);
    }];
}

#pragma mark ---- 获取自己的动态列表
+ (void)getMineDynamicList:(NSInteger)userId page:(NSInteger)page block:(JSONObjectBlock)block {
    NSString *url = [self getServiceIPUrl:getOwnDynamicList];
    [APIManager requestWithChatPath:url Param:@{@"userId":@(userId),@"page":@(page)} success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *dict = (NSDictionary *)dataBody;
            block(dict[@"m_object"][@"data"]);
        } else {
            block(nil);
        }
    } failed:^(NSString *error) {
        block(nil);
    }];
}

#pragma mark ---- 动态点赞
+ (void)dynamicLove:(NSInteger)userId dynamicId:(NSInteger)dynamicId block:(JSONBOOLBlock)block {
    NSString *url = [self getServiceIPUrl:giveTheThumbsUp];
    NSDictionary *dic = @{@"userId":@(userId),@"dynamicId":@(dynamicId)};
    [APIManager requestWithChatPath:url Param:dic success:^(id dataBody) {
        NSDictionary *dict = (NSDictionary *)dataBody;
        if (code == OperationSuccess) {
            block(YES);
        } else {
            block(NO);
            [SVProgressHUD showInfoWithStatus:dict[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        block(NO);
    }];
}

#pragma mark ---- 动态删除
+ (void)dynamicDelete:(NSInteger)userId dynamicId:(NSInteger)dynamicId block:(JSONBOOLBlock)block {
    NSString *url = [self getServiceIPUrl:deleteDynamic];
    NSDictionary *dic = @{@"userId":@(userId),@"dynamicId":@(dynamicId)};
    [APIManager requestWithChatPath:url Param:dic success:^(id dataBody) {
        NSDictionary *dict = (NSDictionary *)dataBody;
        if (code == OperationSuccess) {
            block(YES);
        } else {
            block(NO);
            [SVProgressHUD showInfoWithStatus:dict[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        block(NO);
    }];
}

#pragma mark ---- 获取私密金币
+ (void)dynamicPrivatePhotoMoney:(NSInteger)userId block:(JSONObjectBlock)block {
    NSString *url = [self getServiceIPUrl:getPrivatePhotoMoney];
    NSDictionary *dic = @{@"userId":@(userId)};
    [APIManager requestWithChatPath:url Param:dic success:^(id dataBody) {
        NSDictionary *dict = (NSDictionary *)dataBody;
        if (code == OperationSuccess) {
            NSArray *list = [dict[@"m_object"] componentsSeparatedByString:@","];
            block([NSMutableArray arrayWithArray:list]);
        } else {
            block(nil);
            [SVProgressHUD showInfoWithStatus:dict[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        block(nil);
    }];
}

#pragma mark ---- 发布动态
+ (void)releaseDynamicData:(NSInteger)userId content:(NSString *)content address:(NSString *)address isVisible:(NSInteger)isVisible files:(id)files block:(JSONBOOLBlock)block {
    NSString *url = [self getServiceIPUrl:releaseDynamic];
    NSDictionary *dic = @{@"userId":@(userId),@"content":content,@"address":address,@"isVisible":@(0),@"files":files};
    [APIManager requestWithChatPath:url Param:dic success:^(id dataBody) {
        NSDictionary *dict = (NSDictionary *)dataBody;
        if (code == OperationSuccess) {
            block(YES);
            //[SVProgressHUD showInfoWithStatus:dict[@"m_strMessage"]];
        } else {
            block(NO);
            [SVProgressHUD showInfoWithStatus:dict[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        block(NO);
    }];
}

#pragma mark ---- 动态照片，视频消费
+ (void)postDynamicPay:(NSInteger)userId fileId:(NSInteger)fileId block:(JSONBalanceLessBlock)block {
    NSString *urlStr = [self getServiceIPUrl:dynamicPay];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":@(userId),@"fileId":@(fileId)} success:^(id dataBody) {
        if (code >= OperationSuccess) {
            block(1);
        }else if(code == OperationFail){
            [SVProgressHUD showInfoWithStatus:@"查看失败~"];
            block(0);
        }else{
            block(-1);
        }
    } failed:^(NSString *error) {
        block(0);
    }];
}

#pragma mark ---- 获取动态评论列表
+ (void)getDynamicCommentList:(NSInteger)userId page:(NSInteger)page dynamicId:(NSInteger)dynamicId block:(JSONObjectBlock)block {
    NSString *url = [self getServiceIPUrl:getCommentList];
    NSDictionary *dic = @{@"userId":@(userId),@"page":@(page),@"dynamicId":@(dynamicId)};
    [APIManager requestWithChatPath:url Param:dic success:^(id dataBody) {
        if (code == OperationSuccess){
            if (dataBody) {
                NSArray *array = dataBody[@"m_object"][@"data"];
                NSMutableArray *listArray = [NSMutableArray array];
                for (NSDictionary *dic in array) {
                    DynamicCommentListModel *model = [DynamicCommentListModel mj_objectWithKeyValues:dic];
                    [listArray addObject:model];
                }
                block(listArray);
            }
        } else {
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        block(nil);
    }];
}

#pragma mark ---- 添加动态评价
+ (void)addDynamicComment:(NSInteger)userId coverUserId:(NSInteger)coverUserId dynamicId:(NSInteger)dynamicId comment:(NSString *)comment block:(JSONBalanceLessBlock)block {
    NSString *urlStr = [self getServiceIPUrl:discussDynamic];
    NSDictionary *dic = @{@"userId":@(userId),@"coverUserId":@(coverUserId),@"dynamicId":@(dynamicId),@"comment":comment};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code >= OperationSuccess) {
            block(1);
        }else if(code == OperationFail){
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(0);
        }else{
            block(-1);
        }
    } failed:^(NSString *error) {
        block(0);
    }];
}

+ (void)deleteDynamicComment:(NSInteger)userId commentId:(NSInteger)commentId block:(JSONBalanceLessBlock)block {
    NSString *urlStr = [self getServiceIPUrl:delComment];
    NSDictionary *dic = @{@"userId":@(userId),@"commentId":@(commentId)};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code >= OperationSuccess) {
            block(1);
        }else if(code == OperationFail){
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(0);
        }else{
            block(-1);
            
        }
    } failed:^(NSString *error) {
        block(0);
    }];
}

#pragma mark ---- 绑定邀请码
+ (void)uniteIdCardWithId:(NSInteger)userId idCard:(NSInteger)idCard block:(JSONBalanceLessBlock)block {
    NSString *urlStr = [self getServiceIPUrl:uniteIdCard];
    NSDictionary *dic = @{@"userId":@(userId),@"idCard":@(idCard)};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            block(1);
        } else {
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(code);
            
        }
    } failed:^(NSString *error) {
        block(0);
    }];
}

#pragma mark ---- 获取动态消息
+ (void)getDynamicNewMsgNumber:(int)userId block:(JSONRedPacketBlock)block {
    NSString *urlStr = [self getServiceIPUrl:getUserDynamicNotice];
    NSDictionary *dic = @{@"userId":@(userId)};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            if (dataBody) {
                id obj = dataBody[@"m_object"];
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    block([obj[@"t_mesg_count"] intValue]);
                } else {
                    NSDictionary *dic = [obj firstObject];
                    block([dic[@"t_mesg_count"] intValue]);
                }
            }
        } else {
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {

    }];
}

#pragma mark ---- 获取动态消息列表
+ (void)getUserNewCommentList:(NSInteger)userId block:(JSONObjectBlock)block {
    NSString *url = [self getServiceIPUrl:getUserNewComment];
    NSDictionary *dic = @{@"userId":@(userId)};
    [APIManager requestWithChatPath:url Param:dic success:^(id dataBody) {
        if (code == OperationSuccess){
            if (dataBody) {
                NSArray *array = dataBody[@"m_object"];
                NSMutableArray *listArray = [NSMutableArray array];
                for (NSDictionary *dic in array) {
                    DynamicMsgListModel *model = [DynamicMsgListModel mj_objectWithKeyValues:dic];
                    [listArray addObject:model];
                }
                block(listArray);
            }
        } else {
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        block(nil);
    }];
}

#pragma mark ---- 验证图形
+ (void)getVerifyCodeIsCorrectWithPhone:(NSString *)phone verifyCode:(NSString *)verifyCode block:(JSONBalanceLessBlock)block {
    NSString *url = [self getServiceIPUrl:getVerifyCodeIsCorrect];
    NSDictionary *dic = @{@"phone":phone,@"verifyCode":verifyCode};
    [APIManager requestWithChatPath:url Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess){
            block(1);
        } else {
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(code);
        }
    } failed:^(NSString *error) {
        [SVProgressHUD dismiss];
        block(0);
    }];
}

#pragma mark ---- 获取图形验证
+ (void)getVerifyWithPhone:(NSString *)phone block:(JSONVideoPushBlock)block {
    NSString *url = [self getServiceIPUrl:getVerify];
    NSDictionary *dic = @{@"phone":phone};
    [APIManager requestWithChatPath:url Param:dic success:^(id dataBody) {
        if (code == OperationSuccess){
            block((NSDictionary *)dataBody);
        } else {
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(nil);
        }
    } failed:^(NSString *error) {
        block(nil);
    }];
}

#pragma mark ---- 获取客服QQ
+ (void)getServiceQQ:(NSInteger)userId block:(JSONDictonaryBlock)block {
    NSString *urlStr = [self getServiceIPUrl:serviceQQ];
    NSDictionary *dic = @{@"userId":@(userId)};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            block(dataBody);
        } else {
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(nil);
            
        }
    } failed:^(NSString *error) {
        block(nil);
    }];
}




#pragma mark ---- 获取帮助中心列表
+ (void)getHelpCenter:(int)userId block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getHelpCenterList];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId]}
                            success:^(id dataBody) {
                                if (code == OperationSuccess) {
                                    NSArray *dataArray = dataBody[@"m_object"];
                                    
                                    for (NSDictionary *dic in dataArray) {
                                        HelpCenterListModel *handle = [HelpCenterListModel mj_objectWithKeyValues:dic];
                                        [listArray addObject:handle];
                                    }
                                    block(listArray);
                                }else{
                                    [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
                                }
                            } failed:^(NSString *error) {
                            }];
}

#pragma mark ---- 获取主播详情资料
+ (void)getAnchorWithData:(int)userId anchorId:(int)anchorId block:(JSONGodNessInfoHandleBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getAnchorData];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"anchorId":[NSNumber numberWithInt:anchorId]} success:^(id dataBody) {
        if (code == OperationSuccess) {

            NSDictionary *dic = dataBody[@"m_object"];
            godnessInfoHandle *handle = [godnessInfoHandle mj_objectWithKeyValues:dic];
            
            block(handle);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
    }];
}

#pragma mark ---- 账号密码注册
//TODO, ipcodehandle - start
+ (void)registerPwdWithPhone:(NSString *)phone password:(NSString *)password smsCode:(NSString *)smsCode t_channel:(NSString *)channelid block:(JSONBOOLBlock)block {
    NSString *urlStr = [self getServiceIPUrl:registerPwd];
    
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    NSDictionary *dic = @{@"phone":phone,@"password":password,@"smsCode":smsCode,@"deviceNumber":identifierStr,@"t_phone_type":@"iPhone",@"t_system_version":phoneVersion,@"shareUserId":@([channelid integerValue]),@"ip":[SLHelper getIPaddress]};
    
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            block(YES);
        } else {
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO);
        }
    } failed:^(NSString *error) {
        
    }];
}
//TODO, ipcodehandle - end

#pragma mark ---- 找回密码
+ (void)findPwdWithPhone:(NSString *)phone password:(NSString *)password smsCode:(NSString *)smsCode block:(JSONBOOLBlock)block {
    NSString *urlStr = [self getServiceIPUrl:findPwd];
    
    NSDictionary *dic = @{@"phone":phone,@"password":password,@"smsCode":smsCode};
    
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            block(YES);
        } else {
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO);
        }
    } failed:^(NSString *error) {
        
    }];
}

#pragma make ---- 账号密码登录
+ (void)pwdLoginWithPhone:(NSString *)phone password:(NSString *)password block:(JSONHaveSexBlock)block {
    NSString *urlStr = [self getServiceIPUrl:pwdLogin];
    
    NSDictionary *dic = @{@"phone":phone,@"password":password};
    
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        
        if (code == OperationSuccess) {
            [self judgeLogin:dataBody block:block];
        }else if(code == 0){
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO,NO,NO,@"");
        }else if (code == -200){
            [SVProgressHUD showInfoWithStatus:@"该设备已注册过账号，请勿重复注册"];
            block(NO,NO,NO,@"");
        }else if (code == -1){
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(NO,NO,NO,@"");
        }else{
            block(NO,NO,YES,dataBody[@"m_strMessage"]);
        }
    } failed:^(NSString *error) {
        [SVProgressHUD dismiss];
        block(NO,NO,NO,@"");
    }];
}

+ (void)getAnthorCoverImage:(JSONDictonaryBlock)block {
    NSString *urlStr = [self getServiceIPUrl:anthorCover];
    
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id)};
    
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];

        if (code == OperationSuccess) {
            NSDictionary *dic = dataBody[@"m_object"];
            block(dic);
        } else if(code == -1) {
            [SVProgressHUD showInfoWithStatus:@"您还没有直播权限，请联系客服"];
        }else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
        [SVProgressHUD dismiss];

    }];
}



+ (void)getShareUrlAddress:(JSONDictonaryBlock)block {
    NSString *urlStr = [self getServiceIPUrl:getShareUrl];
    
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id)};
    
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        
        if (code == OperationSuccess) {
            block(dataBody);
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
        [SVProgressHUD dismiss];
        
    }];
}

+ (void)uploadCoverImage:(NSString *)imageUrl isFirst:(NSInteger)first block:(JSONDictonaryBlock)block {
    NSString *urlStr = [self getServiceIPUrl:uploadDiscover];
    
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id),@"coverImg":imageUrl,@"t_first":@(first)};
    
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            block(dataBody);
        } else {
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:@"上传失败"];
    }];
}

+ (void)setMainCoverImage:(NSInteger)coverImgId block:(JSONDictonaryBlock)block {
    NSString *urlStr = [self getServiceIPUrl:mainDiscover];
    
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id),@"coverImgId":@(coverImgId)};
    
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            block(dataBody);
        } else {
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        
    } failed:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:@"上传失败"];
    }];
}

+ (void)deleteCoverImage:(NSInteger)coverImgId block:(JSONDictonaryBlock)block {
    NSString *urlStr = [self getServiceIPUrl:delDicover];
    
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id),@"coverImgId":@(coverImgId)};
    
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            block(dataBody);
        } else {
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        
    } failed:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:@"上传失败"];
    }];
}

+ (void)getPayType:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getPayTypeList];
    
    NSMutableArray *rechargeListArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":@([YLUserDefault userDefault].t_id)} success:^(id dataBody) {
        
        if (code == OperationSuccess) {
            NSArray *m_objectArray = dataBody[@"m_object"];
            block(m_objectArray);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        
    } failed:^(NSString *error) {
        
    }];
}

+ (void)getAdTableWithType:(NSInteger)type userId:(int)userId page:(NSInteger)page timeout:(int)timeOut success:(void (^)(NSArray *dataAttay))success  fail:(void (^) (void))fail {
    NSString *urlStr = [self getServiceIPUrl:getAdTable];
    NSDictionary *param = @{@"userId" : @(userId),
                            @"type" : @(type),
                            @"page" : @(page),
                            @"size" : @(10)
                            };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = timeOut;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager GET:urlStr parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"m_istatus"]intValue] == OperationSuccess) {
            if ([responseObject[@"m_object"] isKindOfClass:[NSArray class]]) {
                NSArray *m_objectArray = responseObject[@"m_object"];
                success(m_objectArray);
            } else {
                if (fail) {
                    fail();
                }
                [SVProgressHUD dismiss];
            }
        } else {
            if (fail) {
                fail();
            }
            [SVProgressHUD showInfoWithStatus:responseObject[@"m_strMessage"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail();
        }
        [SVProgressHUD showInfoWithStatus:@"请检查网络连接！"];
    }];
}

+ (void)getDataWithUserImSig:(int)userId block:(JSONTokenStampBlock)block {
    NSString *urlStr = [self getServiceIPUrl:getNewImUserSign];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":[NSNumber numberWithInt:userId]}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             NSString *sig = dataBody[@"m_object"];
             block(sig);
         }else{
             [SVProgressHUD dismiss];
             block(nil);
         }
     } failed:^(NSString *error) {
     }];
}

+ (void)getCoverBrowseListWithUserId:(NSString *)userId page:(NSInteger)page Success:(void (^)(NSArray *dataArray, NSString *totelNum))success fail:(void (^)(void))fail {
    NSString *urlStr = [self getServiceIPUrl:getCoverBrowseList];
    NSDictionary *dic = @{@"userId" : [NSString stringWithFormat:@"%@", userId],
                          @"page":@(page),
                          @"size":@"10"
                          };
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *m_objectDic = dataBody[@"m_object"];
                NSArray *array = m_objectDic[@"data"];
                for (NSDictionary *dic in array) {
                    WatchedModel *listModel = [WatchedModel mj_objectWithKeyValues:dic];
                    [listArray addObject:listModel];
                }
                if (success) {
                    success(listArray, [NSString stringWithFormat:@"%@", m_objectDic[@"pageCount"]]);
                }
            } else {
                [SVProgressHUD showErrorWithStatus:@"请求失败"];
                if (fail) {
                    fail();
                }
            }
        } else {
            if (fail) {
                fail();
            }
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
        if (fail) {
            fail();
        }
    }];
}

//lsl update start
+ (void)getUserInfoByIdUser:(NSInteger)userId block:(JSONPersonalCenterHandleBlock)block {
    NSString *urlStr = [self getServiceIPUrl:getUserInfoById];
    NSDictionary *dic = @{@"coverUserId":[NSString stringWithFormat:@"%ld", (long)userId]};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSDictionary class]]) {
                [SVProgressHUD dismiss];
                NSDictionary *dic = dataBody[@"m_object"];
                
                personalCenterHandle *pcenterHandle = [personalCenterHandle mj_objectWithKeyValues:dic];
                
                block(pcenterHandle);
                
            } else {
                [SVProgressHUD showInfoWithStatus:@"用户头像获取失败"];
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
            
        }
    } failed:^(NSString *error) {
    }];
}
//lsl update end

+(void)getSelectCharAnotherWithAnchorId:(int)anchorId success:(JSONObjectBlock)block {
    NSString *url = [self getServiceIPUrl:getSelectCharAnother];
    NSMutableArray *homePageListArray = [NSMutableArray array];
    
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id),
                          @"anotherId":@(anchorId)};
    
    [APIManager requestWithChatPath:url Param:dic success:^(id dataBody) {

        if (code == OperationSuccess) {
            NSDictionary *m_objectDic = dataBody[@"m_object"];
            if (![m_objectDic isKindOfClass:[NSNull class]]) {
                 homePageListHandle *homePageHandle = [homePageListHandle mj_objectWithKeyValues:m_objectDic];
                [homePageListArray addObject:homePageHandle];
            }
            block(homePageListArray);
        }else{
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
        
    } failed:^(NSString *error) {
        
    }];
}

+ (void)getVIPUserInfoWithType:(int)chatType success:(void(^)(NSInteger userId))success {
    NSString *url;
    NSString *tipMessage;
    
    if ([YLUserDefault userDefault].t_sex == 0) {
        url = [self getServiceIPUrl:getVIPUserInfo];
        tipMessage = @"暂无可匹配用户";
    } else {
        url = [self getServiceIPUrl:getOnlineAnoInfo];
        tipMessage = @"暂无可匹配主播";
    }
    [APIManager requestWithChatPath:url Param:@{@"userId":@([YLUserDefault userDefault].t_id), @"chatType":@(chatType)} success:^(id dataBody) {
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *m_objectDic = dataBody[@"m_object"];
                NSInteger t_id = [m_objectDic[@"t_id"] integerValue];
                if (success) {
                    success(t_id);
                }
                if (t_id == -1) {
                    [SVProgressHUD showInfoWithStatus:tipMessage];
                } else {
                    [SVProgressHUD dismiss];
                }
            } else {
                [SVProgressHUD showInfoWithStatus:tipMessage];
                if (success) {
                    success(-1);
                }
            }
        }else{
            if (code != -4) {
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
            }
            if (success) {
                success(code);
            }
        }
    } failed:^(NSString *error) {
        if (success) {
            success(-1);
        }
    }];
}

+ (void)breakLinkRoomId:(int)roomId success:(void (^)(BOOL isSuccess))isSuccess {
    NSString *urlStr = [self getServiceIPUrl:breakLinkURL];
    
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"roomId":[NSNumber numberWithInt:roomId],@"userId":@([YLUserDefault userDefault].t_id),@"breakType":@"7"}
                            success:^(id dataBody)
     {
         if (code == OperationSuccess) {
             if (isSuccess) {
                 isSuccess(YES);
             }
         } else {
             if (isSuccess) {
                 isSuccess(NO);
             }
         }
     } failed:^(NSString *error) {
         if (isSuccess) {
             isSuccess(NO);
         }
     }];
}

+ (void)getAnoCoverImgSuccess:(void (^) (NSArray *imageArray))success {
    NSString *urlStr = [self getServiceIPUrl:getAnoCoverImg];
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr
                              Param:@{@"userId":@([YLUserDefault userDefault].t_id)}
                            success:^(id dataBody)
     {
        [SVProgressHUD dismiss];
         if (code == OperationSuccess && [dataBody[@"m_object"] isKindOfClass:[NSArray class]]) {
             NSArray *arr = dataBody[@"m_object"];
             if (success) {
                 success(arr);
             }
         } else {
             
         }
     } failed:^(NSString *error) {
         
     }];
}

+ (void)addBlackUserWithId:(NSString *)userId success:(void (^)(void))success {
    NSString *urlStr = [self getServiceIPUrl:addBlackUser];
    NSDictionary *dic = @{@"userId" : [NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],
                          @"cover_userId" : [NSString stringWithFormat:@"%@", userId]};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            if (success) {
                success();
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)delBlackUserWithId:(NSString *)userId success:(void (^)(void))success {
    NSString *urlStr = [self getServiceIPUrl:delBlackUser];
    NSDictionary *dic = @{@"userId" : [NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],
                          @"t_id" : [NSString stringWithFormat:@"%@", userId]};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            if (success) {
                success();
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)getBlackUserListWithPage:(NSInteger)page Success:(void (^)(NSArray *dataArray))success fail:(void (^)(void))fail {
    NSString *urlStr = [self getServiceIPUrl:getBlackUserList];
    NSDictionary *dic = @{@"userId" : [NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],
                          @"page" : @(page),
                          @"size" : @(10)};
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSArray *array = dataBody[@"m_object"];
            for (NSDictionary *dic in array) {
                WatchedModel *listModel = [WatchedModel mj_objectWithKeyValues:dic];
                [listArray addObject:listModel];
            }
            if (success) {
                success(listArray);
            }
        } else {
            if (fail) {
                fail();
            }
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
        if (fail) {
            fail();
        }
    }];
}

#pragma mark ---- 获取im消息敏感词汇
+ (void)getDataWithImSensitiveWorld:(NSInteger)userId block:(JSONDictonaryBlock)block {
    NSString *urlStr = [self getServiceIPUrl:getImFilter];
    NSDictionary *dic = @{@"userId":@(userId)};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            block(dataBody);
        } else {
            block(nil);
            
        }
    } failed:^(NSString *error) {
        block(nil);
    }];
}

+ (void)getDataWithOcrFilter:(NSInteger)userId block:(JSONDictonaryBlock)block {
    NSString *urlStr = [self getServiceIPUrl:getOcrFilter];
    NSDictionary *dic = @{@"userId":@(userId)};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            block(dataBody);
        } else {
            block(nil);
            
        }
    } failed:^(NSString *error) {
        block(nil);
    }];
}


+ (void)getSounRecordingSwitchAndCache {
    NSString *urlStr = [self getServiceIPUrl:getSounRecordingSwitch];
    NSDictionary *dic = @{@"userId":[NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id]};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *m_object = dataBody[@"m_object"];
            NSString *t_sound_recording_switch = [NSString stringWithFormat:@"%@", m_object[@"t_sound_recording_switch"]];
            [[NSUserDefaults standardUserDefaults] setObject:t_sound_recording_switch forKey:@"SOUNDRECORDINGSWITCH"];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"SOUNDRECORDINGSWITCH"];
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
        
    }];
}

+ (void)saveSounRecordingWithTime:(NSString *)time otherId:(NSString *)otherId path:(NSString *)path success:(void (^)(void))success {
    NSString *urlStr = [self getServiceIPUrl:saveSounRecording];
       NSDictionary *dic = @{@"userId":[NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],
                             @"cover_userId":[NSString stringWithFormat:@"%@", otherId],
                             @"soundUrl":[NSString stringWithFormat:@"%@", path],
                             @"video_start_time":[NSString stringWithFormat:@"%@", time]
       };
       [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
           if (code == OperationSuccess) {
               if (success) {
                   success();
               }
           } else {
               [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
           }
       } failed:^(NSString *error) {
           
       }];
}

+ (void)getAnthorTopping:(NSInteger)userId block:(JSONDictonaryBlock)block {
    NSString *urlStr;
    if ([YLUserDefault userDefault].t_role == 1) {
        urlStr = [self getServiceIPUrl:getTopping];
    } else if ([YLUserDefault userDefault].t_is_vip == 0) {
        urlStr = [self getServiceIPUrl:@"/app/setUserTopping.html"];
    } else {
        return;
    }
    NSDictionary *dic = @{@"userId":@(userId)};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            [SVProgressHUD showInfoWithStatus:@"置顶成功"];
        } else {
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            block(nil);
            
        }
    } failed:^(NSString *error) {
        block(nil);
    }];
}

// 七牛云图片鉴黄

//+ (void)qiniuPictureIdentify:(UIImage *)image result:(void (^)(bool isPulp))result {
//    NSData * imageData = UIImageJPEGRepresentation(image,.5);
//    NSString *base64 = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    if (base64.length == 0) {
//        return;
//    }
//    NSString *keyUrl = [self getServiceIPUrl:getQiNiuKey];
//    NSDictionary *keyDic = @{@"userId":[NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],@"imgData":base64};
//    [APIManager requestWithChatPath:keyUrl Param:keyDic success:^(id dataBody) {
//        NSLog(@"___视频鉴黄 body:%@", dataBody);
//        if (code == OperationSuccess) {
//            BOOL ispulp = [dataBody[@"m_object"] boolValue];
//            if (result) {
//                result(ispulp);
//            }
//        } else {
//            if (result) {
//                result(NO);
//            }
//        }
//    } failed:^(NSString *error) {
//        if (result) {
//            result(NO);
//        }
//    }];
//}


// 七牛云图片鉴黄
+ (void)qiniuPictureIdentify:(UIImage *)image result:(void (^)(bool isPulp))result {
    NSData * imageData = UIImageJPEGRepresentation(image,.5);
    NSString *base64 = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    if (base64.length == 0 || accessKey.length == 0 || secretKey == 0) {
        return;
    }
    NSString *url = @"http://ai.qiniuapi.com/v3/image/censor";
    NSDictionary *param = @{@"data":@{@"uri":[NSString stringWithFormat:@"data:application/octet-stream;base64,%@", base64]},
                            @"params":@{@"scenes":@[@"pulp"]}};

    NSString *dicStr = [ToolManager dictionaryToString:param];
    NSString *dataStr = [NSString stringWithFormat:@"POST /v3/image/censor\nHost: ai.qiniuapi.com\nContent-Type: application/json\n\n%@", dicStr];
    NSString *sign = [HAMCSHA1 HmacSha1WithKey:secretKey data:dataStr];
    NSString *signKey = [NSString stringWithFormat:@"Qiniu %@:%@", accessKey, sign];
    NSMutableString *mutStr = [NSMutableString stringWithString:signKey];
    NSRange range = {0,signKey.length};
    [mutStr replaceOccurrencesOfString:@"+" withString:@"-" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"/" withString:@"_" options:NSLiteralSearch range:range2];
//    NSLog(@"____sign:%@   sign2:%@", signKey, mutStr);
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [ToolManager dictionaryToString:param];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    [manager.requestSerializer setValue:mutStr forHTTPHeaderField:@"Authorization"];

    [manager POST:url parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"____responseOb:%@", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            if ([responseObject[@"result"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *resultDic = responseObject[@"result"];
                if ([resultDic[@"scenes"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *scenes = resultDic[@"scenes"];
                    if ([scenes[@"pulp"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *pulp = scenes[@"pulp"];
                        if ([pulp[@"details"] isKindOfClass:[NSArray class]]) {
                            NSArray *details = pulp[@"details"];
                            if (details.count > 0) {
                                NSDictionary *dic = details[0];
                                NSString *label = dic[@"label"];
                                NSString *suggestion = dic[@"suggestion"];
                                if ([label isEqualToString:@"pulp"] || [suggestion isEqualToString:@"block"]) {
                                    if (result) {
                                        result(1);
                                    }
                                    return ;
                                }
                            }
                        }
                    }
                }
            }
        }
        if (result) {
            result(NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"_____error:%@", error);
        if (result) {
            result(NO);
        }
    }];
    
//    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:url parameters:param error:nil];
//    NSLog(@"___header:%@",request.allHTTPHeaderFields);
}

+ (void)getVideoScreenshotStatusSuccess:(void (^)(NSDictionary *dataDic))success {
    NSString *url = [self getServiceIPUrl:getVideoScreenshotStatus];
    NSDictionary *dic = @{@"userId":[NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id]};
    [APIManager requestWithChatPath:url Param:dic success:^(id dataBody) {
        NSLog(@"鉴黄图片开关:%@", dataBody);
        if (code == OperationSuccess) {
            NSDictionary *dic = dataBody[@"m_object"];
            if (success) {
                success(dic);
            }
        }
    } failed:^(NSString *error) {
        
    }];
}

+ (void)addVideoScreenshotInfoWithParam:(NSDictionary *)param {
    NSString *url = [self getServiceIPUrl:addVideoScreenshotInfo];
    [APIManager requestWithChatPath:url Param:param success:^(id dataBody) {
//        NSLog(@"上传鉴黄图片:%@", dataBody);
    } failed:^(NSString *error) {
        
    }];
}

+ (void)addOcrScreenshotInfoWithParam:(NSDictionary *)param result:(void (^)(bool isSuccess))result{
    NSString *url = [self getServiceIPUrl:addOcrScreenshotInfo];
    [APIManager requestWithChatPath:url Param:param success:^(id dataBody) {
        if (code == OperationSuccess) {
            result(1);
        }
    } failed:^(NSString *error) {
        
    }];
}

//轮询
+ (void)getVideoStatusWithUserId:(int)userId anchorId:(int)anchorId roomId:(int)roomId result:(void (^)(bool isSuccess))result {
    NSString *urlStr = [self getServiceIPUrl:getVideoStatus];
    NSDictionary *dic = @{@"userId" : [NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],
                          @"videoUserId":[NSString stringWithFormat:@"%d", userId],
                          @"videoCoverUserId":[NSString stringWithFormat:@"%d", anchorId],
                          @"roomId":[NSString stringWithFormat:@"%d", roomId],
    };
    
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        NSLog(@"___视频轮询：%@", dataBody);
        if (code == OperationSuccess) {
            int m_object = [dataBody[@"m_object"] intValue];
            bool isS = 0;
            if (m_object == 1) {
                isS = 1;
            }
            if (result) {
                result(isS);
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
            if (result) {
                result(0);
            }
        }
    } failed:^(NSString *error) {
        if (result) {
            result(0);
        }
    }];
}

+ (void)getGuardWithAnchorId:(NSInteger)anchorId Success:(void(^)(NSDictionary *dataDic))success {
    NSString *urlStr = [self getServiceIPUrl:getGuard];
    NSDictionary *dic = @{@"userId" : [NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],
                          @"coverUserId": @(anchorId)
    };
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            NSDictionary *m_object = dataBody[@"m_object"];
            if (success) {
                success(m_object);
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)privateLetterNumberSuccess:(void(^)(bool isCase, NSString *num, bool isGold, NSString *goldNum))success {
    NSString *urlStr = [self getServiceIPUrl:privateLetterNumber];
    NSDictionary *dic = @{@"userId" : [NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id]};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSDictionary *m_object = dataBody[@"m_object"];
            if (success) {
                success([m_object[@"isCase"] boolValue], [NSString stringWithFormat:@"%@", m_object[@"number"]], [m_object[@"isGold"] boolValue], [NSString stringWithFormat:@"%@", m_object[@"goldNumber"]]);
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)greetToAnchorWithAnchorId:(int)anchorId success:(void (^)(void))success {
    NSString *urlStr = [self getServiceIPUrl:greetToAnchor];
    NSDictionary *dic = @{@"userId" : [NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id], @"anchorUserId":@(anchorId)};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            if (success) {
                success();
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)vipStoreWeMiniPPayValue:(int)userId setMealId:(int)setMealId payType:(int)payType payDeployId:(NSInteger)payDeployId success:(void(^)(NSDictionary *payData))success
{
    [SVProgressHUD show];
    NSString *url = [self getServiceIPUrl:vipStoreValueURL];
    [APIManager requestWithChatPath:url
                         Param:@{@"userId":[NSNumber numberWithInt:userId],
                               @"setMealId":[NSNumber numberWithInt:setMealId],
                               @"payType":[NSNumber numberWithInt:payType],
                                 @"payDeployId":@(payDeployId)
                                 }
                       success:^(id dataBody)
    {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *m_object = dataBody[@"m_object"];
                if (success) {
                    success(m_object);
                }
            }
        } else {
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        
    }];
}

+ (void)goldStoreWeMiniPPayValue:(int)userId setMealId:(int)setMealId payType:(int)payType payDeployId:(NSInteger)payDeployId success:(void(^)(NSDictionary *payData))success
{
    [SVProgressHUD show];
    NSString *url = [self getServiceIPUrl:goldStoreValueURL];
    [APIManager requestWithChatPath:url
                              Param:@{@"userId":[NSNumber numberWithInt:userId],
                                      @"setMealId":[NSNumber numberWithInt:setMealId],
                                      @"payType":[NSNumber numberWithInt:payType],
                                      @"payDeployId":@(payDeployId)}
                            success:^(id dataBody)
     {
        [SVProgressHUD dismiss];
         if (code == OperationSuccess) {
             if ([dataBody[@"m_object"] isKindOfClass:[NSDictionary class]]) {
                 NSDictionary *m_object = dataBody[@"m_object"];
                 if (success) {
                     success(m_object);
                 }
             }
         }else{
             [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
         }
     } failed:^(NSString *error) {
         
     }];
}

+ (void)submitIdentificationDataWithParam:(NSDictionary *)param success:(void(^)(void))success {
    NSString *urlStr = [self getServiceIPUrl:submitIdentificationDataURL];
    [APIManager requestWithChatPath:urlStr
                             Param:param
                           success:^(id dataBody)
    {
        if (code == OperationSuccess) {
            [SVProgressHUD showInfoWithStatus:@"您的资料已经提交成功"];
            if (success) {
                success();
            }
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        
    }];
}

+ (void)vipSwitchWithAnchorId:(int)anchorId Success:(void(^)(int resultCode, NSString *message))success {
    NSString *urlStr = [self getServiceIPUrl:vipSwitch];
    NSDictionary *param = @{@"userId":@([YLUserDefault userDefault].t_id),
                            @"launchUserId":@([YLUserDefault userDefault].t_id),
                            @"coverLinkUserId":@(anchorId)
    };
    [APIManager requestWithChatPath:urlStr
                              Param:param
                           success:^(id dataBody)
    {
        NSLog(@"____检测vip 视频次数%@", dataBody);
        if (success) {
            success(code, [NSString stringWithFormat:@"%@", dataBody[@"m_strMessage"]]);
        }
    } failed:^(NSString *error) {
        
    }];
}

+ (void)setFirstAlbumWithId:(int)albumId success:(void (^)(void))success {
    NSString *urlStr = [self getServiceIPUrl:setFirstAlbum];
    NSDictionary *param = @{@"userId":@([YLUserDefault userDefault].t_id),
                            @"albumId":@(albumId)
    };
    [APIManager requestWithChatPath:urlStr
                              Param:param
                           success:^(id dataBody)
    {
        if (code == OperationSuccess) {
            [SVProgressHUD showInfoWithStatus:@"设置成功"];
            if (success) {
                success();
            }
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
    } failed:^(NSString *error) {
        
    }];
}

+ (void)disableUser:(int)userId success:(void (^)(void))success {
    NSString *urlStr = [self getServiceIPUrl:userDisable];
    NSDictionary *dic = @{@"userId":@(userId)};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            if (success) {
                success();
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
    }];
}


#pragma mark ---- 地址
+ (NSString *)getServiceIPUrl:(NSString *)interfaceUrl
{
    //外网 http://app.1-liao.com
    //内网 
    return  [NSString stringWithFormat:@"%@%@",INTERFACEADDRESS,interfaceUrl];
}

//mansion 府邸 -------------------------------------------------------------
#pragma mark - mansion
#define getMansionHouseSwitch @"/app/getMansionHouseSwitch.html"
#define inviteMansionHouseAnchor @"/app/inviteMansionHouseAnchor.html"
#define getMansionHouseFollowList @"/app/getMansionHouseFollowList.html"
#define delMansionHouseAnchor @"/app/delMansionHouseAnchor.html"
#define getMansionHouseInviteList @"/app/getMansionHouseInviteList.html"
#define agreeMansionHouseInvite @"/app/agreeMansionHouseInvite.html"
#define getMansionHouseInfo @"/app/getMansionHouseInfo.html"
#define delMansionHouseAnchor @"/app/delMansionHouseAnchor.html"
#define getMansionHouseList @"/app/getMansionHouseList.html"
#define anchorOutOfMansionHouse @"/app/anchorOutOfMansionHouse.html"
#define addMansionHouseRoom @"/app/addMansionHouseRoom.html"
#define setMansionHouseCoverImg @"/app/setMansionHouseCoverImg.html"
#define launchMansionVideoChat @"/app/launchMansionVideoChat.html"
#define videoMansionChatBeginTiming @"/app/videoMansionChatBeginTiming.html"
#define breakMansionLink @"/app/breakMansionLink.html"
#define getMansionHouseVideoList @"/app/getMansionHouseVideoList.html"
#define closeMansionLink @"/app/closeMansionLink.html"
#define getMansionHouseVideoInfo @"/app/getMansionHouseVideoInfo.html"
//mansion 府邸 -------------------------------------------------------------
//3.1 0713
#define getFirstChargeInfo @"/app/getFirstChargeInfo.html"

// 用户获取是否有府邸权限
+ (void)getMansionHouseSwitchResult:(void (^)(bool houseSwitch, int mansionId, NSString * mansionMoney, NSString *t_mansion_house_coverImg))result {
    NSString *urlStr = [self getServiceIPUrl:getMansionHouseSwitch];
    NSDictionary *param = @{@"userId":@([YLUserDefault userDefault].t_id)};
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:param success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *m_object = dataBody[@"m_object"];
                bool swith = [[NSString stringWithFormat:@"%@", m_object[@"houseSwitch"]] boolValue];
                int mansion_id = [[NSString stringWithFormat:@"%@", m_object[@"mansionId"]] intValue];
                NSString *money = [NSString stringWithFormat:@"%@", m_object[@"mansionMoney"]];
                NSString *cover = [NSString stringWithFormat:@"%@", m_object[@"t_mansion_house_coverImg"]];
                if (result) {
                    result(swith, mansion_id, money, cover);
                }
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:nil];
}

// 用户邀请主播到自己府邸
+ (void)inviteMansionHouseAnchorWithMansionId:(int)mansionId anchorId:(int)anchorId {
    NSString *urlStr = [self getServiceIPUrl:inviteMansionHouseAnchor];
    NSDictionary *param = @{@"userId":@([YLUserDefault userDefault].t_id),
                            @"t_mansion_house_id":@(mansionId),
                            @"anchorId":@(anchorId)
    };
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:param success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"邀请成功"];
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:nil];
}

// type 0 用户获取关注列表 邀请主播(可重复邀请)
// type 1 用户获取府邸里的主播加入聊天房间列表
+ (void)getMansionHouseFollowListWithPage:(int)page mansionId:(int)mansionId searchKey:(NSString *)searchKey mansionRoomId:(int)mansionRoomId type:(int)type success:(void (^)(NSArray *dataArray))success fail:(void (^)(void))fail {
    NSString *urlStr;
    NSDictionary *dic;
    if (type == 0) {
        urlStr = [self getServiceIPUrl:getMansionHouseFollowList];
        dic = @{@"userId" : [NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],
                @"t_mansion_house_id" : @(mansionId),
                @"searchUserId" : [NSString stringWithFormat:@"%@", searchKey],
                @"page" : @(page),
                @"size" : @(10)};
    } else {
        urlStr = [self getServiceIPUrl:getMansionHouseVideoList];
        dic = @{@"userId" : [NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],
                @"mansionRoomId":@(mansionRoomId),
                @"searchUserId" : [NSString stringWithFormat:@"%@", searchKey],
                @"page" : @(page),
                @"size" : @(10)};
    }
    NSMutableArray *listArray = [NSMutableArray array];
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            NSArray *array = dataBody[@"m_object"];
            for (NSDictionary *dic in array) {
                MansionMyFollowListModel *listModel = [MansionMyFollowListModel mj_objectWithKeyValues:dic];
                [listArray addObject:listModel];
            }
            if (success) {
                success(listArray);
            }
        } else {
            if (fail) {
                fail();
            }
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
        if (fail) {
            fail();
        }
    }];
}

// 删除府邸中的主播
+ (void)delMansionHouseAnchorWithMansionid:(int)mansionId anchorId:(int)anchorId success:(void (^)(void))success {
    NSString *urlStr = [self getServiceIPUrl:delMansionHouseAnchor];
    NSDictionary *param = @{@"userId":@([YLUserDefault userDefault].t_id),
                            @"t_mansion_house_id":@(mansionId),
                            @"anchorId":@(anchorId)
    };
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:param success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess && success) {
            success();
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:nil];
}

// 主播获取自己的府邸邀请待操作列表
+ (void)getMansionHouseInviteListWithPage:(int)page success:(void (^)(NSArray *dataArray))success fail:(void (^)(void))fail {
    NSString *urlStr = [self getServiceIPUrl:getMansionHouseInviteList];
    NSDictionary *dic = @{@"userId" : [NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],
                          @"page" : @(page),
                          @"size" : @(10)};
    NSMutableArray *listArray = [NSMutableArray array];
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            NSArray *array = dataBody[@"m_object"];
            for (NSDictionary *dic in array) {
                MansionInviteListModel *listModel = [MansionInviteListModel mj_objectWithKeyValues:dic];
                [listArray addObject:listModel];
            }
            if (success) {
                success(listArray);
            }
        } else {
            if (fail) {
                fail();
            }
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
        if (fail) {
            fail();
        }
    }];
}

// 主播同意或者拒绝加入某个府邸
+ (void)agreeMansionHouseInviteIsAgree:(int)isAgree mansionId:(int)mansionId success:(void(^)(void))success {
    NSString *urlStr = [self getServiceIPUrl:agreeMansionHouseInvite];
    NSDictionary *param = @{@"userId":@([YLUserDefault userDefault].t_id),
                            @"t_mansion_house_id":@(mansionId),
                            @"agreeType":@(isAgree)
    };
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:param success:^(id dataBody) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        if (code == OperationSuccess && success) {
            success();
        }
    } failed:nil];
}

// 获取用户的府邸里面的主播列表
+ (void)getMansionHouseInfoWithId:(int)mansionid success:(void (^)(NSArray *dataArray))success  {
    NSString *urlStr = [self getServiceIPUrl:getMansionHouseInfo];
    NSDictionary *dic = @{@"userId" : [NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],
                          @"t_mansion_house_id" : @(mansionid)
    };
    NSMutableArray *listArray = [NSMutableArray array];
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            NSArray *array = dataBody[@"m_object"];
            for (NSDictionary *dic in array) {
                MansionAnchorModel *listModel = [MansionAnchorModel mj_objectWithKeyValues:dic];
                [listArray addObject:listModel];
            }
            if (success) {
                success(listArray);
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:nil];
}

// 获取主播加入的府邸列表
+ (void)getMansionHouseListWithPage:(int)page success:(void (^)(NSArray *dataArray))success fail:(void (^)(void))fail {
    NSString *urlStr = [self getServiceIPUrl:getMansionHouseList];
    NSDictionary *dic = @{@"userId" : [NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id],
                          @"page" : @(page),
                          @"size" : @(10)};
    NSMutableArray *listArray = [NSMutableArray array];
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            NSArray *array = dataBody[@"m_object"];
            for (NSDictionary *dic in array) {
                MansionJoinedModel *listModel = [MansionJoinedModel mj_objectWithKeyValues:dic];
                [listArray addObject:listModel];
            }
            if (success) {
                success(listArray);
            }
        } else {
            if (fail) {
                fail();
            }
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
        if (fail) {
            fail();
        }
    }];
}

// 主播退出府邸
+ (void)anchorOutOfMansionHouseWithMansionid:(int)mansionId success:(void (^)(void))success {
    NSString *urlStr = [self getServiceIPUrl:anchorOutOfMansionHouse];
    NSDictionary *param = @{@"userId":@([YLUserDefault userDefault].t_id),
                            @"t_mansion_house_id":@(mansionId),
    };
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:param success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess && success) {
            success();
            [SVProgressHUD showSuccessWithStatus:@"退出成功"];
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:nil];
}

// 用户府邸创建聊天房间
+ (void)addMansionHouseRoomWithId:(int)mansionId roomName:(NSString *)name chatType:(int)type success:(void (^)(int mansionRoomId))success {
    NSString *urlStr = [self getServiceIPUrl:addMansionHouseRoom];
    NSDictionary *param = @{@"userId":@([YLUserDefault userDefault].t_id),
                            @"t_mansion_house_id":@(mansionId),
                            @"roomName":[NSString stringWithFormat:@"%@", name],
                            @"chatType":@(type)
    };
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:param success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess && success) {
            int roomId = [[NSString stringWithFormat:@"%@", dataBody[@"m_object"]] intValue];
            success(roomId);
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:nil];
}

// 用户府邸创建封面
+ (void)setMansionHouseCoverImgWithId:(int)mansionId imagePath:(NSString *)path success:(void (^)(void))success {
    NSString *urlStr = [self getServiceIPUrl:setMansionHouseCoverImg];
    NSDictionary *param = @{@"userId":@([YLUserDefault userDefault].t_id),
                            @"t_mansion_house_id":@(mansionId),
                            @"mansionCoverImg":[NSString stringWithFormat:@"%@", path]
    };
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:param success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess && success) {
            success();
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:nil];
}

// 府邸房间 用户呼叫主播
+ (void)launchMansionVideoChatWithRoomId:(int)roomId chatType:(int)type anchorId:(int)anchorId {
    NSString *urlStr = [self getServiceIPUrl:launchMansionVideoChat];
    NSDictionary *param = @{@"userId":@([YLUserDefault userDefault].t_id),
                            @"mansionRoomId":@(roomId),
                            @"chatType":@(type),
                            @"coverLinkUserId":@(anchorId)
    };
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:param success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == -4 || code == -1) {
            NSString *tip = @"发起视频聊天失败";
            if (type == 2) {
                tip = @"发起语音聊天失败";
            }
            [SVProgressHUD showInfoWithStatus:tip];
            // 余额不足
            [[YLInsufficientManager shareInstance] insufficientShow];
        }else if (code == -5){
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }else if (code == -3){
            [SVProgressHUD showInfoWithStatus:@"对方设置已设为勿扰"];
        }else if (code == -2){
            [SVProgressHUD showInfoWithStatus:@"你拨打的用户正忙,请稍后在拨"];
        }else if (code == -7) {
            [SVProgressHUD dismiss];
            [LXTAlertView vipWithContet:dataBody[@"m_strMessage"]];
        }else if (code == -10 ) {
            [SVProgressHUD showInfoWithStatus:@"当前连接已断开，请稍后再试"];
            [[YLSocketExtension shareInstance] disconnect];
            [[YLSocketExtension shareInstance] connectHost];
            return;
        }else if (code == OperationSuccess){
            [SVProgressHUD showInfoWithStatus:@"邀请成功"];
        }else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:nil];
}

// 府邸房间开始计时
+ (void)videoMansionChatBeginTimingWithMansionRoomId:(int)mansionRoomId roomId:(int)roomId chatType:(int)type success:(void (^)(void))success fail:(void (^)(void))fail {
    NSString *urlStr = [self getServiceIPUrl:videoMansionChatBeginTiming];
    NSDictionary *param = @{@"userId":@([YLUserDefault userDefault].t_id),
                            @"mansionRoomId":@(mansionRoomId),
                            @"chatType":@(type),
                            @"roomId":@(roomId)
    };
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:param success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            if (success) {
                success();
            }
        } else if (code == -1 || code == -4) {
            // 余额不足
            [[YLInsufficientManager shareInstance] insufficientShow];
        } else if (code == -7) {
            // vip
            [LXTAlertView vipWithContet:dataBody[@"m_strMessage"]];
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
            if (fail) {
                fail();
            }
        }
    } failed:^(NSString *error) {
        if (fail) {
            fail();
        }
    }];
}

// 府邸房间挂断（小房间）
+ (void)breakMansionLinkWithMansionRoomId:(int)mansionRoomId roomId:(int)roomId breakUserId:(int)breakUserId result:(void(^)(void))result {
    NSString *urlStr = [self getServiceIPUrl:breakMansionLink];
    NSDictionary *param = @{@"userId":@([YLUserDefault userDefault].t_id),
                            @"mansionRoomId":@(mansionRoomId),
                            @"breakUserId":@(breakUserId),
                            @"roomId":@(roomId)
    };
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:param success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (result) {
            result();
        }
        if (code == OperationSuccess) {
            
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:nil];
}

//府邸房间挂断（大房间）
+ (void)closeMansionLinkWithMansionRoomId:(int)mansionRoomid {
    NSString *urlStr = [self getServiceIPUrl:closeMansionLink];
    NSDictionary *param = @{@"userId":@([YLUserDefault userDefault].t_id),
                            @"mansionRoomId":@(mansionRoomid)
    };
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:param success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:nil];
}

// 获取府邸大房间的信息
+ (void)getMansionHouseVideoInfoWithMansionRoomId:(int)mansionRoomid success:(void(^)(NSDictionary *roomInfo))success {
    NSString *urlStr = [self getServiceIPUrl:getMansionHouseVideoInfo];
    NSDictionary *param = @{@"userId":@([YLUserDefault userDefault].t_id),
                            @"mansionRoomId":@(mansionRoomid)
    };
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:param success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = dataBody[@"m_object"];
                if (success) {
                    success(dic);
                }
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:nil];
}

//-------------------------------------------------------------------------
//3.1 0713
+ (void)getFirstChargeInfoSuccess:(void (^)(NSDictionary *dataDic))success {
    NSString *urlStr = [self getServiceIPUrl:getFirstChargeInfo];
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id)};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        NSLog(@"______首充：%@", dataBody);
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *m_object = dataBody[@"m_object"];
                if (success) {
                    success(m_object);
                }
            }
        } else {
        }
    } failed:^(NSString *error) {
    }];
}


#pragma mark ---- 获取首冲排行
+ (void)getFirstCharge:(int)userId queryType:(NSInteger)queryType block:(JSONObjectBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getFirstChargeURL];
    
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"queryType":@(queryType)} success:^(id dataBody) {
        if (code == OperationSuccess) {
            if (dataBody) {
            NSArray *m_objectDic = dataBody[@"m_object"];

            for (int i = 0; i < [m_objectDic count]; i++) {
                NSDictionary *dic = m_objectDic[i];
                anchorAddGuildHandle *handle = [anchorAddGuildHandle mj_objectWithKeyValues:dic];
                handle.type = 3;
                handle.index= i+1;
                [listArray addObject:handle];
            }}
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
        }
        block(listArray);
    } failed:^(NSString *error) {
        
    }];
    
}


+ (void)getRefereeSuccess:(void (^)(int resultCode))success {
    NSString *urlStr = [self getServiceIPUrl:getReferee];
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id)};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (success) {
            success(code);
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)getIMToUserMesListSuccess:(void (^)(NSArray *msgArray))success {
    NSString *urlStr = [self getServiceIPUrl:getIMToUserMesList];
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id)};
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSArray class]]) {
                NSArray *arr = dataBody[@"m_object"];
                if (success) {
                    success(arr);
                }
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)sendIMToUserMesWithMessage:(NSString *)message success:(void (^)(void))success {
    NSString *urlStr = [self getServiceIPUrl:sendIMToUserMes];
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id),
                          @"imId":[NSString stringWithFormat:@"%@", message]
    };
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        if (code == OperationSuccess && success) {
            success();
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)getAgoraRoomSignWithRoomId:(int)roomId Success:(void (^)(NSString *rtcToken))success fail:(void (^)(void))fail {
    NSString *urlStr = [self getServiceIPUrl:getAgoraRoomSign];
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id), @"roomId":[NSString stringWithFormat:@"%d", roomId]};
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess && success) {
            NSDictionary *m_object = dataBody[@"m_object"];
            NSString *rtcToken = [NSString stringWithFormat:@"%@", m_object[@"rtcToken"]];
            success(rtcToken);
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
            if (fail) {
                fail();
            }
        }
    } failed:^(NSString *error) {
        if (fail) {
            fail();
        }
    }];
}

+ (void)getServiceIdSuccess:(void (^)(NSArray *idArray))success {
    NSString *urlStr = [self getServiceIPUrl:getServiceId];
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id)};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSArray class]]) {
                NSArray *arr = dataBody[@"m_object"];
                if (success) {
                    success(arr);
                }
            }
        } else {
            if (success) {
                success(nil);
            }
//            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
        if (success) {
            success(nil);
        }
    }];
}

+ (void)receiveRankGoldWithId:(int)awardId btnType:(int)btnType rankType:(int)rankType success:(void(^)(void))success {
    NSString *urlStr = [self getServiceIPUrl:receiveRankGold];
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id),
                          @"rankType":@(rankType),
                          @"queryType":@(btnType),
                          @"rankRewardId":@(awardId)
    };
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"领取成功"];
            if (success) {
                success();
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)getSystemConfigAndSave {
    NSString *urlStr = [self getServiceIPUrl:getSystemConfig];
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id)};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *m_object = dataBody[@"m_object"];
                [[NSUserDefaults standardUserDefaults] setObject:m_object forKey:@"RANKAWARDSETTING"];
            }
        } else {
//            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)getRankConfigWithBtnType:(int)btnType rankType:(int)rankType success:(void (^)(NSDictionary *dataDic))success {
    NSString *urlStr = [self getServiceIPUrl:getRankConfig];
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id),
                          @"rankType":@(rankType),
                          @"queryType":@(btnType)};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *m_object = dataBody[@"m_object"];
                if (success) {
                    success(m_object);
                }
            }
        } else {
        }
    } failed:^(NSString *error) {
        
    }];
}

+ (void)getShareRewardConfigListSuccess:(void (^)(NSDictionary *dataDic))success {
    NSString *urlStr = [self getServiceIPUrl:getShareRewardConfigList];
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id)};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = dataBody[@"m_object"];
                if (success) {
                    success(dic);
                }
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)receiveShareRewardGoldWithId:(NSString *)t_reward_id success:(void(^)(void))success {
    NSString *urlStr = [self getServiceIPUrl:receiveShareRewardGold];
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id),
                          @"t_reward_id":[NSString stringWithFormat:@"%@", t_reward_id]};
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
//            [SVProgressHUD showSuccessWithStatus:@"领取成功"];
            if (success) {
                success();
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)getUserRankInfoSuccess:(void (^)(NSArray *awardArray))success {
    NSString *urlStr = [self getServiceIPUrl:getUserRankInfo];
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id)};
    NSMutableArray *listArray = [NSMutableArray array];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSArray class]]) {
                NSArray *arr = dataBody[@"m_object"];
                for (int i = 0; i < [arr count]; i++) {
                    NSDictionary *dic = arr[i];
                    rankingHandle *handle = [rankingHandle mj_objectWithKeyValues:dic];
                    [listArray addObject:handle];
                }
                if (success) {
                    success(listArray);
                }
            }
        }
    } failed:^(NSString *error) {
    }];
    
}

+ (void)getNewFirstChargeInfoSuccess:(void (^)(NSDictionary *dataDic))success {
    NSString *urlStr = [self getServiceIPUrl:getNewFirstChargeInfo];
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id)};
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = dataBody[@"m_object"];
                if (success) {
                    success(dic);
                }
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
    }];
}

//详情页 用户印象
+ (void)getNewEvaluationListWithId:(NSInteger)userId Success:(void (^)(NSArray *dataArr))success {
    NSString *urlStr = [self getServiceIPUrl:getNewEvaluationList];
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id), @"coverUserId":@(userId)};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSArray class]]) {
                NSArray *arr = dataBody[@"m_object"];
                if (success) {
                    success(arr);
                }
            }
        } else {
//            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
    }];
}

//主播守护榜
+ (void)getUserGuardGiftListWithId:(NSInteger)userId Success:(void (^)(NSArray *dataArr))success {
    NSString *urlStr = [self getServiceIPUrl:getUserGuardGiftList];
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id), @"coverUserId":@(userId)};
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSArray class]]) {
                NSArray *arr = dataBody[@"m_object"];
                if (success) {
                    success(arr);
                }
            }
        } else {
//            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)getVideoComsumerInfoWithRoomId:(NSString *)roomId userId:(int)userId success:(void (^)(NSDictionary *dataDic))success {
    NSString *urlStr = [self getServiceIPUrl:getVideoComsumerInfo];
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id),
                          @"roomId":[NSString stringWithFormat:@"%@", roomId],
                          @"coverUserId":[NSString stringWithFormat:@"%d", userId]
    };
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = dataBody[@"m_object"];
                if (success) {
                    success(dic);
                }
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)getcertifyStatusSuccess:(void (^)(NSDictionary *dataDic))success {
    NSString *urlStr = [self getServiceIPUrl:getcertifyStatus];
    NSDictionary *dic = @{@"userId":@([YLUserDefault userDefault].t_id)};
    [SVProgressHUD show];
    [APIManager requestWithChatPath:urlStr Param:dic success:^(id dataBody) {
        [SVProgressHUD dismiss];
        if (code == OperationSuccess) {
            if ([dataBody[@"m_object"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = dataBody[@"m_object"];
                if (success) {
                    success(dic);
                }
            }
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",dataBody[@"m_strMessage"]]];
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)acquire:(NSString *)cname success:(void (^)(NSString *data))success {
    NSString *urlStr = [self getServiceIPUrl:@"/app/acquire.html"];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"cname":cname} success:^(id dataBody) {
        
        if (code == OperationSuccess && success) {
            NSString *dic = dataBody[@"m_object"];
            success(dic);
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)startEvent:(NSString *)resourceId cname:(NSString *)cname token:(NSString *)token subscribeAudioUids:(NSString *)subscribeAudioUids success:(void (^)(NSString *data))success {
    NSString *urlStr = [self getServiceIPUrl:@"/app/startEvent.html"];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"resourceId":resourceId,@"cname":cname,@"token":token,@"subscribeAudioUids":subscribeAudioUids} success:^(id dataBody) {
        
        if (code == OperationSuccess && success) {
            NSString *dic = dataBody[@"m_object"];
            success(dic);
        }
    } failed:^(NSString *error) {
    }];
}

+ (void)stopEvent:(NSString *)sid resourceId:(NSString *)resourceId success:(void (^)(void))success {
    NSString *urlStr = [self getServiceIPUrl:@"/app/stopEvent.html"];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"sid":sid,@"resourceid":resourceId} success:^(id dataBody) {
        if (code == OperationSuccess && success) {
            success();
        }
    } failed:^(NSString *error) {
    }];
}





// 获取临时请求地址   在现有访问域名失效的情况下使用
//+ (void)getTemporaryIP {
//    if ([get_temporary_socket containsString:@"null"]) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"get_temporary_socket"];
//    }
//    if ([get_temporary_ip containsString:@"null"]) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"get_temporary_ip"];
//    }
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
//                                                         @"text/html",
//                                                         @"image/jpeg",
//                                                         @"image/png",
//                                                         @"application/octet-stream",
//                                                         @"text/json",
//                                                         nil];
//    NSString *url = [NSString stringWithFormat:@"%@/app/getProtectAppVersion.html", TemporaryIP];
//    [manager POST:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"____getTemporaryIP:%@", responseObject);
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            if ([responseObject[@"m_istatus"] intValue] == 1) {
//                NSDictionary *m_object = responseObject[@"m_object"];
//                if ([m_object isKindOfClass:[NSDictionary class]]) {
//                    int request_status = [m_object[@"request_status"] intValue];
//                    if (request_status == 1) {
//                        NSString *request_url = m_object[@"request_url"];
//                        NSString *request_socket = m_object[@"request_socket"];
//                        if (![request_url isEqualToString:get_temporary_ip] || ![request_socket isEqualToString:get_temporary_socket]) {
//                            [[NSUserDefaults standardUserDefaults] setObject:request_socket forKey:@"get_temporary_socket"];
//                            [[NSUserDefaults standardUserDefaults] setObject:request_url forKey:@"get_temporary_ip"];
//                            [LXTAlertView alertViewDefaultOnlySureWithTitle:@"提示" message:@"App有内容更新，请重新打开" sureHandle:^{
//                                exit(0);
//                            }];
//                        }
//                        NSLog(@"1_____address:%@\n_____socket:%@", INTERFACEADDRESS, SOCKETIP);
//                        return;
//                    }
//                }
//            }
//        }
//        NSString *temporary_ip = get_temporary_ip;
//        NSString *temporary_socket = get_temporary_socket;
//        if (temporary_ip.length > 0 || temporary_socket.length > 0) {
//            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"get_temporary_socket"];
//            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"get_temporary_ip"];
//            [LXTAlertView alertViewDefaultOnlySureWithTitle:@"提示" message:@"App有内容更新，请重新打开" sureHandle:^{
//                exit(0);
//            }];
//        }
//        
//        NSLog(@"2_____address:%@\n_____socket:%@", INTERFACEADDRESS, SOCKETIP);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"getTemporaryIP error:%@", error);
//    }];
//}

+ (void)requestAutoExamineSetup:(void (^)(void))success fail:(void (^)(void))fail {
    NSString *urlStr = [self getServiceIPUrl:getAutoExamineSetup];
   
    [APIManager requestWithChatPath:urlStr Param:nil success:^(id dataBody) {
        if (code == OperationSuccess) {
            NSString *isopen = dataBody[@"m_object"];
            if ([isopen isEqualToString:@"1"])
            {
                if (success) {
                    success();
                }
            }
            else
            {
                if (fail) {
                    fail();
                }
            }
        } else {
            if (fail) {
                fail();
            }
        }
    } failed:^(NSString *error) {
        if (fail) {
            fail();
        }
    }];
}

+ (void)has_paypass:(int)userId block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getHasPayPass];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            block(YES);
        }else{
            block(NO);
        }
    } failed:^(NSString *error) {
        
    }];
}

+ (void)has_extractauth:(int)userId block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:getExtractAuth];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId]} success:^(id dataBody) {
        if (code == OperationSuccess) {
            block(YES);
        }else{
            block(NO);
        }
    } failed:^(NSString *error) {
        
    }];
}

+ (void)up_paypass:(int)userId oldpass:(NSString *)oldpass newpass:(NSString *)newpass block:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:upPayPassword];
    
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":[NSNumber numberWithInt:userId],@"orgpass":oldpass,@"newpass":newpass} success:^(id dataBody) {
        if (code == OperationSuccess) {
            [SVProgressHUD showInfoWithStatus:@"修改成功"];
            block(YES);
        }else{
            if (dataBody[@"m_strMessage"] != nil)
            {
                [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"修改失败"];
            }
            
            block(NO);
        }
    } failed:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:@"修改失败"];
        block(NO);
    }];
}

+ (void)sendMoneyCode:(NSString *)userid
              sendVericationBlock:(JSONBOOLBlock)block
{
    NSString *urlStr = [self getServiceIPUrl:sendMoneyVerificationCode];
    
    [SVProgressHUD showWithStatus:@"正在发送验证码..."];
    [APIManager requestWithChatPath:urlStr Param:@{@"userId":userid} success:^(id dataBody) {
        [SVProgressHUD dismiss];

        if (code == OperationSuccess) {
            [SVProgressHUD showInfoWithStatus:@"短信发送成功,请注意查收"];

            block(YES);
        }else{
            [SVProgressHUD showInfoWithStatus:dataBody[@"m_strMessage"]];
            
            block(NO);
        }
    } failed:^(NSString *error) {
        [SVProgressHUD dismiss];
        block(NO);
    }];
}

+ (void)getThirdSetupAction:(int)timeOut success:(void (^)(NSDictionary *dataInfo))success  fail:(void (^) (void))fail {
    
    NSString *urlStr = [self getServiceIPUrl:getThirdSetup];
    NSDictionary *param = @{};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = timeOut;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"text/json",
                                                         nil];
    [manager GET:urlStr parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"m_istatus"]intValue] == OperationSuccess) {
            if ([responseObject[@"m_object"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *m_object = responseObject[@"m_object"];
                success(m_object);
            } else {
                if (fail) {
                    fail();
                }
                [SVProgressHUD dismiss];
            }
        } else {
            if (fail) {
                fail();
            }
            [SVProgressHUD showInfoWithStatus:responseObject[@"m_strMessage"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail();
        }
//        [SVProgressHUD showInfoWithStatus:@"请检查网络连接！"];
    }];
}


@end
