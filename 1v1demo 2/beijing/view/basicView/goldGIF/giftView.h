//
//  giftView.h
//  beijing
//
//  Created by zhou last on 2018/6/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "giftListHandle.h"


typedef enum {
    YLRewardTypeGift = 0, //礼物
    YLRewardTypeClose, //关闭
} YLRewardType;


@interface giftView : UIView

typedef void (^YLRewardGiftBlock)(YLRewardType type,giftListHandle *handle);


//白色背景
@property (weak, nonatomic) IBOutlet UIView *whiteBgView;

//确定打赏
@property (weak, nonatomic) IBOutlet UIButton *rewardButton;

//关闭
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

//金币打赏
@property (weak, nonatomic) IBOutlet UIButton *coinsRewardButton;

//确定打赏
@property (weak, nonatomic) IBOutlet UIButton *rewardOkButton;

@property (weak, nonatomic) IBOutlet UIScrollView *gifScrollView;

//玫瑰背景
@property (weak, nonatomic) IBOutlet UIView *roseView;
//蛋糕背景
@property (weak, nonatomic) IBOutlet UIView *cakeView;
//戒指
@property (weak, nonatomic) IBOutlet UIView *ringView;
//皇冠
@property (weak, nonatomic) IBOutlet UIView *crownView;
//宝石
@property (weak, nonatomic) IBOutlet UIView *gemView;
//游艇
@property (weak, nonatomic) IBOutlet UIView *motorboatView;
//跑车
@property (weak, nonatomic) IBOutlet UIView *racingCarView;
//城堡
@property (weak, nonatomic) IBOutlet UIView *castleView;

- (void)giftCordius;
- (void)rewardGiftBlock:(YLRewardGiftBlock)block;


@end
