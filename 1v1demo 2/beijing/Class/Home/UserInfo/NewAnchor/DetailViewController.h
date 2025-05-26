//
//  DetailViewController.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/4.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseViewController.h"
#import "JXPageListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : BaseViewController

@property (nonatomic, assign) NSInteger    anthorId;
@property (nonatomic, strong) UITableView *detailTableView;


@end

NS_ASSUME_NONNULL_END
