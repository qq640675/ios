//
//  NewPeopleViewController.h
//  beijing
//
//  Created by yiliaogao on 2019/3/6.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewPeopleViewController : BaseViewController

@property (nonatomic, assign) NSInteger type; //3女神
@property (nonatomic, copy) NSString *selectedCity;

- (void)refreshListWithCity:(NSString *)city;

@end

NS_ASSUME_NONNULL_END
