//
//  LaunchAdvImageView.m
//  beijing
//
//  Created by 黎 涛 on 2019/8/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "LaunchAdvImageView.h"
#import "BaseView.h"

@implementation LaunchAdvImageView
{
    UIButton *jumpBtn; //跳过
    
    dispatch_source_t timer;
}

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        self.backgroundColor = UIColor.clearColor;
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

#pragma mark - setImage adv
- (void)setImageUrl:(NSString *)imageUrl {
    [self sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    self.userInteractionEnabled = YES;
    
    jumpBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-95, APP_Frame_Height-SafeAreaBottomHeight-30, 80, 30) text:@"跳过 5s" font:15 textColor:UIColor.blackColor normalImg:nil highImg:nil selectedImg:nil];
    jumpBtn.backgroundColor = XZRGB(0xebebeb);
    jumpBtn.layer.masksToBounds = YES;
    jumpBtn.layer.cornerRadius = 15;
    [jumpBtn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:jumpBtn];
    
    [self setTimer];
}

- (void)setAdvUrl:(NSString *)advUrl {
    _advUrl = advUrl;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adv)];
    [self addGestureRecognizer:tap];
}

#pragma mark - func
- (void)jump {
    if (self.jumpButtonClick) {
        self.jumpButtonClick();
    }
    dispatch_source_cancel(timer);
    [self removeFromSuperview];
}

- (void)adv {
    if (self.advImageClick) {
        self.advImageClick(_advUrl);
    }
    dispatch_source_cancel(timer);
    [self removeFromSuperview];
}

#pragma mark - timer
- (void)setTimer {
    __block int time = 6;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (time <= 1) {
            dispatch_source_cancel(self->timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self jump];
            });
        } else {
            time --;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->jumpBtn setTitle:[NSString stringWithFormat:@"跳过 %ds", time] forState:0];
            });
        }
    });
    dispatch_resume(timer);
}

@end
