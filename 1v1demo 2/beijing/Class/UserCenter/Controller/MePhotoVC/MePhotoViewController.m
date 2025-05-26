//
//  MePhotoViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/3/26.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "MePhotoViewController.h"
#import "MePhotoCollectionViewCell.h"
#import "YLNewAlbumController.h"
#import "YLNewVideoPlayerController.h"
#import "newAlbumHandle.h"
#import "XLPhotoBrowser.h"
#import "LXTAlertView.h"
#import <MJRefresh.h>

static  NSString *const CollectionCell = @"MePhotoCollectionViewCell";

@interface MePhotoViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView      *collectionView;

@property (nonatomic, strong) NSMutableArray        *listArray;

@property (nonatomic, assign) NSInteger              listPage;

@end

@implementation MePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [_collectionView.mj_header beginRefreshing];
}

#pragma mark - UI
- (void)setupUI {
    if (self.type == 0) {
        self.navigationItem.title = @"相册";
    } else {
        self.navigationItem.title = @"视频";
    }
    
    
    //设置navigationBar rightBtn
    UIButton *naviRightBtn = [UIManager initWithButton:CGRectMake(0, 0, 44, 44) text:nil font:0.0f textColor:[UIColor blackColor] normalImg:@"Dynamic_camera" highImg:nil selectedImg:nil];
    [naviRightBtn addTarget:self action:@selector(clickedNaviRightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:naviRightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.collectionView];
    
    self.listArray = [NSMutableArray new];
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.listPage = 1;
        [self getDataWithList];
    }];
    
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getDataWithList)];
    
    [_collectionView reloadData];
    
//    [_collectionView.mj_header beginRefreshing];
}

- (void)getDataWithList {
    WEAKSELF
    [YLNetworkInterface getMyAnnualAlbum:self.type page:(int)_listPage block:^(NSMutableArray *listArray) {
        if (weakSelf.listPage == 1) {
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
            [weakSelf.listArray removeAllObjects];
        } else {
            [weakSelf.collectionView.mj_footer endRefreshing];
            if ([listArray count] < 15) {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [weakSelf.listArray addObjectsFromArray:listArray];
        [weakSelf.collectionView reloadData];
        weakSelf.listPage ++;
    }];
}

- (void)clickedNaviRightBtn {
    YLNewAlbumController *newAlbumVC = [[YLNewAlbumController alloc] init];
    newAlbumVC.type = self.type;
    [self.navigationController pushViewController:newAlbumVC animated:YES];
}

- (void)deleteWithAlbumId:(int)albumId {
    WEAKSELF
    [YLNetworkInterface delMyPhotoId:albumId block:^(BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.listPage = 1;
            [weakSelf getDataWithList];
        }
    }];
}

- (void)setFirstAlbumWithId:(int)albumId {
    [SVProgressHUD show];
    [YLNetworkInterface setFirstAlbumWithId:albumId success:^{
        self.listPage = 1;
        [self getDataWithList];
    }];
}

#pragma mark - UICollectionViewDataSource
/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _listArray.count;
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MePhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[MePhotoCollectionViewCell alloc] init];
    }
    
    if ([_listArray count] > 0) {
        [cell initWithData:_listArray[indexPath.row]];
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    WEAKSELF;
    cell.deleteButtonClickBlock = ^(int albumId) {
        [weakSelf deleteWithAlbumId:albumId];
    };
    cell.coverButtonClickBlock = ^(int albumId) {
        [weakSelf setFirstAlbumWithId:albumId];
    };
    
    return cell;
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

/** 头部/底部*/
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
    }else {
        
        
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((App_Frame_Width-4)/3, 165);
}

/** 头部的尺寸*/
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0,0);
    
}

/** 底部的尺寸*/
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(0,0);
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_listArray count] == 0) {
        return;
    }
    
    newAlbumHandle *model = _listArray[indexPath.row];
    if (model.t_file_type == 0) {
        //图片
        NSURL *url = [NSURL URLWithString:model.t_addres_url];
        NSArray *urlArray = @[url];
        [XLPhotoBrowser showPhotoBrowserWithImages:urlArray currentImageIndex:0];
    } else {
        //视频
        YLNewVideoPlayerController *newVideoPlayVC = [[YLNewVideoPlayerController alloc] init];
        newVideoPlayVC.videoUrlPath = model.t_addres_url;
        [self.navigationController pushViewController:newVideoPlayVC animated:YES];

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
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width,APP_Frame_Height-SafeAreaTopHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator   = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView registerClass:[MePhotoCollectionViewCell class] forCellWithReuseIdentifier:CollectionCell];
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
