//
//  VideoWarningAlertView.m
//  beijing
//
//  Created by 黎 涛 on 2020/3/5.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "VideoWarningAlertView.h"

@implementation VideoWarningAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(40, (APP_Frame_Height-180)/2-30, App_Frame_Width-80, 180)];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 10;
    [self addSubview:bgView];
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((bgView.width-40)/2, 8, 40, 40)];
    logo.image = [UIImage imageNamed:@"video_warning"];
    [bgView addSubview:logo];
    
    self.contentLabel = [UIManager initWithLabel:CGRectMake(20, 50, bgView.width-40, bgView.height-100) text:@"" font:15 textColor:XZRGB(0x333333)];
    self.contentLabel.numberOfLines = 0;
    [bgView addSubview:self.contentLabel];
    
    UIButton *sureBtn = [UIManager initWithButton:CGRectMake((bgView.width-80)/2, bgView.height-45, 80, 35) text:@"知道了" font:15 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    sureBtn.backgroundColor = XZRGB(0xAE4FFD);
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = sureBtn.height/2;
    [sureBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sureBtn];
}

- (void)showWithContent:(NSString *)content {
    self.contentLabel.text = content;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (void)remove {
    [self removeFromSuperview];
}

@end
