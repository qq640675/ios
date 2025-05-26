//
//  TextAlertView.m
//  beijing
//
//  Created by 黎 涛 on 2020/12/21.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "TextAlertView.h"

@implementation TextAlertView
{
    UIView *bgView;
    UIScrollView *contentScr;
    UILabel *contentLabel;
    CGFloat topHeight;
}


- (instancetype)initWithTitle:(nullable NSString *)title {
    self = [super init];
    if (self) {
        self.titleString = title;
        self.isShowCancle = NO;
        [self show];
    }
    return self;
}

- (instancetype)initOnlySureWithTitle:(nullable NSString *)title
                           sureHandle:(void(^)(void))sure {
    self = [super init];
    if (self) {
        self.titleString = title;
        self.sureHandle = sure;
        self.isShowCancle = NO;
        [self show];
    }
    return self;
}

- (instancetype)initWithTitle:(nullable NSString *)title
                   sureHandle:(nullable void(^)(void))sure {
    self = [super init];
    if (self) {
        self.titleString = title;
        self.sureHandle = sure;
        self.isShowCancle = YES;
        [self show];
    }
    return self;
}

- (instancetype)initWithTitle:(nullable NSString *)title
                  cancleTitle:(nullable NSString *)cancleTitle
                    sureTitle:(nullable NSString *)sureTitle
                   sureHandle:(nullable void(^)(void))sure {
    self = [super init];
    if (self) {
        self.titleString = title;
        self.cancleTitle = cancleTitle;
        self.sureTitle = sureTitle;
        self.sureHandle = sure;
        self.isShowCancle = YES;
        [self show];
    }
    return self;
}

- (instancetype)initWithTitle:(nullable NSString *)title
                  cancleTitle:(nullable NSString *)cancleTitle
                    sureTitle:(nullable NSString *)sureTitle
                   sureHandle:(nullable void(^)(void))sure
                 cancleHandle:(nullable void(^)(void))cancle {
    self = [super init];
    if (self) {
        self.titleString = title;
        self.cancleTitle = cancleTitle;
        self.sureTitle = sureTitle;
        self.sureHandle = sure;
        self.cancleHandle = cancle;
        self.isShowCancle = YES;
        [self show];
    }
    return self;
}

#pragma mark - set data
- (void)setContentWithString:(NSString *)str {
    contentLabel.text = str;
    [self reSetSize];
}

- (void)setContentWithAttibutedString:(NSAttributedString *)attri {
    contentLabel.attributedText = attri;
    [self reSetSize];
}

- (void)reSetSize {
    [contentLabel sizeToFit];
    CGFloat height = contentLabel.height;
    if (height > 400) {
        height = 400;
    }
    if (height < 100) {
        height = 100;
    }
    contentScr.height = height;
    contentScr.contentSize = CGSizeMake(contentScr.width, contentLabel.height);
    bgView.height = contentScr.height+topHeight+55;
    bgView.y = (APP_Frame_Height-bgView.height)/2;
    if (contentLabel.height < 100) {
        contentLabel.frame = CGRectMake(((bgView.width-30)-contentLabel.width)/2, (contentScr.height-contentLabel.height)/2, contentLabel.width, contentLabel.height);
    }
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    contentLabel.textAlignment = textAlignment;
}

#pragma mark - func
- (void)cancleButtonClick {
    [self removeFromSuperview];
    if (self.cancleHandle) {
        self.cancleHandle();
    }
}

- (void)sureButtonClick {
    [self removeFromSuperview];
    if (self.sureHandle) {
        self.sureHandle();
    }
}

#pragma makr - subViews
- (void)show {
    self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
    self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];
    
    [self setSubViews];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (void)setSubViews {
    topHeight = 10;
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(45, (APP_Frame_Height-300)/2, App_Frame_Width-90, 300)];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 12;
    [self addSubview:bgView];
    
    if (self.titleString.length > 0) {
        topHeight = 55;
        UILabel *titleL = [UIManager initWithLabel:CGRectMake(0, 0, bgView.width, 45) text:self.titleString font:17 textColor:XZRGB(0x333333)];
        [bgView addSubview:titleL];
    }
    
    contentScr = [[UIScrollView alloc] initWithFrame:CGRectMake(15, topHeight, bgView.width-30, bgView.height-110)];
    contentScr.contentSize = CGSizeMake(contentScr.width, contentScr.height);
    [bgView addSubview:contentScr];
    
    contentLabel = [UIManager initWithLabel:CGRectMake(0, 0, bgView.width-30, bgView.height-110) text:@"" font:16 textColor:XZRGB(0x333333)];
    contentLabel.numberOfLines = 0;
    [contentScr addSubview:contentLabel];
    
    UIButton *sureBtn = [UIManager initWithButton:CGRectZero text:@"确定" font:17 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
    if (self.sureTitle.length > 0) {
        [sureBtn setTitle:self.sureTitle forState:0];
    }
    [sureBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(bgView.width);
    }];
    
    if (self.isShowCancle) {
        UIButton *cancleBtn = [UIManager initWithButton:CGRectZero text:@"取消" font:17 textColor:XZRGB(0x666666) normalImg:nil highImg:nil selectedImg:nil];
        if (self.cancleTitle.length > 0) {
            [cancleBtn setTitle:self.cancleTitle forState:0];
        }
        [cancleBtn addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancleBtn];
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(bgView.width/2);
            make.height.mas_equalTo(45);
        }];
        
        UIView *vLine = [[UIView alloc] init];
        vLine.backgroundColor = XZRGB(0xebebeb);
        [bgView addSubview:vLine];
        [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                    make.centerX.mas_equalTo(self->bgView.mas_centerX);
                    make.width.mas_equalTo(1);
                    make.height.mas_equalTo(45);
        }];
        
        [sureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(bgView.width/2);
        }];
    }
    
    UIView *hLine = [[UIView alloc] init];
    hLine.backgroundColor = XZRGB(0xebebeb);
    [bgView addSubview:hLine];
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-45);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
    }];
}


@end
