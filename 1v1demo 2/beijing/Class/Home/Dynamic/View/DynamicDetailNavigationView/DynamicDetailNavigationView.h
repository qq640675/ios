//
//  DynamicDetailNavigationView.h
//  beijing
//
//  Created by yiliaogao on 2019/1/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "DynamicListModel.h"

@protocol DynamicDetailNavigationViewDelegate <NSObject>

- (void)didSelectDynamicDetailNavigationViewWithBtn:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DynamicDetailNavigationView : BaseView

@property (nonatomic, strong) UIImageView   *iconImageView;
@property (nonatomic, strong) UIImageView   *sexImageView;

@property (nonatomic, strong) UILabel       *nickNameLb;
@property (nonatomic, strong) UILabel       *ageLb;
@property (nonatomic, strong) UILabel       *timeLb;

@property (nonatomic, strong) UIButton      *chatBtn;

@property (nonatomic, strong) DynamicListModel  *dynamicListModel;

@property (nonatomic, weak) id<DynamicDetailNavigationViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
