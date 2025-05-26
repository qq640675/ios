//
//  RankTableViewCell.h
//  beijing
//
//  Created by 黎 涛 on 2020/5/21.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rankingHandle.h"

NS_ASSUME_NONNULL_BEGIN



@interface RankTableViewCell : UITableViewCell

@property (nonatomic, assign) RankListType rankType;
@property (nonatomic, strong) rankingHandle *rankHandle;
@property (nonatomic, assign) NSInteger rankNum;
@property (nonatomic, copy) void (^moreButtonClickBlock)(void);


- (void)setRankButtonType:(YLRankBtnType)buttonType;

- (void)setGuardRankData:(NSDictionary *)guardRankDic;// 守护榜数据

@end

NS_ASSUME_NONNULL_END
