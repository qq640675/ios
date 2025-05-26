//
//  YLAlbumController.m
//  beijing
//
//  Created by zhou last on 2018/7/11.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLAlbumController.h"
#import "DefineConstants.h"
#import "YLBasicView.h"
#import <Masonry.h>
#import "YLNetworkInterface.h"
#import "YLTapGesture.h"
#import "YLNewAlbumController.h"
#import "myAlbumHandle.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "YLUserDefault.h"
#import "MyVideoPlayViewController.h"
#import "XLPhotoBrowser.h"
#import "UIAlertCon+Extension.h"

@interface YLAlbumController ()
{
    NSMutableArray *albumListArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *albumCollcetionView;
@property (weak, nonatomic) IBOutlet UIView *uploadView;

@end

@implementation YLAlbumController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:KWHITECOLOR];

    
    [self getMyAlbumList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self myAlbumCustomUI];
    
    
}

#pragma mark ---- customUI
- (void)myAlbumCustomUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.albumCollcetionView.alwaysBounceVertical = YES;
    

    
    // 注册collectionViewcell:WWCollectionViewCell是我自定义的cell的类型
    [self.albumCollcetionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"myAlbumCell"];
    
    [_uploadView.layer setCornerRadius:15.];
    _uploadView.layer.masksToBounds = YES;
    [_uploadView setClipsToBounds:NO];
    _uploadView.layer.shadowOpacity = .4;// 阴影透明度
    _uploadView.layer.shadowColor = KBLACKCOLOR.CGColor;// 阴影的颜色
    _uploadView.layer.shadowRadius = 2;// 阴影扩散的范围控制
    _uploadView.layer.shadowOffset = CGSizeMake(0,0);
    
    [YLTapGesture tapGestureTarget:self sel:@selector(uploadImageOrVideo) view:_uploadView];
}


#pragma mark ---- 获取我的相册
- (void)getMyAlbumList
{
    albumListArray = [NSMutableArray array];
    dispatch_queue_t queue = dispatch_queue_create("我的相册", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        [YLNetworkInterface getMyPhotoList:[YLUserDefault userDefault].t_id page:1 block:^(NSMutableArray *listArray) {
            self->albumListArray = listArray;
            
            [self.albumCollcetionView reloadData];
        }];
    });
}

#pragma mark ---- 上传视频或照片
- (void)uploadImageOrVideo
{
    YLNewAlbumController *newAlbumVC = [YLNewAlbumController new];
    newAlbumVC.title = @"新建相册";
    [self.navigationController pushViewController:newAlbumVC animated:YES];
}

