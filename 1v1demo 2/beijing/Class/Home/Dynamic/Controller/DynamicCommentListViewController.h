//
//  DynamicCommentListViewController.h
//  beijing
//
//  Created by yiliaogao on 2019/1/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseTableViewController.h"
#import "DynamicCommentTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicCommentListViewController : SLBaseTableViewController

@property (nonatomic, strong) DynamicCommentTextView    *commentTextView;

@property (nonatomic, copy) NSString *commentNum;

@property (nonatomic, assign) NSInteger dynamicId;

//被评论人ID
@property (nonatomic, assign) NSInteger commentedUserId;

@end

NS_ASSUME_NONNULL_END
