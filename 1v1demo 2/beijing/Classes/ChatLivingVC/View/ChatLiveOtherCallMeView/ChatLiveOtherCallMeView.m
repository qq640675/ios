//
//  ChatLiveOtherCallMeView.m
//  beijing
//
//  Created by yiliaogao on 2019/2/25.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "ChatLiveOtherCallMeView.h"
#import "RippleAnimationView.h"

@implementation ChatLiveOtherCallMeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self addSubview:self.coverImageView];
    
    [self addSubview:self.chatLivePersonInfoView];

    RippleAnimationView *viewA = [[RippleAnimationView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) animationType:AnimationTypeWithBackground];
    [_chatLivePersonInfoView.animationImageView addSubview:viewA];
    
//    [self addSubview:self.tempLb];
    
    [self addSubview:self.endBtn];
    UILabel *endLb = [UIManager initWithLabel:CGRectMake(30, APP_Frame_Height-35, 60, 20) text:@"挂断" font:12.0f textColor:[UIColor whiteColor]];
    [self addSubview:endLb];
    
    [self addSubview:self.chatBtn];
    UILabel *chatLb = [UIManager initWithLabel:CGRectMake(App_Frame_Width-90, APP_Frame_Height-35, 60, 20) text:@"接听" font:12.0f textColor:[UIColor whiteColor]];
    [self addSubview:chatLb];
}

- (void)setIsUser:(BOOL)isUser {
    _isUser = isUser;
    _coverImageView.hidden = !isUser;
}

- (void)setPlayerUrl:(NSString *)playerUrl {
    _playerUrl = playerUrl;
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    NSURL *url = [NSURL URLWithString:playerUrl];
    self.player = [PLPlayer playerWithURL:url option:option];
    self.player.delegate = self;
    [self.player setMute:YES];
    [self.player setLoopPlay:YES];
    [self addSubview:self.player.playerView];
    [self insertSubview:self.player.playerView atIndex:0];
    [self.player play];
}

- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    if (state == PLPlayerStatusPlaying) {
        _coverImageView.hidden = YES;
    }
}

- (ChatLivePersonInfoView *)chatLivePersonInfoView {
    if (!_chatLivePersonInfoView) {
        _chatLivePersonInfoView = [[ChatLivePersonInfoView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 230)];
    }
    return _chatLivePersonInfoView;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    }
    return _coverImageView;
}

- (UIButton *)endBtn {
    if (!_endBtn) {
        _endBtn = [UIManager initWithButton:CGRectMake(30, APP_Frame_Height-105, 60, 60) text:nil font:12.0f textColor:[UIColor clearColor] normalImg:@"Matching_end" highImg:nil selectedImg:nil];
    }
    return _endBtn;
}

- (UIButton *)chatBtn {
    if (!_chatBtn) {
        _chatBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-90, APP_Frame_Height-105, 60, 60) text:nil font:12.0f textColor:[UIColor clearColor] normalImg:@"isOn" highImg:nil selectedImg:nil];
    }
    return _chatBtn;
}

//- (UILabel *)tempLb {
//    if (!_tempLb) {
//        _tempLb = [UIManager initWithLabel:CGRectMake(0, APP_Frame_Height-135, App_Frame_Width, 20) text:@"邀请您进行视频通话..." font:12.0f textColor:[UIColor whiteColor]];
//    }
//    return _tempLb;
//}

@end
