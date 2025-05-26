//
//  YLBrushGigft.m
//  presentAnimation
//
//  Created by zhou last on 2018/8/9.
//  Copyright © 2018年 许博. All rights reserved.
//

#import "YLBrushGigft.h"
#import "PresentView.h"
#import "AnimOperation.h"
#import "AnimOperationManager.h"
#import "GSPChatMessage.h"

@implementation YLBrushGigft


#pragma mark --- 实例
+ (instancetype)sharedInstance
{
    static id gift;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gift = [YLBrushGigft new];
    });
    return gift;
}

/**
 model赋值

 @param headImage 头像
 @param name 名字
 @param giftName 礼物名字 如 1个【鲜花】
 @param gifImage 礼物图片
 @return 返回model
 */
- (GiftModel *)modelHeadImage:(UIImage *)headImage name:(NSString *)name giftName:(NSString *)giftName gifImage:(UIImage *)gifImage count:(int)count
{
    GiftModel *giftModel = [[GiftModel alloc] init];
    giftModel.headImage = headImage;
    giftModel.name = name;
    giftModel.giftImage = gifImage;
    giftModel.giftName = giftName;
    giftModel.giftCount = count;
    
    return giftModel;
}


/**
 刷礼物

 @param userId 发送者id
 @param model 礼物model
 @param selfView 当前视图
 */
- (void)brushUserId:(NSString *)userId model:(GiftModel *)model view:(UIView *)selfView
{
    AnimOperationManager *manager = [AnimOperationManager sharedManager];
    manager.parentView = selfView;
    // 用用户唯一标识 msg.senderChatID 存礼物信息,model 传入礼物模型
    [manager animWithUserID:userId model:model finishedBlock:^(BOOL result) {
        
    }];
}


@end
