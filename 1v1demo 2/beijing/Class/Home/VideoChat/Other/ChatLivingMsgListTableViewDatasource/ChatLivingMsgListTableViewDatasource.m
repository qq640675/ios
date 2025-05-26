//
//  ChatLivingMsgListTableViewDatasource.m
//  beijing
//
//  Created by yiliaogao on 2019/2/28.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "ChatLivingMsgListTableViewDatasource.h"

@implementation ChatLivingMsgListTableViewDatasource

- (Class)tableView:(UITableView *)tableView cellClassForObject:(SLBaseListModel *)model {
    if ([model isKindOfClass:[ChatLivingMsgListModel class]]) {
        return [ChatLivingMsgListTableViewCell class];
    }
    if ([model isKindOfClass:[BigLivingMsgListModel class]]) {
        return [BigLivingMsgListTableViewCell class];
    }
    return nil;
}

@end
