//
//  DynamicDetailHeaderView.h
//  beijing
//
//  Created by yiliaogao on 2019/1/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "DynamicListModel.h"
#import "DynamicDetailPicView.h"

@protocol DynamicDetailHeaderViewDelegate <NSObject>

- (void)didSelectDynamicDetailHeaderViewWithBtn:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DynamicDetailHeaderView : BaseView

@property (nonatomic, strong) UIButton  *loveBtn;
@property (nonatomic, strong) UIButton  *commentBtn;

@property (nonatomic, strong) DynamicListModel  *listModel;

@property (nonatomic, strong) DynamicDetailPicView *picView;

@property (nonatomic, weak) id<DynamicDetailHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
