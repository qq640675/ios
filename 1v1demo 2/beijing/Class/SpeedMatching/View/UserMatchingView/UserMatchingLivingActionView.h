//
//  UserMatchingLivingActionView.h
//  beijing
//
//  Created by yiliaogao on 2019/2/21.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserMatchingLivingActionView : BaseView

@property (nonatomic, strong) UIButton      *switchBtn;
@property (nonatomic, strong) UIButton      *changeBtn;
@property (nonatomic, strong) UIButton      *endBtn;
@property (nonatomic, strong) UIButton      *giftBtn;
@property (nonatomic, strong) UIButton      *msgBtn;
@property (nonatomic, strong) UIButton      *voiceBtn;

@property (nonatomic, strong) UILabel       *timeLb;
@property (nonatomic, strong) UILabel       *tempLb;

//是否是用户接通界面
@property (nonatomic, assign) BOOL      isUserMatching;

@end

NS_ASSUME_NONNULL_END
