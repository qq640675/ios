//
//  DetailDynamicView.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/10.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "JXPageListView.h"
#import "DynamicListTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailDynamicView : BaseView<JXPageListViewListDelegate, UITableViewDataSource, UITableViewDelegate, DynamicListTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger anthorId;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

NS_ASSUME_NONNULL_END
