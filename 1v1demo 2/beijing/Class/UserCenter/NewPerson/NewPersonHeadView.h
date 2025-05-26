//
//  NewPersonHeadView.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/19.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "personalCenterHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewPersonHeadView : BaseView

@property (nonatomic, strong) personalCenterHandle *handle;
@property (nonatomic, strong) UIImageView *vipHeadLogo;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *sexBgView;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UILabel *signLabel;
//@property (nonatomic, strong) UIButton *anchorBtn;

//认证状态 0审核中 1已认证 2未认证
@property (nonatomic, assign) int authenticationStatus;


- (void)setHeaderData:(personalCenterHandle *)handle;
//- (void)setAnchorStatus:(int)status;




@end

NS_ASSUME_NONNULL_END
