//
//  UserMatchingLivingActionView.m
//  beijing
//
//  Created by yiliaogao on 2019/2/21.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "UserMatchingLivingActionView.h"

@implementation UserMatchingLivingActionView

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
    
    [self addSubview:self.timeLb];
    
    [self addSubview:self.changeBtn];
    
    [self addSubview:self.switchBtn];
    
    [self addSubview:self.voiceBtn];
    
    [self addSubview:self.msgBtn];
    
    [self addSubview:self.giftBtn];
    
    [self addSubview:self.endBtn];
    
}

- (void)setIsUserMatching:(BOOL)isUserMatching {
    _isUserMatching = isUserMatching;
//    _switchBtn.hidden = !_isUserMatching;
    _tempLb.hidden = !_isUserMatching;
    if (!isUserMatching) {
        [_switchBtn setImage:[UIImage imageNamed:@"anchor_showuser"] forState:0];
        [_switchBtn setImage:[UIImage imageNamed:@"anchor_closeuser"] forState:UIControlStateSelected];
    }
//    if (_switchBtn.hidden) {
//        //主播隐藏关闭视频按钮
//        _voiceBtn.x -= 55;
//        _msgBtn.x   -= 55;
//        _giftBtn.x  -= 55;
//    }
}

- (UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [UIManager initWithButton:CGRectMake(10, 80, 55, 55) text:nil font:8.0f textColor:[UIColor whiteColor] normalImg:@"Living_change" highImg:nil selectedImg:nil];
    }
    return _changeBtn;
}


- (UIButton *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [UIManager initWithButton:CGRectMake(_changeBtn.x+_changeBtn.width, 80, 55, 55) text:nil font:8.0f textColor:[UIColor whiteColor] normalImg:@"Living_switch" highImg:nil selectedImg:@"Living_switch_selected"];
    }
    return _switchBtn;
}

- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [UIManager initWithButton:CGRectMake(_switchBtn.x+_switchBtn.width, 80, 55, 55) text:nil font:8.0f textColor:[UIColor whiteColor] normalImg:@"Living_voice" highImg:nil selectedImg:@"Living_voice_selected"];
    }
    return _voiceBtn;
}

- (UIButton *)msgBtn {
    if (!_msgBtn) {
        _msgBtn = [UIManager initWithButton:CGRectMake(_voiceBtn.x+_voiceBtn.width, 80, 55, 55) text:nil font:8.0f textColor:[UIColor whiteColor] normalImg:@"Living_msg" highImg:nil selectedImg:nil];
    }
    return _msgBtn;
}

- (UIButton *)giftBtn {
    if (!_giftBtn) {
        _giftBtn = [UIManager initWithButton:CGRectMake(_msgBtn.x+_msgBtn.width, 80, 55, 55) text:nil font:8.0f textColor:[UIColor whiteColor] normalImg:@"Living_gift" highImg:nil selectedImg:nil];
    }
    return _giftBtn;
}


- (UIButton *)endBtn {
    if (!_endBtn) {
        _endBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-75, 80, 55, 55) text:nil font:8.0f textColor:[UIColor whiteColor] normalImg:@"Living_end" highImg:nil selectedImg:nil];
    }
    return _endBtn;
}


- (UILabel *)tempLb {
    if (!_tempLb) {
        _tempLb = [UIManager initWithLabel:CGRectMake(15, 40, 80, 20) text:@"关闭摄像头" font:14.0f textColor:[UIColor whiteColor]];
    }
    return _tempLb;
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UIManager initWithLabel:CGRectMake(App_Frame_Width/2 - 50, 10, 100, 20) text:@"00:00:00" font:14.0f textColor:[UIColor whiteColor]];
    }
    return _timeLb;
}


@end
