//
//  PulpShadeView.m
//  beijing
//
//  Created by 黎 涛 on 2020/11/26.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "PulpShadeView.h"

@implementation PulpShadeView

- (instancetype)initWithSuperView:(UIView *)superView isSelf:(BOOL)isSelf isBig:(BOOL)isBig {
    self = [super init];
    if (self) {
        self.frame = superView.bounds;
        self.image = [UIImage imageNamed:@"shadeView"];
        self.isSelf = isSelf;
        self.isBig = isBig;
        [self setSubViews];
        [superView addSubview:self];
    }
    return self;
}

- (instancetype)initWithSuperView:(UIView *)superView isSelf:(BOOL)isSelf {
    self = [super init];
    if (self) {
        self.frame = superView.bounds;
        self.image = [UIImage imageNamed:@"shadeView"];
        self.isSelf = isSelf;
        self.isBig = NO;
        [self setMansionSubViews];
        [superView addSubview:self];
    }
    return self;
}

- (void)setSubViews {
    self.pulpEmoji = [[UIImageView alloc] initWithFrame:CGRectMake((App_Frame_Width-120)/2, (APP_Frame_Height-120)/2, 120, 120)];
    self.pulpEmoji.image = [UIImage imageNamed:@"pulpEmoji"];
    [self addSubview:self.pulpEmoji];
    
    self.pulpTipLabel = [UIManager initWithLabel:CGRectMake(15, CGRectGetMaxY(self.pulpEmoji.frame)+10, App_Frame_Width-30, 50) text:@"" font:15 textColor:UIColor.whiteColor];
    self.pulpTipLabel.numberOfLines = 0;
    [self addSubview:self.pulpTipLabel];
    [self setTipText];
    
    if (!_isBig) {
        //90 172
        self.pulpEmoji.frame = CGRectMake(15, 20, 60, 60);
        self.pulpTipLabel.frame = CGRectMake(0, 85, 90, 70);
        self.pulpTipLabel.font = [UIFont systemFontOfSize:10];
    }
    
    self.pulpCount = 15;
}

- (void)setMansionSubViews {
    self.pulpTipLabel = [UIManager initWithLabel:CGRectMake(15, 15, self.width-30, self.height-30) text:@"" font:15 textColor:UIColor.whiteColor];
    self.pulpTipLabel.numberOfLines = 0;
    self.pulpTipLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.pulpTipLabel];
    [self setTipText];

    self.pulpCount = 15;
}

- (void)changeSuperView:(UIView *)superV isBig:(BOOL)isBig {
    [self removeFromSuperview];
    if (!self) return;
    
    self.frame = superV.bounds;
    [superV addSubview:self];
    if (!isBig) {
        //90 172
        self.pulpEmoji.frame = CGRectMake(15, 20, 60, 60);
        self.pulpTipLabel.frame = CGRectMake(0, 85, 90, 70);
        self.pulpTipLabel.font = [UIFont systemFontOfSize:10];
    } else {
        self.pulpEmoji.frame = CGRectMake((App_Frame_Width-120)/2, (APP_Frame_Height-120)/2, 120, 120);
        self.pulpTipLabel.frame = CGRectMake(15, CGRectGetMaxY(self.pulpEmoji.frame)+10, App_Frame_Width-30, 50);
        self.pulpTipLabel.font = [UIFont systemFontOfSize:15];
    }
}

- (void)pulpViewCountDown {
    if (!self) return;
        
    self.pulpCount --;
    if (self.pulpCount > 0) {
        [self setTipText];
    } else {
        [self removeFromSuperview];
    }
}

- (void)setTipText {
    if (self.isSelf) {
        self.pulpTipLabel.text = [NSString stringWithFormat:@"你可能存在不文明行为，系统已将你的视频关闭，请规范自己的行为。%ld秒后视频将重新打开。", self.pulpCount];
    } else {
        self.pulpTipLabel.text = [NSString stringWithFormat:@"对方可能存在不文明行为，系统已自动为您屏蔽。%ld秒之后视频将会重新打开。", self.pulpCount];
    }
}


@end
