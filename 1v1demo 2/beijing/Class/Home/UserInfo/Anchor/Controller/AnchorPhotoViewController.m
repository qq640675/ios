//
//  AnchorPhotoViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/4/15.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "AnchorPhotoViewController.h"
#import <MJRefresh.h>
#import "XLPhotoBrowser.h"
#import "VideoPlayViewController.h"
#import "AnchorPhotoCollectionViewCell.h"
#import "YLTapGesture.h"
#import "YLInsufficientManager.h"
#import "YLRechargeVipController.h"
#import "PrivacyCheckAlertView.h"

@interface AnchorPhotoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    UICollectionView *collectionView;
    int page;
    NSMutableArray *dataArray;
}
@property (nonatomic, strong) videoPictureHandle            *fileHandle;
@end

@implementation AnchorPhotoViewController

#pragma mark - VC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == 0) {
        self.navigationItem.title = @"相册";
    } else if (self.type == 1) {
        self.navigationItem.title = @"视频";
    }
    self.view.backgroundColor = UIColor.whiteColor;
    dataArray = [NSMutableArray array];
    [self setSubViews];
    [self requestDateIsRefresh:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - net
- (void)requestDateIsRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        page = 1;
    } else {
        page++;
    }
    [SVProgressHUD show];
    [YLNetworkInterface requestAnchorPhotoOrVideoWithAnchorId:(int)_anchorId type:self.type page:page success:^(NSArray *listArray) {
        [SVProgressHUD dismiss];
        [self->collectionView.mj_header endRefreshing];
        [self->collectionView.mj_footer endRefreshing];
        if (listArray == nil) {
            self->page --;
            return ;
        }
        if (self->page == 1) {
            self->dataArray = [NSMutableArray arrayWithArray:listArray];
        } else {
            [self->dataArray addObjectsFromArray:listArray];
        }
        if ([listArray count] < 10) {
            self->collectionView.mj_footer.state = MJRefreshStateNoMoreData;
            [self->collectionView.mj_footer endRefreshingWithNoMoreData];
            
//            NSString *text;
//            if (self.type == 0) {
//                text = @"张照片";
//            } else {
//                text = @"个视频";
//            }
//            MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self->collectionView.mj_footer;
//            [footer setTitle:[NSString stringWithFormat:@"共%lu%@，没有更多了~", (unsigned long)self->dataArray.count, text] forState:MJRefreshStateNoMoreData];
        }
        
        [self->collectionView reloadData];
    } fail:^{
        [SVProgressHUD dismiss];
        [self->collectionView.mj_header endRefreshing];
        [self->collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - UI
- (void)setSubViews {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width,APP_Frame_Height-SafeAreaTopHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate   = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator   = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [collectionView registerClass:[AnchorPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"photoCell"];
    [self.view addSubview:collectionView];
    
    WEAKSELF;
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestDateIsRefresh:YES];
    }];
    
    collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestDateIsRefresh:NO];
    }];
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf requestDateIsRefresh:NO];
//    }];
//    [footer setTitle:@"上拉或点击加载更多" forState:MJRefreshStateIdle];
//    [footer setTitle:@"正在加载中..." forState:MJRefreshStateRefreshing];
//    footer.stateLabel.font = [UIFont systemFontOfSize:13];
//    footer.stateLabel.textColor = XZRGB(0x999999);
//    collectionView.mj_footer = footer;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AnchorPhotoCollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    photoCell.handle = dataArray[indexPath.row];
    return photoCell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    videoPictureHandle *handle = dataArray[indexPath.row];
    self.fileHandle = handle;
    if (handle.t_is_private == 0 || handle.is_see == 1 || ![YLUserDefault userDefault].t_is_vip) {
        //公开
        if (handle.t_file_type == 0) {
            //图片
            NSURL *url = [NSURL URLWithString:handle.t_addres_url];
            NSArray *urlArray = @[url];
            [XLPhotoBrowser showPhotoBrowserWithImages:urlArray currentImageIndex:0];
        } else {
            //视频
            UIViewController *curVC = [SLHelper getCurrentVC];
            VideoPlayViewController *videoPlayVC = [[VideoPlayViewController alloc] init];
            videoPlayVC.godId = (int)_anchorId;
            videoPlayVC.videoUrl = handle.t_addres_url;
            videoPlayVC.coverImageUrl = handle.t_video_img;
            videoPlayVC.videoId  = handle.t_id;
            videoPlayVC.queryType = 0;
            [curVC.navigationController pushViewController:videoPlayVC animated:YES];
        }
    } else {
        //私密
        NSString *type = @"";
        if (handle.t_file_type == 0) {
            type = @"照片";
        } else {
            type = @"视频";
        }
        WEAKSELF;
        PrivacyCheckAlertView *alertView = [[PrivacyCheckAlertView alloc] initWithType:type coin:[handle.t_money intValue]];
        alertView.sureButtonClickBlock = ^{
            [weakSelf clickedLookOkBtn];
        };
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (App_Frame_Width-4)/3;
    return CGSizeMake((App_Frame_Width-4)/3, width*1.33);
}

- (void)clickedLookOkBtn {
    WEAKSELF
    if (_fileHandle.t_file_type == 0) {
        //图片
        [YLNetworkInterface seeImgConsumeUserId:[YLUserDefault userDefault].t_id coverConsumeUserId:(int)_anchorId photoId:_fileHandle.t_id block:^(int code, NSString *errorMsg) {
            if (code == 1) {
                weakSelf.fileHandle.t_is_private = 0;
                [self->collectionView reloadData];
            } else if (code == -1){
                //余额不足
                [[YLInsufficientManager shareInstance] insufficientShow];
            }
        }];
    } else {
        //视频
        [YLNetworkInterface seeVideoConsumeUserId:[YLUserDefault userDefault].t_id coverConsumeUserId:(int)_anchorId videoId:_fileHandle.t_id block:^(int code) {
            if (code == 1) {
                weakSelf.fileHandle.t_is_private = 0;
                [self->collectionView reloadData];
            } else if (code == -1){
                //余额不足
                [[YLInsufficientManager shareInstance] insufficientShow];
            }
        }];
    }
}




@end
