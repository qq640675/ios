//
//  goldCoinsView.m
//  beijing
//
//  Created by zhou last on 2018/6/28.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "goldCoinsView.h"
#import "DefineConstants.h"
#import "YLBasicView.h"
#import "YLTapGesture.h"
#import "giftView.h"
#import <SVProgressHUD.h>
#import "NSString+Util.h"

@interface goldCoinsView ()<UITextFieldDelegate>
{
    UIButton *lastClickButton;
    giftView *gifView;
}

@property (nonatomic ,strong) YLRewardBlock rewardBlock;

@end

@implementation goldCoinsView

- (void)cordius:(UIViewController *)selfVC
{
    CGRect frame = _whiteBgView.frame;
    frame.size.width = App_Frame_Width;
    _whiteBgView.frame = frame;
    
    [YLBasicView topRightAngleBottomCorner:_whiteBgView firstCorner:UIRectCornerTopLeft secondCorner:UIRectCornerTopRight radius:8.];
    [_doubleNineButton.layer setCornerRadius:4.];
    [_oneDoubleEightButton.layer setCornerRadius:4.];
    [_fiveTwoZeroButton.layer setCornerRadius:4.];
    [_threeNineButton.layer setCornerRadius:4.];
    [_thirteenFourteenButton.layer setCornerRadius:4.];
    [_fourEightButton.layer setCornerRadius:4.];
    [_rewardButton.layer setCornerRadius:4.];
    
    [_oneDoubleEightButton.layer setBorderWidth:1.];
    [_oneDoubleEightButton.layer setBorderColor:XZRGB(0xDF50A9).CGColor];
    
    [_fiveTwoZeroButton.layer setBorderWidth:1.];
    [_fiveTwoZeroButton.layer setBorderColor:XZRGB(0xDF50A9).CGColor];
    
    [_threeNineButton.layer setBorderWidth:1.];
    [_threeNineButton.layer setBorderColor:XZRGB(0xDF50A9).CGColor];
    
    [_thirteenFourteenButton.layer setBorderWidth:1.];
    [_thirteenFourteenButton.layer setBorderColor:XZRGB(0xDF50A9).CGColor];
    
    [_fourEightButton.layer setBorderWidth:1.];
    [_fourEightButton.layer setBorderColor:XZRGB(0xDF50A9).CGColor];
    
    if ([NSString getIsIpad]) {
        _widthConstraint.constant = 75;
    }else{
        if (IS_iPhone_5 || IS_iPhone_4S) {
            _widthConstraint.constant = 75;
        }
    }
    
    lastClickButton = _doubleNineButton;
    //99
    [_doubleNineButton addTarget:self action:@selector(doubleNineCoinsButtonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
    //188金币
    [_oneDoubleEightButton addTarget:self action:@selector(oneDobuleEightButtonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
    //520金币
    [_fiveTwoZeroButton addTarget:self action:@selector(fiveTwityButtonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
    //999金币
    [_threeNineButton addTarget:self action:@selector(threeNineButtonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
    //1314金币
    [_thirteenFourteenButton addTarget:self action:@selector(threeNithirteenFourteenButtonBeClickedneButtonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
    //8888金币
    [_fourEightButton addTarget:self action:@selector(fourEightButtonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
    //确定打赏
    [_rewardButton addTarget:self action:@selector(rewardOkButtonOfCoinsKuang:) forControlEvents:UIControlEventTouchUpInside];
    //关闭
    [_closeButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)hideGifReward:(BOOL)isHide
{
    _giftRewardButton.hidden = isHide;
}

//99
- (void)doubleNineCoinsButtonBeClicked:(UIButton *)sender
{
    [self covertBackColor:sender];
}
//188
- (void)oneDobuleEightButtonBeClicked:(UIButton *)sender
{
    [self covertBackColor:sender];

}

//520
- (void)fiveTwityButtonBeClicked:(UIButton *)sender
{
    [self covertBackColor:sender];

}

//999
- (void)threeNineButtonBeClicked:(UIButton *)sender
{
    [self covertBackColor:sender];

}

//1314
- (void)threeNithirteenFourteenButtonBeClickedneButtonBeClicked:(UIButton *)sender
{
    [self covertBackColor:sender];
}

//8888
- (void)fourEightButtonBeClicked:(UIButton *)sender
{
    [self covertBackColor:sender];
}

- (void)covertBackColor:(UIButton *)sender
{
    if (lastClickButton) {
        [lastClickButton setBackgroundColor:KWHITECOLOR];
        [lastClickButton.layer setBorderWidth:1.];
        [lastClickButton.layer setBorderColor:XZRGB(0xDF50A9).CGColor];
        [lastClickButton setTitleColor:XZRGB(0xDF50A9) forState:UIControlStateNormal];
    }
    
    if (sender) {
        [sender setBackgroundColor:XZRGB(0xDF50A9)];
        [sender.layer setBorderWidth:0];
        [sender setTitleColor:KWHITECOLOR forState:UIControlStateNormal];
        lastClickButton = sender;
    }
}

- (void)covertBack
{
    [self covertBackColor:nil];
}

- (void)textFieldResignFirstResponder
{
    [_otherCoinTextField resignFirstResponder];
}

- (void)rewardCoinBlock:(YLRewardBlock)block
{
    _rewardBlock = block;
}

- (void)closeView:(UIButton *)sender
{
    _rewardBlock(YLBackTypeClose,-1);
}


//确定打赏
- (void)rewardOkButtonOfCoinsKuang:(UIButton *)sender
{
    if (_otherCoinTextField.text.length != 0) {
        if ([_otherCoinTextField.text intValue] < 100) {
            [SVProgressHUD showInfoWithStatus:@"不能少于99金币"];
        }else{
            _rewardBlock(YLBackTypeCoins,[_otherCoinTextField.text intValue]);
        }
    }else{
        NSString *coins = [lastClickButton.currentTitle stringByReplacingOccurrencesOfString:@"金币" withString:@""];
        
        _rewardBlock(YLBackTypeCoins,[coins intValue]);
    }
}
@end
