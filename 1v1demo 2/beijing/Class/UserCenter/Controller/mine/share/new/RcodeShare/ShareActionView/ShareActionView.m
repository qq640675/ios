//
//  ShareActionView.m
//  Qiaqia
//
//  Created by yiliaogao on 2019/6/13.
//  Copyright © 2019 yiliaogaoke. All rights reserved.
//

#import "ShareActionView.h"
#import "PopPicViewController.h"


@implementation ShareActionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame shareTitle:(NSString *)shareTitle shareContent:(NSString *)shareContent shareImage:(id)imageObj shareLink:(NSString *)shareLink  {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        _shareTitle     = shareTitle;
        _shareContent   = shareContent;
        _shareLink      = shareLink;
        _imageObj       = imageObj;
    }
    return self;
}


- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (void)setupUI {
    
    CGFloat height = 230+(SafeAreaBottomHeight-49);
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height-height, App_Frame_Width, height)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, whiteView.y)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedBgView)];
    [bgView addGestureRecognizer:tap];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
    [self addSubview:bgView];
    
    UILabel *lb = [UIManager initWithLabel:CGRectZero text:@"分享到" font:15.0f textColor:XZRGB(0x868686)];
    [whiteView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView.mas_centerX);
        make.top.equalTo(whiteView).offset(15);
    }];

    NSArray *titleArray = @[@"微信好友",@"朋友圈",@"QQ", @"QQ空间", @"分享图片",@"复制链接"];
    NSArray *imageArray = @[@"PersonCenter_share_wx_friend",@"PersonCenter_share_wx_circle",@"PersonCenter_share_qq", @"PersonCenter_share_qqzone",@"PersonCenter_share_save",@"PersonCenter_share_copy"];
    CGFloat width = App_Frame_Width/4;
    CGFloat btnHeight = 90;
    CGFloat y = 50;
    for (int i = 0; i < [titleArray count]; i++) {
        CGFloat x = i*width;
        if (i > 3) {
            y = 140;
            x = (i-4)*width;
        }
        
        UIButton *btn = [UIManager initWithButton:CGRectMake(x, y, width, btnHeight) text:nil font:15.0f textColor:[UIColor blackColor] normalImg:imageArray[i] highImg:nil selectedImg:nil];
        btn.tag = i;
        btn.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
        [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:btn];
        
        
        UILabel *titleLb = [UIManager initWithLabel:CGRectZero text:titleArray[i] font:14.0f textColor:XZRGB(0x333333)];
        [whiteView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_bottom).offset(-30);
            make.centerX.equalTo(btn.mas_centerX);
        }];
        
        if (i == 4) {
            _imageLabel = titleLb;
        }
        
    }
    
}

- (void)clickedBtn:(UIButton *)btn {
    
    if (btn.tag == 0) {
        //微信好友
        [self shareImageAndTextToPlatformType:SSDKPlatformSubTypeWechatSession];
    } else if (btn.tag == 1) {
        //微信朋友圈
        [self shareImageAndTextToPlatformType:SSDKPlatformSubTypeWechatTimeline];
    } else if (btn.tag == 2) {
        //QQ
        [self shareImageAndTextToPlatformType:SSDKPlatformSubTypeQQFriend];
    } else if (btn.tag == 3) {
        //QQ空间
        [self shareImageAndTextToPlatformType:SSDKPlatformSubTypeQZone];
    } else if (btn.tag == 4) {
        if (_isShareImage) {
            //保存图片
            [self saveRCodeToPhone];
        } else {
            UIViewController *nowVC = [SLHelper getCurrentVC];
            PopPicViewController *vc = [[PopPicViewController alloc] init];
            [nowVC.navigationController pushViewController:vc animated:YES];
            
        }
    } else if (btn.tag == 5) {
        // 复制链接
        if (_shareLink.length > 0) {
            UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
            pasteBoard.string = _shareLink;
            [SVProgressHUD showSuccessWithStatus:@"复制成功"];
        } else {
            [SVProgressHUD showInfoWithStatus:@"链接为空"];
        }
    }
    
    [self clickedBgView];
}

- (void)clickedBgView {
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setIsShareImage:(BOOL)isShareImage {
    _isShareImage = isShareImage;
    if (isShareImage) {
        _imageLabel.text = @"保存图片";
    }
}

- (void)shareImageAndTextToPlatformType:(SSDKPlatformType)platformType {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    SSDKContentType type = SSDKContentTypeAuto;
    if (_isShareImage == YES) {
        type = SSDKContentTypeImage;
    }
    [shareParams SSDKSetupShareParamsByText:_shareContent
                                     images:_imageObj
                                        url:[NSURL URLWithString:_shareLink]
                                      title:_shareTitle
                                       type:type];
    
    [ShareSDK share:platformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == SSDKResponseStateSuccess) {

        } else if (state == SSDKResponseStateFail) {

        }
    }];
}

#pragma mark ---- 保存二维码到手机
- (void)saveRCodeToPhone {

    UIImageWriteToSavedPhotosAlbum(_imageObj, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        // 保存失败
        [SVProgressHUD showInfoWithStatus:@"图片保存失败，请查看相册权限是否开启"];
    } else {
        // 保存成功
        [SVProgressHUD showInfoWithStatus:@"图片保存成功"];
    }
}

@end
