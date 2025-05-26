//
//  UserMatchingLivingPersonView.h
//  beijing
//
//  Created by yiliaogao on 2019/2/21.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "UserMatchingAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserMatchingLivingPersonView : BaseView

@property (nonatomic, strong) UIImageView   *iconImageView;
@property (nonatomic, strong) UILabel       *nickNameLb;
@property (nonatomic, strong) UILabel       *ageLb;
//@property (nonatomic, strong) UILabel       *occupationLb;
@property (nonatomic, strong) UILabel       *addressLb;
@property (nonatomic, strong) UIButton      *followBtn;

- (void)initWithData:(UserMatchingAnchorModel *)model;

@end

NS_ASSUME_NONNULL_END
