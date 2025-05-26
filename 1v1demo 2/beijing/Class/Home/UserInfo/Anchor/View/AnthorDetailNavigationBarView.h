//
//  AnthorDetailNavigationBarView.h
//  beijing
//
//  Created by yiliaogao on 2019/3/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "godnessInfoHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnthorDetailNavigationBarView : BaseView

@property (nonatomic, strong) UIView    *bgView;

@property (nonatomic, strong) UILabel   *nickNameLb;

@property (nonatomic, strong) UIButton  *backBtn;

//@property (nonatomic, strong) godnessInfoHandle *infoHandle;
@property (nonatomic, strong) UIButton  *moreBtn;

@end

NS_ASSUME_NONNULL_END
