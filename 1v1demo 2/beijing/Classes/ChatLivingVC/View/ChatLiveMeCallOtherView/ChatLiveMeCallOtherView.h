//
//  ChatLiveMeCallOtherView.h
//  beijing
//
//  Created by yiliaogao on 2019/2/25.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "ChatLivePersonInfoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatLiveMeCallOtherView : BaseView

@property (nonatomic, strong) ChatLivePersonInfoView *chatLivePersonInfoView;

@property (nonatomic, strong) UILabel       *tempLb;

@property (nonatomic, strong) UIButton      *switchBtn;

@property (nonatomic, strong) UIButton      *endBtn;

@property (nonatomic, assign) BOOL           isUser;

@end

NS_ASSUME_NONNULL_END
