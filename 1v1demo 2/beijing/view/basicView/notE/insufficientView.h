//
//  insufficientView.h
//  beijing
//
//  Created by zhou last on 2018/10/7.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum
{
    YLVideoRechargeTypeFirst = 1, //第一个充值项
    YLVideoRechargeTypeSecond,
}YLVideoRechargeType;

typedef enum
{
    YLVideoPayTypeApliy = -1,//支付宝
    YLVideoPayTypeWechat = -2,//微信
    YLVideoPayTypeApliy1 = -3,//第四方支付
    YLVideoPayTypeWeb = -4,
    YLVideoPayTypeWeMiniP = -5,
    YLVideoPayTypeAlipayMinip = -6,
}YLVideoPayType;

@interface insufficientView : UIView

//返回充值类型和支付类型
typedef void (^YLInsufficientBlock)(YLVideoPayType payType,YLVideoRechargeType rechargeType);
//免费获取金币
typedef void (^YLGetCoinFreeBlock)(BOOL isGet);

@property (nonatomic, copy) void(^changedPayTaype)(YLVideoPayType payType);
//升级vip
@property (weak, nonatomic) IBOutlet UIView *vipUpgrateView;
//默认金额1
//选中图
@property (weak, nonatomic) IBOutlet UIImageView *firstSelImgView;
//充值金额(元)
@property (weak, nonatomic) IBOutlet UILabel *firstYuanLabel;

//充值金币
@property (weak, nonatomic) IBOutlet UILabel *firstCoinLabel;

//默认金额2
@property (weak, nonatomic) IBOutlet UIImageView *secondSelImgView;
//充值金额(元)
@property (weak, nonatomic) IBOutlet UILabel *secondYuanLabel;

//充值金币
@property (weak, nonatomic) IBOutlet UILabel *secondCoinLabel;
//免费领取金币
@property (weak, nonatomic) IBOutlet UILabel *getCoinLabel;

//默认金额1背景
@property (weak, nonatomic) IBOutlet UIView *firstRechargeBgView;
//默认金额2背景
@property (weak, nonatomic) IBOutlet UIView *secondRechargeBgView;


//更多充值金额
@property (weak, nonatomic) IBOutlet UIView *moreRechargeView;

//微信支付背景
@property (weak, nonatomic) IBOutlet UIView *wechatBgView;
@property (weak, nonatomic) IBOutlet UIImageView *wechatSelImgView;

//支付宝支付背景
@property (weak, nonatomic) IBOutlet UIView *apliyBgView;
@property (weak, nonatomic) IBOutlet UIImageView *apliySelImgView;

//充值
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;

//支付图片
@property (weak, nonatomic) IBOutlet UIImageView *payIconImageView;
//支付名称
@property (weak, nonatomic) IBOutlet UILabel     *payNameLb;

- (void)tapBlock:(YLInsufficientBlock)block getCoinBlock:(YLGetCoinFreeBlock)getCoinBlock;

@end

NS_ASSUME_NONNULL_END
