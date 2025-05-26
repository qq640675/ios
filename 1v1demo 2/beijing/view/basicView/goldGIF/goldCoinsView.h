//
//  goldCoinsView.h
//  beijing
//
//  Created by zhou last on 2018/6/28.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goldCoinsView : UIView

typedef enum {
    YLBackTypeCoins = 0, //金币
    YLBackTypeKeyShow, //键盘弹出
    YLBackTypeKeyHide,    //键盘隐藏
    YLBackTypeClose, //关闭
} YLBackType;

typedef void (^YLRewardBlock)(YLBackType type,int coins);


@property (weak, nonatomic) IBOutlet UIView *whiteBgView;

//可用金币
@property (weak, nonatomic) IBOutlet UILabel *canUseCoinsLabel;

//金币背景
@property (weak, nonatomic) IBOutlet UIView *goldBgView;
//关闭
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

//这里没用具体的英文数字命名，那样太长了
//99金币
@property (weak, nonatomic) IBOutlet UIButton *doubleNineButton;
//188金币
@property (weak, nonatomic) IBOutlet UIButton *oneDoubleEightButton;
//520金币
@property (weak, nonatomic) IBOutlet UIButton *fiveTwoZeroButton;
//999金币
@property (weak, nonatomic) IBOutlet UIButton *threeNineButton;
//1314金币
@property (weak, nonatomic) IBOutlet UIButton *thirteenFourteenButton;
//8888金币
@property (weak, nonatomic) IBOutlet UIButton *fourEightButton;

//确定打赏
@property (weak, nonatomic) IBOutlet UIButton *rewardButton;

//其他金币
@property (weak, nonatomic) IBOutlet UITextField *otherCoinTextField;
//礼物打赏
@property (weak, nonatomic) IBOutlet UIButton *giftRewardButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

- (void)cordius:(UIViewController *)selfVC;
- (void)hideGifReward:(BOOL)isHide;
- (void)textFieldResignFirstResponder;

- (void)covertBack;

- (void)rewardCoinBlock:(YLRewardBlock)block;

@end
