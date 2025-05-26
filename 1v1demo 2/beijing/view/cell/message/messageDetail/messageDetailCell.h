//
//  messageDetailCell.h
//  beijing
//
//  Created by zhou last on 2018/6/25.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MansionInviteListModel.h"

@interface messageDetailCell : UITableViewCell

@property (nonatomic, strong) MansionInviteListModel *inviteModel;

+ (float)getCellHeight:(NSString *)tittle content:(NSString *)content;

- (void)msgDetailModel:(NSString *)time tittle:(NSString *)tittle content:(NSString *)content image:(NSString *)image;

@end
