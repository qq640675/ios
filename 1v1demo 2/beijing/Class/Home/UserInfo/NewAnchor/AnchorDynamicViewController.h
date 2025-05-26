//
//  AnchorDynamicViewController.h
//  beijing
//
//  Created by 黎 涛 on 2021/3/15.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnchorDynamicViewController : BaseViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger anthorId;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

NS_ASSUME_NONNULL_END
