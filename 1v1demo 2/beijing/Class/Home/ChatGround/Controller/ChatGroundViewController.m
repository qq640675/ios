//
//  ChatGroundViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/5/14.
//  Copyright © 2020 zhou last. All rights reserved.
//

// vc
#import "ChatGroundViewController.h"
#import "NearViewController.h"

// view
#import "RecommendCollectionViewCell.h"
#import "HeaderCollectionViewCell.h"
#import "HomeHeaderCollectionReusableView.h"
#import "YLEPPickerController.h"

// other
#import "UIButton+LXMImagePosition.h"
#import <MJRefresh.h>
#import "YLPushManager.h"

@interface ChatGroundViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    UIView *buttonView;
    UICollectionView *collectionView;
    HomeHeaderCollectionReusableView *headerView;
    int page;
    NSMutableArray *dataArray;
    CGFloat headerHeight;
    NSArray *bannerArray;
    NSArray *beancurdList;
    int queryType;
    NearViewController *nearVC;
    
    NSInteger selectedIndex;
    NSString *selectedCity;
    UIButton *cityBtn;
}

@end

@implementation ChatGroundViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    dataArray = [NSMutableArray array];
    headerHeight = 50;
    queryType = 3;
    selectedCity = [NSString stringWithFormat:@"%@", [YLUserDefault userDefault].t_city];
    
    [self setTopView];
    [self setCollectionView];
    [self requestListIsRefresh:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - net
- (void)requestBanner {
    [YLNetworkInterface getAllBannerListSuccess:^(NSDictionary *data) {
        if ([data[@"bannerList"] isKindOfClass:[NSArray class]]) {
            self->bannerArray = data[@"bannerList"];
        }
        if ([data[@"beancurdList"] isKindOfClass:[NSArray class]]) {
            self->beancurdList = data[@"beancurdList"];
        }
        [self setHeaderView];
    }];
}

- (void)requestListIsRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        page = 1;
        [self requestBanner];
    } else {
        page ++;
    }
    [SVProgressHUD show];
    [YLNetworkInterface getHomePageListWithCity:selectedCity page:page queryType:queryType block:^(NSMutableArray *listArray) {
        [SVProgressHUD dismiss];
        [self->collectionView.mj_header endRefreshing];
        [self->collectionView.mj_footer endRefreshing];
        if (self->page == 1) {
            self->dataArray = [NSMutableArray arrayWithArray:listArray];
        } else {
            [self->dataArray addObjectsFromArray:listArray];
        }
        if ([listArray count] < 10) {
            self->collectionView.mj_footer.state = MJRefreshStateNoMoreData;
            [self->collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        [self->collectionView reloadData];
    }];
}

#pragma mark - func
- (void)setHeaderView {
    CGFloat bannerH = 0;
    if (bannerArray.count > 0) {
        bannerH = 120;
    }
    
    headerHeight = bannerH;
    [headerView setBannerArray:bannerArray bannerHeight:bannerH];
    [collectionView reloadData];
}

- (void)headerButtonClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [buttonView viewWithTag:1111+i];
        btn.selected = NO;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    sender.selected = YES;
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    NSInteger index = sender.tag-1111;
    
    if (selectedIndex == index) {
        // 选择地区
        [self showCityPicker];
    } else {
        [self topHeaderButtonClick:index];
    }
    
    selectedIndex = index;
}

- (void)showCityPicker
{
    [[YLEPPickerController shareInstance]customUI];
    
    [[YLEPPickerController shareInstance] reloadPickerViewData:YLEditPersonalTypeCity block:^(NSString *tittle) {
        self->selectedCity = tittle;
        [self->cityBtn setTitle:tittle forState:0];
        [self->cityBtn setTitle:tittle forState:UIControlStateSelected];
        [self->cityBtn setImagePosition:1 spacing:5];
        [self->collectionView.mj_header beginRefreshing];
    }];
}

