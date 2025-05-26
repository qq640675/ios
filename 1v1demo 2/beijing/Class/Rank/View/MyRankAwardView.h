//
//  MyRankAwardView.h
//  beijing
//
//  Created by 黎 涛 on 2020/12/22.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "rankingHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyRankAwardView : BaseView
@property (nonatomic, assign) RankListType rankType;
@property (nonatomic, assign) YLRankBtnType rankBtnType;
@property (nonatomic, strong) rankingHandle *myHandle;
@property (nonatomic, strong) NSMutableArray *awardListArray;

@property (nonatomic, copy) void (^ getAwardSuccess)(void);

- (instancetype)initWithY:(CGFloat)y;
- (void)setMyAwardData:(rankingHandle *)handle;

- (void)setMyDataWithRankArray:(NSArray *)rankArray;

@end

NS_ASSUME_NONNULL_END
