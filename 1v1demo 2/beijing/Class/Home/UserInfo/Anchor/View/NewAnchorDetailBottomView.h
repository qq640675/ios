//
//  NewAnchorDetailBottomView.h
//  beijing
//
//  Created by 黎 涛 on 2020/4/14.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewAnchorDetailBottomView : BaseView

@property (nonatomic, copy) void (^bottomViewButtonClick)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
