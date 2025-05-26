//
//  MansionMessageView.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/8.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "MansionMessageTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MansionMessageView : BaseView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *messageTableView;
@property (nonatomic, strong) NSMutableArray<MansionMessageModel *> *messageData;

- (void)reloadAndscrollToBottom;

@end

NS_ASSUME_NONNULL_END
