//
//  DynamicListTableViewDataSource.m
//  beijing
//
//  Created by yiliaogao on 2019/1/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicListTableViewDataSource.h"

@implementation DynamicListTableViewDataSource

- (Class)tableView:(UITableView *)tableView cellClassForObject:(SLBaseListModel *)model {
    if ([model isKindOfClass:[DynamicListModel class]]) {
        return [DynamicListTableViewCell class];
    }
    
    if ([model isKindOfClass:[DynamicCommentListModel class]]) {
        return [DynamicCommentListTableViewCell class];
    }

    return nil;
}

@end
