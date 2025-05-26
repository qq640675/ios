//
//  YLAppointMentController.m
//  beijing
//
//  Created by zhou last on 2018/6/15.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLAppointMentController.h"
#import "YLNetworkInterface.h"
#import "DefineConstants.h"
#import <Masonry.h>
#import "videoListHandle.h"
#import <UIImageView+WebCache.h>
#import "NSString+Extension.h"
#import "YLBasicView.h"
#import "UIAlertCon+Extension.h"
#import "YLUserDefault.h"
#import <AVFoundation/AVFoundation.h>
#import "MyVideoPlayViewController.h"
#import <MJRefresh.h>
#import <Accelerate/Accelerate.h>
#import "UIImage+FEBoxBlur.h"
#import "YLTapGesture.h"
#import "personalCenterHandle.h"
#import "insufficientView.h"
#import <SVProgressHUD.h>
#import <WXApi.h>
#import "YLInsufficientManager.h"
#import "YLRechargeVipController.h"
#import "AnchorVideoView.h"
#import "DYVideoViewController.h"
#import "PrivacyCheckAlertView.h"

@interface YLAppointMentController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *videoListArray; //当前视频数组
    int currentPage; //页码
    UIViewController *VC;
    int videoType;  //视频类型 -1全部 0 免费 1付费

    videoListHandle *videoVipHandle; //视频model
    insufficientView *insuffiView;//余额不足弹框
    UIImageView *lastPayMethodImgView; //上一个支付方式 微信 支付宝
    UIImageView *lastRechargeImgView; //上一个充值按钮
    
    YLVideoRechargeType videoRechargeType;//充值列表
    YLVideoPayType videoPayType;//支付方式
    NSMutableArray *rechargeListArray; //充值列表

    
    NSIndexPath *cellPath;
    NSMutableArray *cellViewArray;
        
    NSInteger selectedCell;
    
    UIView *topView;
}

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic)  UICollectionView *videoCollectionView;

@end

@implementation YLAppointMentController

#pragma mark - vc
- (instancetype)init
{
    if (self == [super init]) {
    }
    return self;
}

- (id)initNav:(UIViewController *)selfVC
{
    VC = selfVC;
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    videoType = -1;
    videoListArray = [NSMutableArray array];
    [self videoCustomUI];
    [self requestAppointIsRefresh:YES];
}

#pragma mark ---- customUI
- (void)videoCustomUI {
    [self setTopView];
    [self registCollectionView];
    
    WEAKSELF;
    self.videoCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestAppointIsRefresh:YES];
    }];
    self.videoCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestAppointIsRefresh:NO];
    }];
}

- (void)setTopView {
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 40)];
    topView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topView];
    
    NSArray *imgArr = @[@"appoint_all", @"appoint_free", @"appoint_nofree"];
    NSArray *titleArr = @[@"全部", @"公开", @"私密"];
    CGFloat width = App_Frame_Width/imgArr.count;
    for (int i = 0; i < imgArr.count; i ++) {
        UIButton *btn = [UIManager initWithButton:CGRectMake(width*i, 0, width, 40) text:titleArr[i] font:15 textColor:XZRGB(0x999999) normalImg:imgArr[i] highImg:nil selectedImg:nil];
        [btn setTitleColor:XZRGB(0x333333) forState:UIControlStateSelected];
        btn.tag = 333+i;
        [btn setImage:0 forState:8];
        [btn addTarget:self action:@selector(topViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:btn];
        if (i == 0) {
            btn.selected = YES;
        } else {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width*i, 12, 1, 16)];
            line.backgroundColor = XZRGB(0xebebeb);
            [topView addSubview:line];
        }
    }
}

- (void)registCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 15;
    layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    self.videoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, App_Frame_Width,APP_Frame_Height-SafeAreaTopHeight-SafeAreaBottomHeight-40) collectionViewLayout:layout];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.videoCollectionView.backgroundColor = UIColor.whiteColor;
    self.videoCollectionView.delegate = self;
    self.videoCollectionView.dataSource = self;
    self.videoCollectionView.showsVerticalScrollIndicator   = YES;
    self.videoCollectionView.showsHorizontalScrollIndicator = YES;
    if (@available(iOS 11.0, *)) {
        self.videoCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.videoCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"videoListCell"];
    [self.view addSubview:self.videoCollectionView];
}

