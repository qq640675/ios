//
//  RankHeaderView.h
//  beijing
//
//  Created by 黎 涛 on 2020/5/21.
//  Copyright © 2020 zhou last. All rights reserved.
//123123123

#import "BaseView.h"
#import "RankTableViewCell.h"
#import "rankingHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface RankHeaderView : BaseView

@property (nonatomic, assign) RankListType rankListType;
@property (nonatomic, assign) YLRankBtnType btnType;
@property (nonatomic, strong) rankingHandle *firstRankHandle;
@property (nonatomic, strong) rankingHandle *secondRankHandle;
@property (nonatomic, strong) rankingHandle *thirdRankHandle;
@property (nonatomic, copy) void (^headerTypeButtonClick)(int index);
@property (nonatomic, copy) void (^coinButtonClickBlock)(rankingHandle *rankHandle);

- (instancetype)initWithType:(RankListType)rankType;
- (void)setHeaderData:(NSArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
