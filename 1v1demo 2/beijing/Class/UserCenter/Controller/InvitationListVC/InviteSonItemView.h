//
//  InviteSonItemView.h
//  Qiaqia
//
//  Created by 刘森林 on 2020/12/15.
//  Copyright © 2020 yiliaogaoke. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    RedPacketStatusGeted,  // 已领取
    RedPacketStatusCanGet, // 可领取
    RedPacketStatusCant,   // 不能领取  还差人
} RedPacketStatus;

@interface InviteSonItemView : BaseView

@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) UIImageView   *tempImageView;
@property (nonatomic, strong) UILabel   *titleLb;
@property (nonatomic, strong) UILabel *lb;
@property (nonatomic, strong) UILabel   *moneyLb;
@property (nonatomic, assign) NSInteger myInvitedNum;
@property (nonatomic, strong) NSDictionary *redPacketDic;
@property (nonatomic, copy) void (^ getRedPacketSuccess)(void);

- (void)setRedPacketData:(NSDictionary *)dataDic;

@end

NS_ASSUME_NONNULL_END
