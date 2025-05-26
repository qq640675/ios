//
//  AnchorMatchingLivingPersonView.h
//  beijing
//
//  Created by yiliaogao on 2019/2/21.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "PersonalDataHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnchorMatchingLivingPersonView : BaseView

@property (nonatomic, strong) UIImageView   *iconImageView;
@property (nonatomic, strong) UILabel       *nickNameLb;
@property (nonatomic, strong) UIButton      *followBtn;
@property (nonatomic, strong) UILabel       *addressLb;
//@property (nonatomic, strong) UILabel       *levelLb;
@property (nonatomic, strong) UILabel       *goldLb;

- (void)initWithData:(PersonalDataHandle *)handle;

@end

NS_ASSUME_NONNULL_END
