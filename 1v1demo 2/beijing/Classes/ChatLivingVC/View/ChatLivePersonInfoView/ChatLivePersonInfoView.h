//
//  ChatLivePersonInfoView.h
//  beijing
//
//  Created by yiliaogao on 2019/2/26.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "PersonalDataHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatLivePersonInfoView : BaseView

@property (nonatomic, strong) UIImageView   *animationImageView;

@property (nonatomic, strong) UIImageView   *iconImageView;

@property (nonatomic, strong) UILabel       *nickNameLb;
@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, assign) BOOL           isUser;
@property (nonatomic, strong) UIImageView *coverImageView;

- (void)initWithData:(PersonalDataHandle *)handle;

@end

NS_ASSUME_NONNULL_END
