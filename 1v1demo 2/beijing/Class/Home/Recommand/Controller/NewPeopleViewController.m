//
//  NewPeopleViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/3/6.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "NewPeopleViewController.h"
#import "RecommendCollectionViewCell.h"
#import "RecommendBannerView.h"
#import "YLPushManager.h"
#import <MJRefresh.h>
#import "HeaderCollectionViewCell.h"
#import "HomeHeaderCollectionReusableView.h"

static  NSString *const CollectionCell = @"RecommendCollectionViewCell";

@interface NewPeopleViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
{
    CGFloat headerHeight;
    NSArray *beancurdList;
    HomeHeaderCollectionReusableView *headerView;
}

@property (nonatomic, strong) UICollectionView      *collectionView;

@property (nonatomic, strong) NSMutableArray        *listArray;
@property (nonatomic, copy) NSArray                 *bannerArray;
@property (nonatomic, assign) NSInteger              listPage;

@property (nonatomic, assign) BOOL                   isLoaded;

@end

@implementation NewPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.type != 5) {
        self.selectedCity = @"";
    }
    [self setupUI];
}

#pragma mark - UI
- (void)setupUI {
    
    [self.view addSubview:self.collectionView];
    headerHeight = 120;
    self.listArray = [NSMutableArray new];
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.listPage = 1;
        [self getDataWithBanner];
//        [self getDataWithList];
    }];
    
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getDataWithList)];
    
    [_collectionView reloadData];
    
    [_collectionView.mj_header beginRefreshing];
}

- (void)getDataWithBanner {
    if (self.type == 3) {
//        WEAKSELF
//        [YLNetworkInterface getIosBanner:^(NSMutableArray *listArray) {
//            weakSelf.bannerArray = listArray;
//            [weakSelf getDataWithList];
//        }];
        [YLNetworkInterface getAllBannerListSuccess:^(NSDictionary *data) {
            if ([data[@"bannerList"] isKindOfClass:[NSArray class]]) {
                self.bannerArray = data[@"bannerList"];
            }
            if ([data[@"beancurdList"] isKindOfClass:[NSArray class]]) {
                self->beancurdList = data[@"beancurdList"];
            }
            [self setHeaderView];
            [self getDataWithList];
        }];
    } else {
        [self getDataWithList];
    }
}

- (void)getDataWithList {
    WEAKSELF
    [YLNetworkInterface getHomePageListWithCity:self.selectedCity page:(int)_listPage queryType:(int)_type block:^(NSMutableArray *listArray) {
        if (weakSelf.listPage == 1) {
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
            [weakSelf.listArray removeAllObjects];
        } else {
            [weakSelf.collectionView.mj_footer endRefreshing];
            if ([listArray count] < 10) {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [weakSelf.listArray addObjectsFromArray:listArray];
        weakSelf.isLoaded = YES;
        [weakSelf.collectionView reloadData];
        weakSelf.listPage ++;
    }];
}

- (void)refreshListWithCity:(NSString *)city {
    self.selectedCity = city;
    [_collectionView.mj_header beginRefreshing];
}

- (void)setHeaderView {
    CGFloat bannerH = 0;
    if (self.bannerArray.count > 0) {
        bannerH = 120;
    }
    
    headerHeight = bannerH;
    [headerView setBannerArray:self.bannerArray bannerHeight:bannerH];
//    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return beancurdList.count;
    } else {
        return _listArray.count;
    }
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HeaderCollectionViewCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headerCell" forIndexPath:indexPath];
        [headerCell setBannnerData:beancurdList[indexPath.row]];
        return headerCell;
    } else {
        RecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCell forIndexPath:indexPath];
        if (!cell) {
            cell = [[RecommendCollectionViewCell alloc] init];
        }
        
        if ([_listArray count] > 0) {
            [cell initWithData:_listArray[indexPath.row]];
        }
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

/** 头部/底部*/
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0 && self.type == 3) {
            headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
            return headerView;
        }
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return CGSizeMake((App_Frame_Width-15)/2, (App_Frame_Width-15)/2);
    if (indexPath.section == 0) {
        if (self.type == 3) {
            return CGSizeMake((App_Frame_Width-21)/2, (App_Frame_Width-21)/4);
        } else {
            return CGSizeMake(0, 0);
        }
    }
    return CGSizeMake((App_Frame_Width-21)/2, (App_Frame_Width-21)/2);
}

/** 头部的尺寸*/
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.type == 3 && section == 0) {
        return CGSizeMake(App_Frame_Width, headerHeight);
    }
    return CGSizeMake(0,0);
    
}

/** 底部的尺寸*/
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(0, 0);
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSDictionary *dic = beancurdList[indexPath.row];
        [YLPushManager bannerPushClass:[NSString stringWithFormat:@"%@", dic[@"t_link_url"]]];
    } else {
        if ([_listArray count] == 0) {
            return;
        }
        
        homePageListHandle *handle = _listArray[indexPath.row];
        if (handle.t_is_public == 1) {
            //存在免费视频
            [YLPushManager pushUserInfo:handle.t_id];
        } else {
            [YLPushManager pushAnchorDetail:handle.t_id];
        }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    //    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    //设置(Highlight)高亮下的颜色
    //    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
}

- (void)collectionView:(UICollectionView *)collectionView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    //    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    //    //设置(Nomal)正常状态下的颜色
    //    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
}


#pragma mark - Lazyload
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.minimumLineSpacing = 7;
        layout.minimumInteritemSpacing = 7;
        layout.sectionInset = UIEdgeInsetsMake(0, 7, 7, 7);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width,APP_Frame_Height-SafeAreaTopHeight-SafeAreaBottomHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator   = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView registerClass:[RecommendCollectionViewCell class] forCellWithReuseIdentifier:CollectionCell];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"bannerView"];
//        [_collectionView registerClass:[RecommendBannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"bannerView"];
        [_collectionView registerClass:[HeaderCollectionViewCell class] forCellWithReuseIdentifier:@"headerCell"];
        [_collectionView registerClass:[HomeHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    }
    return _collectionView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
