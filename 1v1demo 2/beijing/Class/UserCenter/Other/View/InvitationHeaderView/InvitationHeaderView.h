//
//  InvitationHeaderView.h
//  beijing
//
//  Created by yiliaogao on 2019/3/23.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol InvitationHeaderViewDelegate <NSObject>

- (void)didSelectInvitationHeaderViewWithBtn:(UIButton *)btn;

@end

@interface InvitationHeaderView : BaseView

@property (nonatomic, strong) UILabel   *moneyNumberLb;

@property (nonatomic, strong) UILabel   *countNumberLb;

@property (nonatomic, weak) id<InvitationHeaderViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
