//
//  FullScreenNotView.m
//  beijing
//
//  Created by 黎 涛 on 2019/9/19.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "FullScreenNotView.h"
#import "ToolManager.h"
#import "YLPushManager.h"
#import "UserChatLivingViewController.h"
#import "AnchorChatLivingViewController.h"
#import "MansionVideoViewController.h"

@implementation FullScreenNotView

#pragma mark - init
static FullScreenNotView *notView = nil;
static dispatch_once_t onceToken;

+ (instancetype)shareView {
    dispatch_once(&onceToken, ^{
        notView = [[FullScreenNotView alloc] initWithFrame:CGRectMake(App_Frame_Width, SafeAreaTopHeight, App_Frame_Width, 60)];
        notView.backgroundColor = UIColor.clearColor;
        [notView setSubViews];
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:notView];
        [window bringSubviewToFront:notView];
    });
    return notView;
}

+ (void)tearDownView {
    notView = nil;
    onceToken = 0l;
}

#pragma mark - subViews
- (void)setSubViews {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenViewClick)];
    [self addGestureRecognizer:tap];
    
    _params = [NSMutableArray array];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake((App_Frame_Width-290)/2, 10, 290, 40)];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 20;
    [self addSubview:_bgView];
    
    _colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bgView.width, _bgView.height)];
    _colorView.backgroundColor = XZRGB(0xAE4FFD);
    [_bgView addSubview:_colorView];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 34, 34)];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 17;
    [_bgView addSubview:_headImageView];
    
    _titleLabel = [UIManager initWithLabel:CGRectMake(40, 0, 210, 40) text:@"" font:18 textColor:UIColor.whiteColor];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [_bgView addSubview:_titleLabel];
    
    _notImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_bgView.frame)-37, 13, 34, 34)];
    _notImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_notImageView];
}

#pragma mark - show and dismiss
- (void)showWithAnimationWithParam:(NSDictionary *)param {
    if (_params.count == 0) {
        [_params addObject:param];
        [self setDataAndShow];
    } else {
        [_params addObject:param];
    }
}

- (void)setDataAndShow {
    if (_params.count == 0) {
        return;
    }
    NSDictionary *param = _params[0];
    _nowParam = param;
    
    //开通会员时 当用户充值、送礼物、   1  2  3
    NSString *sendType = [NSString stringWithFormat:@"%@", param[@"sendType"]];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", param[@"t_handImg"]]] placeholderImage:[UIImage imageNamed:@"default"]];
    
    if ([sendType isEqualToString:@"1"]) {
        // 会员
        [ToolManager mutableColor:XZRGB(0xae76ff) end:XZRGB(0x8632fe) isH:YES view:_colorView];
        _titleLabel.text = [NSString stringWithFormat:@"%@  |  恭喜成为会员", param[@"t_nickName"]];
        _notImageView.image = [UIImage imageNamed:@"not_vip_pic"];
        _notImageView.frame = CGRectMake(CGRectGetMaxX(_bgView.frame)-37, 13, 34, 34);
    } else if ([sendType isEqualToString:@"2"]) {
        // 充值
        [ToolManager mutableColor:XZRGB(0x47acfa) end:XZRGB(0x008ffe) isH:YES view:_colorView];
        _titleLabel.text = [NSString stringWithFormat:@"%@  |  充值%@金币", param[@"t_nickName"], param[@"recharge"]];
        _notImageView.image = [UIImage imageNamed:@"not_coin_pic"];
        _notImageView.frame = CGRectMake(CGRectGetMaxX(_bgView.frame)-37, 13, 34, 34);
    } else if ([sendType isEqualToString:@"3"]) {
        // 送礼物
        [ToolManager mutableColor:XZRGB(0xf870e0) end:XZRGB(0xe705bf) isH:YES view:_colorView];
        NSString *name = [NSString stringWithFormat:@"%@", param[@"t_nickName"]];
        NSString *title = [NSString stringWithFormat:@"%@  送  %@", name, param[@"t_cover_nickName"]];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:title];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:22] range:NSMakeRange(name.length+2, 1)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColor.yellowColor range:NSMakeRange(name.length+2, 1)];
        _titleLabel.attributedText = attributedStr;
        _notImageView.frame = CGRectMake(CGRectGetMaxX(_bgView.frame)-42, 0, 60, 60);
        [_notImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", param[@"t_gift_still_url"]]]];
    }
    
    
    [self showWithAnimation];
}

- (void)showWithAnimation {
    
    CGFloat showTime = 10;//飘屏停留时间
    
    [UIView animateWithDuration:0.4 animations:^{
        self.x = 0;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(showTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissWithAnimation];
    });
}

- (void)dismissWithAnimation {
    [UIView animateWithDuration:0.4 animations:^{
        self.x = -App_Frame_Width;
    } completion:^(BOOL finished) {
        self.x = App_Frame_Width;
        if (self.params.count > 0) {
            [self.params removeObjectAtIndex:0];
            if (self.params.count > 0) {
                [self setDataAndShow];
            }
        }
    }];
}


- (void)screenViewClick {
    if (_nowParam == nil) {
        return;
    }
//    UIViewController *nowVC = [SLHelper getCurrentVC];
//    if (nowVC) {
//        if ([nowVC isKindOfClass:[UserChatLivingViewController class]] || [nowVC isKindOfClass:[AnchorChatLivingViewController class]] || [nowVC isKindOfClass:[MansionVideoViewController class]]) {
//            return;
//        }
//    }
    int mySex = [YLUserDefault userDefault].t_sex;
    int leftSex = [[NSString stringWithFormat:@"%@", _nowParam[@"t_left_sex"]] intValue];
    if (leftSex != mySex) {
        int leftRole = [[NSString stringWithFormat:@"%@", _nowParam[@"t_left_role"]] intValue];
        int leftId = [[NSString stringWithFormat:@"%@", _nowParam[@"t_left_id"]] intValue];
        if (leftId == 0) {
            return;
        }
        if (leftRole == 1) {
            [YLPushManager pushAnchorDetail:leftId];
        } else {
            [YLPushManager pushFansDetail:leftId];
        }
        self.x = -App_Frame_Width;
        return;
    }
    
    int rightSex = [[NSString stringWithFormat:@"%@", _nowParam[@"t_right_sex"]] intValue];
    if (rightSex != mySex) {
        int rightRole = [[NSString stringWithFormat:@"%@", _nowParam[@"t_right_role"]] intValue];
        int rightId = [[NSString stringWithFormat:@"%@", _nowParam[@"t_right_id"]] intValue];
        if (rightId == 0) {
            return;
        }
        if (rightRole == 1) {
            [YLPushManager pushAnchorDetail:rightId];
        } else {
            [YLPushManager pushFansDetail:rightId];
        }
        self.x = -App_Frame_Width;
    }
    
}



@end
