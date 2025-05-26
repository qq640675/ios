//
//  LoginMenuView.h
//  beijing
//
//  Created by yiliaogao on 2019/3/12.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LoginMenuViewDelegate <NSObject>

- (void)didSelectLoginMenuViewWithBtnTag:(NSInteger)btnTag;

@end

@interface LoginMenuView : BaseView

@property (nonatomic, strong) UIButton *selectedBtn;

@property (nonatomic, strong) UIView   *selectedView;

@property (nonatomic, weak) id<LoginMenuViewDelegate>   delegate;

@end

NS_ASSUME_NONNULL_END
