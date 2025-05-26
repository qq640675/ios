//
//  RecommendViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/3/6.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendCollectionViewCell.h"
#import "RecommendBannerView.h"

#import "YLPushManager.h"
#import <MJRefresh.h>

static  NSString *const CollectionCell = @"RecommendCollectionViewCell";


@interface RecommendViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
//RecommendBannerCollectionReusableViewDelegate
>

@property (nonatomic, strong) UICollectionView      *collectionView;

@property (nonatomic, strong) NSMutableArray        *hotListArray;

//@property (nonatomic, copy) NSArray                 *bannerArray;

@property (nonatomic, assign) NSInteger             hotListPage;

@property (nonatomic, assign) BOOL                  isLoaded;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
    
}

#pragma mark - UI
- (void)setupUI {
    
    [self.view addSubview:self.collectionView];
    
    self.hotListArray = [NSMutableArray new];
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.hotListPage = 1;
        [self getDataWithBanner];
//        [self getDataWithHotList];
    }];
    
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getDataWithHotList)];
    
    [_collectionView reloadData];
    
    [_collectionView.mj_header beginRefreshing];
}

- (void)getDataWithBanner {
//    WEAKSELF
//    [YLNetworkInterface getIosBanner:^(NSMutableArray *listArray) {
//        weakSelf.bannerArray = listArray;
//        [weakSelf getDataWithHotList];
//    }];
    [self getDataWithHotList];
}

- (void)getDataWithHotList {
    WEAKSELF
    [YLNetworkInterface getHomePageList:[YLUserDefault userDefault].t_id page:(int)_hotListPage queryType:1 block:^(NSMutableArray *listArray) {
        if (weakSelf.hotListPage == 1) {
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
            [weakSelf.hotListArray removeAllObjects];
        } else {
            [weakSelf.collectionView.mj_footer endRefreshing];
            if ([listArray count] < 10) {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [weakSelf.hotListArray addObjectsFromArray:listArray];
        [weakSelf.collectionView reloadData];
        weakSelf.hotListPage ++;
    }];
}

#pragma mark - UICollectionViewDataSource
/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _hotListArray.count;
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    RecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[RecommendCollectionViewCell alloc] init];
    }
    if (_hotListArray.count > 0) {
        [cell initWithData:_hotListArray[indexPath.row]];
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

/** 头部/底部*/
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        if (indexPath.section == 0) {
//            RecommendBannerView *bannerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"bannerView" forIndexPath:indexPath];
//            if (_bannerArray.count > 0) {
//                bannerView.banners = _bannerArray;
//            }
//            bannerView.bannerClicked = ^(NSInteger bannerIndex) {
//                bannerHandle *handle = self->_bannerArray[bannerIndex];
//                [YLPushManager bannerPushClass:handle.t_link_url];
//            };
//            return bannerView;
//        }
//
//    } else {
//        // 底部
//
//    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return CGSizeMake((App_Frame_Width-15)/2, (App_Frame_Width-15)/2);
    return CGSizeMake((App_Frame_Width-21)/2, (App_Frame_Width-21)/2);
}

/** 头部的尺寸*/
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return CGSizeMake(App_Frame_Width-10,120);
//    }
//    return CGSizeMake(0,0);
//    if (section == 0) {
//        return CGSizeMake(App_Frame_Width-30,140);
//    }
    return CGSizeMake(0,0);
}

/** 底部的尺寸*/
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(0, 0);
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    homePageListHandle *handle = nil;
    handle = _hotListArray[indexPath.row];
    if (handle.t_is_public == 1) {
        //存在免费视频
        [YLPushManager pushUserInfo:handle.t_id];
    } else {
        [YLPushManager pushAnchorDetail:handle.t_id];
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
//        [_collectionView registerClass:[RecommendBannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"bannerView"];
        
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