#pragma mark -- UICollectionViewDataSource
/** 每组cell的个数*/
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return albumListArray.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"myAlbumCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        
        [view removeFromSuperview];
        
    }
    
    cell.contentView.tag = indexPath.row + 100;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteAlbum:)];
    longPress.minimumPressDuration = 2;
    [cell.contentView addGestureRecognizer:longPress];
    
    myAlbumHandle *handle = albumListArray[indexPath.row];
    
    UIImageView *headBgImageView = [UIImageView new];
    
    if (indexPath.row % 2 == 1) {
        headBgImageView.frame = CGRectMake(0, 4, (App_Frame_Width - 15)/2. - 15, 208);
    }else{
        headBgImageView.frame = CGRectMake(15, 4, (App_Frame_Width - 15)/2. - 15, 208);
    }
    
    [headBgImageView.layer setCornerRadius:5.];
    [headBgImageView setClipsToBounds:YES];
    [cell.contentView addSubview:headBgImageView];
    
    //背景
    if ([handle.t_file_type intValue] == 0) {
        //图片
        if (![NSString isNullOrEmpty:handle.t_addres_url]) {
            [headBgImageView sd_setImageWithURL:[NSURL URLWithString:handle.t_addres_url] placeholderImage:[UIImage imageNamed:@"loading"]];
        }else{
            headBgImageView.image = [UIImage imageNamed:@"loading"];
        }
    }else{
        //视频
        if (![NSString isNullOrEmpty:handle.t_video_img]) {
            [headBgImageView sd_setImageWithURL:[NSURL URLWithString:handle.t_video_img] placeholderImage:[UIImage imageNamed:@"loading"]];
        }else{
            headBgImageView.image = [UIImage imageNamed:@"loading"];
        }
    }
    headBgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [headBgImageView setClipsToBounds:YES];
    
    //金币
    UIButton *coinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headBgImageView addSubview:coinButton];
    [coinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((App_Frame_Width - 15)/2. - 50-25);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(15);
    }];
    coinButton.titleLabel.font = PingFangSCFont(10);
    [coinButton setTitleColor:KWHITECOLOR forState:UIControlStateNormal];
    [coinButton setTitle:[NSString stringWithFormat:@"%@ 金币",handle.t_money] forState:UIControlStateNormal];
    if ([handle.t_money intValue] <= 0) {
        coinButton.hidden = YES;
    }else{
        coinButton.hidden = NO;
    }
    [coinButton setBackgroundImage:[UIImage imageNamed:@"myAlbum_coin"] forState:UIControlStateNormal];
    //视频标题
    
    UIButton *videoTittleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headBgImageView addSubview:videoTittleButton];
    [videoTittleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(208 - 80);
        make.width.mas_equalTo((App_Frame_Width - 15)/2. - 15);
        make.height.mas_equalTo(38);
    }];
    [videoTittleButton setTitle:handle.t_title forState:UIControlStateNormal];
    [videoTittleButton setTitleColor:KWHITECOLOR forState:UIControlStateNormal];
    
    
    if (![NSString isNullOrEmpty:handle.t_title]) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"color_%d",(arc4random() % 9)+ 1]];
        image = [YLBasicView imageCompressFitSizeScale:image targetSize:CGSizeMake((App_Frame_Width - 15)/2. - 35, 38)];
        [videoTittleButton setBackgroundImage:image forState:UIControlStateNormal];
        CGAffineTransform matrix = CGAffineTransformMakeRotation(-60./(M_PI * 180));
        videoTittleButton.transform = matrix;
    }
    
    
    //主播昵称
    UILabel *nameLabel = [YLBasicView createLabeltext:_cHandle.nickName size:PingFangSCFont(12) color:KWHITECOLOR textAlignment:NSTextAlignmentLeft];
    [headBgImageView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(videoTittleButton.mas_bottom).offset(15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    //主播头像
    UIImageView *headImgView = [UIImageView new];
    [headBgImageView addSubview:headImgView];
    [headImgView.layer setCornerRadius:10.];
    headImgView.contentMode = UIViewContentModeScaleAspectFill;
    [headImgView setClipsToBounds:YES];
    [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(videoTittleButton.mas_bottom).offset(15);
        make.width.height.mas_equalTo(20);
    }];
    
    if (![NSString isNullOrEmpty:_cHandle.handImg]) {
        [headImgView sd_setImageWithURL:[NSURL URLWithString:_cHandle.handImg] placeholderImage:[UIImage imageNamed:@"default"]];
    }else{
        headImgView.image = [UIImage imageNamed:@"default"];
    }
    
    return cell;
}

#pragma mark -- UICollectionViewDelegateFlowLayout
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((App_Frame_Width - 15)/2., 214);
}


//* section的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    myAlbumHandle *handle = albumListArray[indexPath.row];
    
    if ([handle.t_file_type intValue] == 1) {
        if (handle.t_addres_url.length != 0) {
            MyVideoPlayViewController *myVideoVC = [MyVideoPlayViewController new];
            myVideoVC.linkURL = handle.t_addres_url;
            [myVideoVC clickSelfViewBlock:^(id info) {
            }];
            myVideoVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:myVideoVC animated:YES completion:nil];
        }
    }else{
        if ([handle.t_file_type intValue] == 0) {
            //图片
            [self browsePicture:handle.t_addres_url];
        }else{
            [self browsePicture:handle.t_video_img];
        }
    }
}


#pragma mark ---- 删除相册
- (void)deleteAlbum:(UILongPressGestureRecognizer *)tap
{
    myAlbumHandle *handle = albumListArray[tap.view.tag - 100];

    [UIAlertCon_Extension alertViewDel:[NSString stringWithFormat:@"确定要删除名称为%@的相册吗?",handle.t_title] type:UIAlertControllerStyleAlert controller:self delSel:^(UIAlertAction *okSel) {
        [YLNetworkInterface delMyPhotoId:[handle.t_id intValue] block:^(BOOL isSuccess) {
            if (isSuccess) {
                [self getMyAlbumList];
            }
        }];
    }];
}

#pragma mark ---- 浏览图片
- (void)browsePicture:(NSString *)urlStr
{
    UIImageView *headImgView = [UIImageView new];

    if (![NSString isNullOrEmpty:urlStr]) {
        [headImgView sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image != nil) {
                [XLPhotoBrowser showPhotoBrowserWithImages:@[image] currentImageIndex:0];
            }
        }];
    }else{
        [XLPhotoBrowser showPhotoBrowserWithImages:@[[UIImage imageNamed:@"loading"]] currentImageIndex:0];
    }
}



@end
