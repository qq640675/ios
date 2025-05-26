//
//  giftView.m
//  beijing
//
//  Created by zhou last on 2018/6/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "giftView.h"
#import "YLBasicView.h"
#import "DefineConstants.h"
#import "YLNetworkInterface.h"
#import "YLGifExtension.h"
#import <SVProgressHUD.h>

@interface giftView ()
{
    giftListHandle *gifthandle;
}

@property (nonatomic ,strong) YLRewardGiftBlock giftBlock;

@end

@implementation giftView


- (void)giftCordius
{
    CGRect frame = _whiteBgView.frame;
    frame.size.width = App_Frame_Width;
    _whiteBgView.frame = frame;
    
    [_rewardButton.layer setCornerRadius:4.];
    [YLBasicView topRightAngleBottomCorner:_whiteBgView firstCorner:UIRectCornerTopLeft secondCorner:UIRectCornerTopRight radius:8.];
    
    [_roseView.layer setCornerRadius:4.];
    [_cakeView.layer setCornerRadius:4.];
    [_ringView.layer setCornerRadius:4.];
    [_gemView.layer setCornerRadius:4.];
    [_crownView.layer setCornerRadius:4.];
    [_motorboatView.layer setCornerRadius:4.];
    [_racingCarView.layer setCornerRadius:4.];
    [_castleView.layer setCornerRadius:4.];
    [_rewardOkButton.layer setCornerRadius:4.];
    _rewardOkButton.enabled = YES;
    
    [YLNetworkInterface getGiftList:^(NSMutableArray *listArray) {
        if (listArray.count != 0) {
            self->gifthandle = listArray[0];
            [[YLGifExtension shareInstance] createGifView:listArray scrollView:self.gifScrollView block:^(giftListHandle *handle) {
                self->gifthandle = handle;
            }];
        }else{
            self->gifthandle = nil;
        }
       
    }];
}

- (void)rewardGiftBlock:(YLRewardGiftBlock)block
{
    _giftBlock = block;
}

#pragma mark ---- 关闭
- (IBAction)closeButtonBeClicked:(id)sender {
    _giftBlock(YLRewardTypeClose,nil);
}


#pragma mark ---- 确定打赏
- (IBAction)rewardOkButtonBeClicked:(id)sender {
    if (gifthandle == nil) {
        [SVProgressHUD showInfoWithStatus:@"请选择礼物类型!!!"];
    }else{
        _rewardOkButton.enabled = NO;
        for (UIView *view in [self subviews]) {
            [view removeFromSuperview];
        }
        _giftBlock(YLRewardTypeGift,gifthandle);
    }
}


@end
