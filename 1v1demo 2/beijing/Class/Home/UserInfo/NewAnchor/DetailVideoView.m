//
//  DetailVideoView.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/4.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "DetailVideoView.h"
#import "videoPictureHandle.h"
#import "AnchorPhotoCollectionViewCell.h"
#import "XLPhotoBrowser.h"
#import "VideoPlayViewController.h"
#import "PrivacyCheckAlertView.h"
#import "YLInsufficientManager.h"

@interface DetailVideoView()
{
    UIViewController *curVC;
}
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) videoPictureHandle            *fileHandle;
@end

@implementation DetailVideoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.dataArray = [NSMutableArray array];
        [self setSubViewsWithFrame:frame];
        curVC = [SLHelper getCurrentVC];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - subViews
- (void)setSubViewsWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;
    layout.sectionInset = UIEdgeInsetsMake(15, 0, 10, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate   = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator   = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[AnchorPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"photoCell"];
    [self addSubview:_collectionView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AnchorPhotoCollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    photoCell.handle = _dataArray[indexPath.row];
    return photoCell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    videoPictureHandle *handle = _dataArray[indexPath.row];
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
                [self.collectionView reloadData];
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
                [self.collectionView reloadData];
            } else if (code == -1){
                //余额不足
                [[YLInsufficientManager shareInstance] insufficientShow];
            }
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback?:self.scrollCallback(scrollView);
}

#pragma mark - JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listViewLoadDataIfNeeded {
    [self.collectionView reloadData];
}

@end

