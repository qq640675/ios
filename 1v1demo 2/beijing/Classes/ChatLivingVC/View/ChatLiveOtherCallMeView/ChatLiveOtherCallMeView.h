//
//  ChatLiveOtherCallMeView.h
//  beijing
//
//  Created by yiliaogao on 2019/2/25.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "ChatLivePersonInfoView.h"
#import <PLPlayerKit/PLPlayerKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatLiveOtherCallMeView : BaseView
<
PLPlayerDelegate
>

@property (nonatomic, strong) PLPlayer  *player;

@property (nonatomic, strong) ChatLivePersonInfoView *chatLivePersonInfoView;

@property (nonatomic, strong) UIImageView   *coverImageView;

@property (nonatomic, strong) UILabel       *tempLb;

@property (nonatomic, strong) UIButton      *endBtn;

@property (nonatomic, strong) UIButton      *chatBtn;

@property (nonatomic, copy) NSString        *playerUrl;

@property (nonatomic, assign) BOOL           isUser;

@end

NS_ASSUME_NONNULL_END
