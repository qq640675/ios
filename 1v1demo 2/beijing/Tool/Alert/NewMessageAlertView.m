//
//  NewMessageAlertView.m
//  beijing
//
//  Created by 黎 涛 on 2019/10/16.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "NewMessageAlertView.h"

@implementation NewMessageAlertView

static NewMessageAlertView *alertView = nil;
static dispatch_once_t onceToken;
+ (instancetype)shareView {
    dispatch_once(&onceToken, ^{
        alertView = [[NewMessageAlertView alloc] initWithFrame:CGRectMake(-250, APP_Frame_Height-SafeAreaBottomHeight-80, 250, 75)];
        alertView.backgroundColor = KDEFAULTCOLOR;
        alertView.layer.masksToBounds = YES;
        alertView.layer.cornerRadius = 4;
        alertView.layer.borderWidth = 1;
        alertView.layer.borderColor = UIColor.whiteColor.CGColor;
        [alertView setSubViews];
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:alertView];
    });
    return alertView;
}

+ (void)tearDownView {
    alertView = nil;
    onceToken = 0l;
}

- (void)setSubViews {
    _params = [NSMutableArray array];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 25, 25)];
    _headImageView.backgroundColor = UIColor.whiteColor;
    _headImageView.image = [UIImage imageNamed:@"default"];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 12.5;
    [self addSubview:_headImageView];
    
    _nameLabel = [UIManager initWithLabel:CGRectMake(45, 5, 160, 25) text:@"昵称" font:16 textColor:UIColor.whiteColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:17];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_nameLabel];
    
    _contentLabel = [UIManager initWithLabel:CGRectMake(10, 30, self.width-20, 25) text:@"" font:14 textColor:UIColor.whiteColor];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_contentLabel];
    
    UIButton *closeBtn = [UIManager initWithButton:CGRectMake(self.width-30, 0, 30, 30) text:@"" font:1 textColor:nil normalImg:@"news_Popupwindowclosed" highImg:nil selectedImg:nil];
    [closeBtn addTarget:self action:@selector(closeAlert) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    UIButton *detailBtn = [UIManager initWithButton:CGRectMake(self.width-55, self.height-21, 45, 16) text:@"立即回复" font:10 textColor:KDEFAULTCOLOR normalImg:nil highImg:nil selectedImg:nil];
    detailBtn.layer.masksToBounds = YES;
    detailBtn.layer.cornerRadius = 4;
    detailBtn.backgroundColor = UIColor.whiteColor;
    [detailBtn addTarget:self action:@selector(checkMessage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkMessage)];
    [self addGestureRecognizer:tap];
}

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
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:param[@"avater"]] placeholderImage:[UIImage imageNamed:@"default"]];
    _nameLabel.text = param[@"userName"];
    _contentLabel.text = param[@"text"];
    
    [self showWithAnimation];
}

- (void)showWithAnimation {
    [UIView animateWithDuration:0.4 animations:^{
        self.x = 15;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissWithAnimation];
    });
}

- (void)dismissWithAnimation {
    if (self.x == -250) {
        return;
    }
    [UIView animateWithDuration:0.4 animations:^{
        self.x = -250;
    } completion:^(BOOL finished) {
        if (self.params.count > 0) {
            [self.params removeObjectAtIndex:0];
            if (self.params.count > 0) {
                [self setDataAndShow];
            }
        }
    }];
}

- (void)stopAnimation {
    self.x = -250;
    [self.params removeAllObjects];
}

#pragma mark - func
- (void)closeAlert {
    self.x = -250;
    if (self.params.count > 0) {
        [self.params removeObjectAtIndex:0];
        if (self.params.count > 0) {
            [self setDataAndShow];
        }
    }
}

- (void)checkMessage {
    [self closeAlert];
    NSInteger userId = [_nowParam[@"userId"] integerValue];
    [YLPushManager pushChatViewController:userId-10000 otherSex:-1];
}


@end
