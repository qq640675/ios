//
//  WelcomeViewController.h
//  beijing
//
//  Created by yiliaogao on 2019/2/1.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WelcomeViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UIImageView   *backGroundImageView;

//是否是被封号
@property (nonatomic, assign) BOOL  isProhibition;

@end

NS_ASSUME_NONNULL_END
