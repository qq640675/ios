//
//  PersonCenterTableViewDatasource.m
//  beijing
//
//  Created by yiliaogao on 2019/3/1.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "PersonCenterTableViewDatasource.h"

@implementation PersonCenterTableViewDatasource

- (Class)tableView:(UITableView *)tableView cellClassForObject:(SLBaseListModel *)model {
    if ([model isKindOfClass:[PersonCenterListModel class]]) {
        return [PersonCenterListTableViewCell class];
    }
    if ([model isKindOfClass:[HelpCenterListModel class]]) {
        return [HelpCenterListTableViewCell class];
    }
    if ([model isKindOfClass:[anchorAddGuildHandle class]]) {
        return [InvitationListTableViewCell class];
    }
    if ([model isKindOfClass:[shareUserHandle class]]) {
        return [InvitationTudiListTableViewCell class];
    }
    return nil;
}

@end
