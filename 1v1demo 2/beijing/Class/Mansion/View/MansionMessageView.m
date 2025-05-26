//
//  MansionMessageView.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/8.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MansionMessageView.h"

@implementation MansionMessageView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = UIColor.clearColor;
        self.messageData = [NSMutableArray array];
        [self setSubViews];
    }
    return self;
}

#pragma mark - subViews
- (void)setSubViews {
    _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
    _messageTableView.backgroundColor = [UIColor clearColor];
    _messageTableView.tableFooterView = [UIView new];
    _messageTableView.dataSource = self;
    _messageTableView.delegate = self;
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _messageTableView.showsVerticalScrollIndicator = NO;
    [_messageTableView registerClass:[MansionMessageTableViewCell class] forCellReuseIdentifier:@"messageCell"];
    [self addSubview:_messageTableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messageData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MansionMessageTableViewCell *messageCell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    messageCell.messageModel = _messageData[indexPath.row];
    return messageCell;
}

#pragma mark - func
- (void)reloadAndscrollToBottom {
    // 刷新并滑到底部
    [self.messageTableView reloadData];
    if (_messageData.count > 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messageData.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

@end