#pragma mark ---- 获取短视频列表
- (void)requestAppointIsRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        currentPage = 1;
    } else {
        currentPage ++;
    }
    [SVProgressHUD show];
    [YLNetworkInterface getVideoListUserId:[YLUserDefault userDefault].t_id page:currentPage queryType:videoType block:^(NSMutableArray *listArray) {
        [SVProgressHUD dismiss];
        [self->_videoCollectionView.mj_header endRefreshing];
        [self->_videoCollectionView.mj_footer endRefreshing];
        if ([listArray count] < 10) {
            self.videoCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
            [self.videoCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self->currentPage == 1) {
            self->videoListArray = [NSMutableArray arrayWithArray:listArray];
        }else{
            [self->videoListArray addObjectsFromArray:listArray];
        }
        [self.videoCollectionView reloadData];
    }];
}

#pragma mark - UICollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return videoListArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"videoListCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if ([videoListArray count] > 0) {
        AnchorVideoView *videoView = [[AnchorVideoView alloc] initWithFrame:CGRectMake(0, 0, (App_Frame_Width-45)/2, (App_Frame_Width-45)/2*1.333)];
        videoView.clipsToBounds = YES;
        videoView.layer.cornerRadius = 5.0f;
        [cell.contentView addSubview:videoView];
        
        videoListHandle *handle = videoListArray[indexPath.row];
        videoPictureHandle *pHandler = [[videoPictureHandle alloc] init];
        pHandler.t_id = handle.t_id;
        pHandler.t_is_private = [handle.t_is_private intValue];
        pHandler.t_money = handle.t_money;
        pHandler.t_nickName = handle.t_nickName;
        pHandler.t_video_img = handle.t_video_img;
        pHandler.t_handImg = handle.t_handImg;
        pHandler.t_title = handle.t_title;
        pHandler.t_file_type = 1;
        pHandler.is_see = handle.is_see;
        
        
        videoView.handle = pHandler;
    }
   
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((App_Frame_Width-45)/2, (App_Frame_Width-45)/2*1.333);
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (videoListArray.count != 0) {
        selectedCell = indexPath.row;
        
        videoListHandle *handle = videoListArray[indexPath.row];
        
        if ([handle.t_is_private intValue] == 1) {
        //私密
        if (handle.is_see == 1) {
            //看过
            [self payingVideo:handle];
        }else{
            if (![YLUserDefault userDefault].t_is_vip) {
                //vip
                [self payingVideo:handle];
            } else {
                cellPath = indexPath;
                [self vipGradeSet:handle];
            }
        }
        }else{
        //公开
          [self payingVideo:handle];
        }
    }
}

#pragma mark ----- 弹出vip升级框
- (void)vipGradeSet:(videoListHandle *)handle
{
    videoVipHandle = handle;
    WEAKSELF;
    PrivacyCheckAlertView *alertView = [[PrivacyCheckAlertView alloc] initWithType:@"视频" coin:[handle.t_money intValue]];
    alertView.sureButtonClickBlock = ^{
        [weakSelf cosumeOkBtnBeClicked];
    };
}

#pragma mark ---- 确定消费
- (void)cosumeOkBtnBeClicked {
    [YLNetworkInterface seeVideoConsumeUserId:[YLUserDefault userDefault].t_id coverConsumeUserId:videoVipHandle.t_user_id videoId:videoVipHandle.t_id block:^(int code) {
        if (code == 1) {
            [self refreshConsumeStatus];
            [self payingVideo:self->videoVipHandle];
        }else if (code == -1){
            //余额不足
            [[YLInsufficientManager shareInstance] insufficientShow];
        }
    }];
}

#pragma mari --- 更改消费过后的遮罩展示效果
- (void)refreshConsumeStatus
{
    videoListHandle *handle = videoListArray[selectedCell];
    handle.is_see = 1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedCell inSection:0];
    [_videoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)payingVideo:(videoListHandle *)handle
{
    
    DYVideoViewController *videoVC = [[DYVideoViewController alloc] init];
    videoVC.videoArray = videoListArray;
    videoVC.videoIndex = selectedCell;
    videoVC.page = currentPage;
    videoVC.videoType = videoType;
    [self.navigationController pushViewController:videoVC animated:YES];
}

#pragma mark - top
- (void)topViewButtonClick:(UIButton *)sender {
    for (int i = 0; i < 3; i ++) {
        UIButton *btn = [topView viewWithTag:333+i];
        btn.selected = NO;
    }
    sender.selected = YES;
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    int index = (int)sender.tag-333;
    [self topButtonClick:index];
}

- (void)topButtonClick:(int)index {
    if (index == 0) {
        videoType = -1;
    } else if (index == 1) {
        videoType = 0;
    } else if (index == 2) {
        videoType = 1;
    }
    [_videoCollectionView.mj_header beginRefreshing];
}




@end
