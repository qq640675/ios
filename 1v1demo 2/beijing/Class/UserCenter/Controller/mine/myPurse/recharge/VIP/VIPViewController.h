//
//  VIPViewController.h
//  beijing
//
//  Created by 黎 涛 on 2021/4/9.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "BaseViewController.h"
#import "vipSetMealHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface VIPViewController : BaseViewController

@property (nonatomic, copy) NSString *vipEndTime;

@end

NS_ASSUME_NONNULL_END

@interface PayListItemButton : UIButton

- (void)setContentWithHandle:(vipSetMealHandle *)handle;

@end
