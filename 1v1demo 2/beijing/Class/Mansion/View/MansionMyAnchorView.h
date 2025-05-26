//
//  MansionMyAnchorView.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/6.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "MansionAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MansionMyAnchorView : BaseView

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) MansionAnchorModel *anchorModel;
@property (nonatomic, copy) void (^deleteButtonClickBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame isAdd:(BOOL)isAdd;

@end

NS_ASSUME_NONNULL_END
