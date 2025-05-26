//
//  DynamicReleaseTableViewDataSource.m
//  beijing
//
//  Created by yiliaogao on 2018/12/26.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "DynamicReleaseTableViewDataSource.h"

@implementation DynamicReleaseTableViewDataSource

- (Class)tableView:(UITableView *)tableView cellClassForObject:(SLBaseListModel *)model {
    if ([model isKindOfClass:[DynamicReleaseTextModel class]]) {
        return [DynamicReleaseTextTableViewCell class];
    }
    
    if ([model isKindOfClass:[DynamicReleasePicModel class]]) {
        return [DynamicReleasePicTableViewCell class];
    }
    
    if ([model isKindOfClass:[DynamicReleaseListModel class]]) {
        return [DynamicReleaseListTableViewCell class];
    }
    return nil;
}

@end
