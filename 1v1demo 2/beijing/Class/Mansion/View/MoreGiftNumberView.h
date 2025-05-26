//
//  MoreGiftNumberView.h
//  beijing
//
//  Created by 黎 涛 on 2021/4/15.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MoreGiftNumberView : BaseView
@property (nonatomic, copy) void (^ sureButtonClickBlock)(int number);


- (void)show;


@end

NS_ASSUME_NONNULL_END
