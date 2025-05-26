//
//  DynamicDetailViewController.h
//  beijing
//
//  Created by yiliaogao on 2019/1/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseTableViewController.h"
#import "DynamicListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicDetailViewController : SLBaseTableViewController

@property (nonatomic, strong) DynamicListModel  *listModel;

@end

NS_ASSUME_NONNULL_END
