//
//  DynamicDetailTableViewDataSource.m
//  beijing
//
//  Created by yiliaogao on 2019/1/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicDetailTableViewDataSource.h"

@implementation DynamicDetailTableViewDataSource

- (Class)tableView:(UITableView *)tableView cellClassForObject:(SLBaseListModel *)model {
    if ([model isKindOfClass:[DynamicDetailContentModel class]]) {
        return [DynamicDetailContentTableViewCell class];
    }
    
    if ([model isKindOfClass:[DynamicCommentListModel class]]) {
        return [DynamicCommentListTableViewCell class];
    }
    
    return nil;
}

@end
