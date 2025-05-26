//
//  YLPushManager.h
//  beijing
//
//  Created by yiliaogao on 2019/3/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLPushManager : NSObject

+ (void)pushAnchorDetail:(NSInteger)anchorId;

+ (void)pushUserInfo:(NSInteger)anchorId;

+ (void)pushFansDetail:(NSInteger)fansId;

+ (void)bannerPushClass:(NSString *)jumpUrl;

+ (void)pushChatViewController:(NSInteger)otherId otherSex:(NSInteger)sex;

+ (void)pushService;//跳转客服
+ (void)pushInvite;//跳转邀请

+ (void)pushReportWithId:(NSInteger)userId;

+ (void)pushVipWithEndTime:(nullable NSString *)endTime;



+ (void)pushMainPage;

+ (void)appNeedUptateWithData:(NSDictionary *)dataDic;
+ (void)clickedUpdateVersionBtn;

@end

NS_ASSUME_NONNULL_END
