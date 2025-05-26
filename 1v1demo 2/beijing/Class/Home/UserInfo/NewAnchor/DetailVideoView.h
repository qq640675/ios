//
//  DetailVideoView.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/4.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "JXPageListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailVideoView : BaseView<JXPageListViewListDelegate,UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger anchorId;
@property (nonatomic, strong) NSMutableArray *dataArray;;

@end

NS_ASSUME_NONNULL_END
