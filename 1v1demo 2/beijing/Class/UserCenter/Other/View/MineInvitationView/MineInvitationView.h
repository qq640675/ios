//
//  MineInvitationView.h
//  beijing
//
//  Created by yiliaogao on 2019/1/14.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"

@protocol MineInvitationViewDelete <NSObject>

- (void)didSelectMineInvitationViewWithBgView;

- (void)didSelectMineInvitationViewWithSureBtn:(NSInteger)idCard;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MineInvitationView : BaseView

@property (nonatomic, strong) UILabel *codeLb;

@property (nonatomic, strong) UITextField   *textField;

@property (nonatomic, weak) id<MineInvitationViewDelete>  delegate;

@end

NS_ASSUME_NONNULL_END
