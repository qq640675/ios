//
//  ShareActionView.h
//  Qiaqia
//
//  Created by yiliaogao on 2019/6/13.
//  Copyright © 2019 yiliaogaoke. All rights reserved.
//

#import "BaseView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>


@interface ShareActionView : BaseView

@property (nonatomic, copy) NSString    *shareTitle;

@property (nonatomic, copy) NSString    *shareContent;

@property (nonatomic, copy) NSString    *shareLink;

@property (nonatomic, assign) BOOL isShareImage;
@property (nonatomic, strong) UILabel *imageLabel;
@property (nonatomic, strong) id         imageObj;

- (void)show;

- (instancetype)initWithFrame:(CGRect)frame shareTitle:(NSString *)shareTitle shareContent:(NSString *)shareContent shareImage:(id)imageObj shareLink:(NSString *)shareLink;

@end

