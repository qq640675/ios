//
//  DynamicAddressTableViewDataSource.m
//  beijing
//
//  Created by yiliaogao on 2019/1/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicAddressTableViewDataSource.h"

@implementation DynamicAddressTableViewDataSource

- (Class)tableView:(UITableView *)tableView cellClassForObject:(SLBaseListModel *)model {
    if ([model isKindOfClass:[DynamicAddressListModel class]]) {
        return [DynamicAddressListTableViewCell class];
    }
    if ([model isKindOfClass:[DynamicMsgListModel class]]) {
        return [DynamicMsgListTableViewCell class];
    }
    return nil;
}

@end
