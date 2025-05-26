//
//  EditInfoViewController.h
//  beijing
//
//  Created by yiliaogao on 2019/5/6.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditInfoViewController : BaseViewController

@property (nonatomic, strong) NSString  *strTitle;

@property (nonatomic, strong) NSString  *strContent;

@property (nonatomic, copy) void (^editFinishBlock)(NSString *editText);

@end

NS_ASSUME_NONNULL_END
