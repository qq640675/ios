//
//  RankListViewController.h
//  beijing
//
//  Created by 黎 涛 on 2020/5/21.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseViewController.h"
#import "RankTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface RankListViewController : BaseViewController

@property (nonatomic, assign) RankListType rankType;
@property (nonatomic, assign) BOOL isShowBack;


@end

NS_ASSUME_NONNULL_END
