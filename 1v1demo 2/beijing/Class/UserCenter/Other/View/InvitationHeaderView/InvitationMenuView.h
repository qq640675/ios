//
//  InvitationMenuView.h
//  beijing
//
//  Created by yiliaogao on 2019/3/23.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol InvitationMenuViewDelegate <NSObject>

- (void)didSelectInvitationMenuViewWithBtn:(UIButton *)btn;

@end

@interface InvitationMenuView : BaseView

@property (nonatomic, strong) UIButton  *selectedBtn;

@property (nonatomic, strong) UIButton  *selectedSonBtn;

@property (nonatomic, strong) UIView    *selectedView;

@property (nonatomic, strong) UIView    *sonBtnBgView;

@property (nonatomic, weak) id<InvitationMenuViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