- (void)topHeaderButtonClick:(NSInteger)index {
    nearVC.view.hidden = YES;
    if (index == 0) {
        queryType = 3;
    } else if (index == 1) {
        queryType = 1;
    } else if (index == 2) {
        queryType = 0;
    } else if (index == 3) {
        queryType = 5;
        [cityBtn setImagePosition:1 spacing:5];
    }
    
    [collectionView.mj_header beginRefreshing];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return beancurdList.count;
    } else {
        return dataArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HeaderCollectionViewCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headerCell" forIndexPath:indexPath];
        [headerCell setBannnerData:beancurdList[indexPath.row]];
        return headerCell;
    } else {
        RecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendCollectionViewCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[RecommendCollectionViewCell alloc] init];
        }
        if (dataArray.count > indexPath.row) {
            [cell initWithData:dataArray[indexPath.row]];
        }
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
            return headerView;
        }
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake((App_Frame_Width-21)/2, (App_Frame_Width-21)/4);
    }
    return CGSizeMake((App_Frame_Width-21)/2, (App_Frame_Width-21)/2);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(App_Frame_Width, headerHeight);
    }
    return CGSizeMake(0,0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSDictionary *dic = beancurdList[indexPath.row];
        [YLPushManager bannerPushClass:[NSString stringWithFormat:@"%@", dic[@"t_link_url"]]];
    } else {
        homePageListHandle *handle = nil;
        handle = dataArray[indexPath.row];
        if (handle.t_is_public == 1) {
            [YLPushManager pushUserInfo:handle.t_id];
        } else {
            [YLPushManager pushAnchorDetail:handle.t_id];
        }
    }
}

#pragma mark - subViews
- (void)setTopView {
    buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 50)];
    [self.view addSubview:buttonView];
    
    NSArray *imgArr = @[@"home_header_ns", @"home_header_tj",  @"home_header_hy", @"HomePage_city_temp"];//home_header_xr
    NSArray *titleArr = @[@"女神", @"推荐", @"新星", selectedCity];
    CGFloat width = App_Frame_Width/imgArr.count;
    for (int i = 0; i <imgArr.count; i ++) {
        UIButton *btn = [UIManager initWithButton:CGRectMake(width*i, 10, width, 40) text:titleArr[i] font:14 textColor:XZRGB(0x666666) normalImg:imgArr[i] highImg:nil selectedImg:nil];
        [btn setTitleColor:XZRGB(0x333333) forState:UIControlStateSelected];
        if (i == 0) {
            btn.selected = YES;
            selectedIndex = 0;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        } else {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width*i, 20, 1, 20)];
            line.backgroundColor = XZRGB(0xebebeb);
            [buttonView addSubview:line];
        }
        if (i == 3) {
            cityBtn = btn;
            [btn setImagePosition:1 spacing:5];
            [btn setImage:[UIImage imageNamed:@"HomePage_city_temp_sel"] forState:UIControlStateSelected];
        } else {
            [btn setImagePosition:0 spacing:7];
        }
        btn.tag = 1111+i;
        
        [btn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:btn];
    }
}

- (void)setCollectionView {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumLineSpacing = 7;
    layout.minimumInteritemSpacing = 7;
    layout.sectionInset = UIEdgeInsetsMake(0, 7, 7, 7);
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, App_Frame_Width,APP_Frame_Height-SafeAreaTopHeight-SafeAreaBottomHeight-50) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate   = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator   = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [collectionView registerClass:[RecommendCollectionViewCell class] forCellWithReuseIdentifier:@"RecommendCollectionViewCell"];
    [collectionView registerClass:[HeaderCollectionViewCell class] forCellWithReuseIdentifier:@"headerCell"];
    [collectionView registerClass:[HomeHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    [self.view addSubview:collectionView];
    
    WEAKSELF;
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestListIsRefresh:YES];
    }];
    
    collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestListIsRefresh:NO];
    }];
}



@end
