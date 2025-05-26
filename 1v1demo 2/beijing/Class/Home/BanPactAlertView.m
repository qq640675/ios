//
//  BanPactAlertView.m
//  beijing
//
//  Created by 黎 涛 on 2021/4/1.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "BanPactAlertView.h"
#import "ServiceViewController.h"

@implementation BanPactAlertView


- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        [self setSubViews];
    }
    return self;
}

- (void)showWithImageUrl:(NSString *)imageUrl pactUrl:(NSString *)pactUrl {
    CGFloat maxW = 300;
    CGFloat maxH = 400;
    [self.picIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", imageUrl]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGFloat height = image.size.height*maxW/image.size.width;
        if (height > maxH) {
            height = maxH;
        }
        self.picIV.frame = CGRectMake(0, 0, 300, height);
        CGFloat bgHeight = height+55;
        self.bgView.frame = CGRectMake((App_Frame_Width-300)/2, (APP_Frame_Height-bgHeight)/2, 300, bgHeight);
    }];
    self.pactUrl = pactUrl;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (void)setSubViews {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake((App_Frame_Width-300)/2, (APP_Frame_Height-300-55)/2, 300, 355)];
    self.bgView.backgroundColor = UIColor.whiteColor;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5;
    [self addSubview:self.bgView];
    
    self.picIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    _picIV.backgroundColor = UIColor.clearColor;
    _picIV.contentMode = UIViewContentModeScaleAspectFit;
    [self.bgView addSubview:_picIV];
    
    UIButton *detailBtn = [UIManager initWithButton:CGRectMake(38, self.bgView.height-45, 90, 35) text:@"查看详情" font:18 textColor:XZRGB(0x999999) normalImg:nil highImg:nil selectedImg:nil];
    detailBtn.backgroundColor = XZRGB(0xf2f3f7);
    detailBtn.layer.masksToBounds = YES;
    detailBtn.layer.cornerRadius = detailBtn.height/2;
    [detailBtn addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:detailBtn];
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(38);
            make.bottom.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(90, 35));
    }];
    
    UIButton *okBtn = [UIManager initWithButton:CGRectMake(self.bgView.width-90-38, detailBtn.y, 90, 35) text:@"我知道了" font:18 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    okBtn.backgroundColor = XZRGB(0xAE4FFD);
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.cornerRadius = okBtn.height/2;
    [okBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-38);
            make.bottom.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(90, 35));
    }];
}

- (void)detailButtonClick {
    [self remove];
    [YLPushManager bannerPushClass:self.pactUrl];
//    ServiceViewController *vc = [[ServiceViewController alloc] init];
//    vc.navTitle = @"平台严令禁止条约";
//    vc.urlStr = self.pactUrl;
//    UIViewController *nowVC = [SLHelper getCurrentVC];
//    [nowVC.navigationController pushViewController:vc animated:YES];
}

- (void)remove {
    [self removeFromSuperview];
}




@end
