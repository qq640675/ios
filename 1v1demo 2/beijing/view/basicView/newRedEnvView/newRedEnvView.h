//
//  newRedEnvView.h
//  beijing
//
//  Created by zhou last on 2018/10/26.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface newRedEnvView : UIView

typedef void (^YLNewRedEnvBlock)(int giftId,NSString *giftName, NSString *t_gift_still_url, NSString *t_gift_url,int coins);


//礼物
@property (weak, nonatomic) IBOutlet UILabel *giftLabel;
//红包
@property (weak, nonatomic) IBOutlet UILabel *redEnvLabel;
//礼物滚动
@property (weak, nonatomic) IBOutlet UIScrollView *giftScrollView;

//可用金币
@property (weak, nonatomic) IBOutlet UILabel *canUseCoinLabel;
//充值
@property (weak, nonatomic) IBOutlet UILabel *rechargeLabel;
//打赏
@property (weak, nonatomic) IBOutlet UIButton *dashangBtn;

//圆角
- (void)cordius;
//移除滚动框的子视图
- (void)removeScrollViewSubviews;
//红包
- (void)createRedEnvelop:(YLNewRedEnvBlock)block;
//礼物
- (void)createGift:(NSMutableArray *)array block:(YLNewRedEnvBlock)block;

@end

NS_ASSUME_NONNULL_END
