//
//  ChatLiveMeCallOtherView.m
//  beijing
//
//  Created by yiliaogao on 2019/2/25.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "ChatLiveMeCallOtherView.h"

@implementation ChatLiveMeCallOtherView

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
    
    [self addSubview:self.chatLivePersonInfoView];
    
    [self addSubview:self.tempLb];
    [self addSubview:self.switchBtn];
    
//    UILabel *lb = [UIManager initWithLabel:CGRectMake(0, APP_Frame_Height-135, App_Frame_Width, 20) text:@"您正在发起视频..." font:12.0f textColor:[UIColor whiteColor]];
//    [self addSubview:lb];
    
    [self addSubview:self.endBtn];
    UILabel *endLb = [UIManager initWithLabel:CGRectMake(0, APP_Frame_Height-35, App_Frame_Width, 20) text:@"挂断" font:12.0f textColor:[UIColor whiteColor]];
    [self addSubview:endLb];
    
}

- (void)setIsUser:(BOOL)isUser {
    _isUser = isUser;
    _switchBtn.hidden = !_isUser;
    _tempLb.hidden    = !_isUser;
    self.chatLivePersonInfoView.isUser = isUser;
}

- (ChatLivePersonInfoView *)chatLivePersonInfoView {
    if (!_chatLivePersonInfoView) {
        _chatLivePersonInfoView = [[ChatLivePersonInfoView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 230)];
        _chatLivePersonInfoView.tipLabel.text = @"你正在发起视频聊天";
    }
    return _chatLivePersonInfoView;
}

- (UIButton *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [UIManager initWithButton:CGRectMake(10, SafeAreaTopHeight-44, 60, 60) text:nil font:12.0f textColor:[UIColor clearColor] normalImg:@"live_on" highImg:nil selectedImg:@"live_off"];
    }
    return _switchBtn;
}

- (UIButton *)endBtn {
    if (!_endBtn) {
        _endBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width/2 - 30, APP_Frame_Height-105, 60, 60) text:nil font:12.0f textColor:[UIColor clearColor] normalImg:@"Matching_end" highImg:nil selectedImg:nil];
    }
    return _endBtn;
}

- (UILabel *)tempLb {
    if (!_tempLb) {
        _tempLb = [UIManager initWithLabel:CGRectMake(0, SafeAreaTopHeight-44+50, 80, 20) text:@"关闭摄像头" font:14.0f textColor:[UIColor whiteColor]];
    }
    return _tempLb;
}



@end
