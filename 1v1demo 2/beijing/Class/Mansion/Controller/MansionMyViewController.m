//
//  MansionMyViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/6.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MansionMyViewController.h"
#import "MansionMyAnchorView.h"
#import "UIAlertCon+Extension.h"
#import "YLChoosePicture.h"
#import "YLUploadImageExtension.h"
#import "MansionUseAnthAlertView.h"
#import "MansionCreateAlertView.h"
#import "MansionInviteAlertView.h"
#import "ExplainViewController.h"

@interface MansionMyViewController ()
{
    UIScrollView *mainScrollView;
    UIImageView *coverImageView;
    
    UIButton *editBtn;
    int maxAnchors;
    NSMutableArray *anchors;
    MansionMyAnchorView *addView;
    BOOL isEditing;
    
    BOOL useable; //是否能使用府邸功能
    NSString *coinNum;
    
    int mansionId; //我的府邸id
    BOOL isMasionPage;
}

@end

@implementation MansionMyViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    maxAnchors = 100;
    mansionId = 0;
    isEditing = NO;
    useable = NO;
    anchors = [NSMutableArray array];
    isMasionPage = YES;
    [self setSubViews];
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if ([YLUserDefault userDefault].t_sex != 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestMansionAuthority];
        });
    }
    
}

#pragma mark - not
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(masionPageClick:) name:@"MansionPageClick" object:nil];
}

- (void)masionPageClick:(NSNotification *)not {
    int isMsion = [[NSString stringWithFormat:@"%@", not.object] intValue];
    if (isMsion == 1) {
        isMasionPage = YES;
    } else {
        isMasionPage = NO;
    }
    [self requestMansionAuthority];
}

#pragma mark - net
- (void)requestMansionAuthority {
    if (isMasionPage == NO) return;
    
    [YLNetworkInterface getMansionHouseSwitchResult:^(bool houseSwitch, int mansionId, NSString *mansionMoney, NSString *t_mansion_house_coverImg) {
        self->useable = houseSwitch;
        self->coinNum = mansionMoney;
        self->mansionId = mansionId;
//        [self->coverImageView sd_setImageWithURL:[NSURL URLWithString:t_mansion_house_coverImg] placeholderImage:[UIImage imageNamed:@"loading"]];
        if (self->useable == NO) {
            MansionUseAnthAlertView *alertView = [[MansionUseAnthAlertView alloc] initWithCoin:self->coinNum];
            [alertView show];
        } else {
            [self requestMansionMyAnchors];
        }
    }];
}

- (void)requestMansionMyAnchors {
    [YLNetworkInterface getMansionHouseInfoWithId:mansionId success:^(NSArray *dataArray) {
        self->anchors = [NSMutableArray arrayWithArray:dataArray];
        [self anchorsDidChanged];
    }];
}

#pragma mark - setSubViews
- (void)setSubViews {
//    coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, App_Frame_Width*0.84)];
//    coverImageView.image = [UIImage imageNamed:@"loading"];
//    coverImageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.view addSubview:coverImageView];
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:coverImageView.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(46, 46)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = coverImageView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    coverImageView.layer.mask = maskLayer;
    
    coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, SafeAreaTopHeight-29, App_Frame_Width-30, 100)];
    coverImageView.image = [UIImage imageNamed:@"mansion_banner"];
    coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    coverImageView.layer.masksToBounds = YES;
    coverImageView.layer.cornerRadius = 6;
    [self.view addSubview:coverImageView];
    
//    UIButton *cameraBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-44, SafeAreaTopHeight-44, 44, 44) text:@"" font:1 textColor:nil normalImg:@"mansion_btn_camera" highImg:nil selectedImg:nil];
//    [cameraBtn addTarget:self action:@selector(cameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:cameraBtn];
    
    editBtn = [UIManager initWithButton:CGRectMake(0, CGRectGetHeight(coverImageView.frame)+25+SafeAreaTopHeight-29, 70, 30) text:@"管理" font:13 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
    [editBtn setTitle:@"取消" forState:UIControlStateSelected];
    editBtn.selected = NO;
    [editBtn addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
    
    UIButton *explainBtn = [UIManager initWithButton:CGRectMake(80, CGRectGetHeight(coverImageView.frame)+25+SafeAreaTopHeight-29, 80, 30) text:@"《玩法说明》" font:13 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
    [explainBtn addTarget:self action:@selector(explainBtnButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:explainBtn];
    
    UIButton *createBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-80, CGRectGetHeight(coverImageView.frame)+27.5+SafeAreaTopHeight-29, 80, 25) text:@"创建房间 >" font:12 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    createBtn.backgroundColor = [XZRGB(0xae4ffd) colorWithAlphaComponent:.72];
//    createBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 12);
    [createBtn addTarget:self action:@selector(createButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self .view addSubview:createBtn];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:createBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(12.5, 12.5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = createBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    createBtn.layer.mask = maskLayer;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(coverImageView.frame)+55+SafeAreaTopHeight-29, App_Frame_Width, APP_Frame_Height-CGRectGetHeight(coverImageView.frame)-SafeAreaBottomHeight-55)];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.bounces = NO;
    [self.view addSubview:mainScrollView];
    
    WEAKSELF;
    CGFloat width = App_Frame_Width/4;
    CGFloat height = 120;
    for (int i = 0; i < maxAnchors; i ++) {
        MansionMyAnchorView *anchorView = [[MansionMyAnchorView alloc] initWithFrame:CGRectMake((i%4)*width, (i/4)*height, width, height) isAdd:NO];
        anchorView.tag = 1000+i;
        anchorView.hidden = YES;
        anchorView.deleteButtonClickBlock = ^{
            [weakSelf anchorDeleteButtonClick:i];
        };
        [mainScrollView addSubview:anchorView];
    }
    
    addView = [[MansionMyAnchorView alloc] initWithFrame:CGRectMake(0, 0, width, height) isAdd:YES];
    [mainScrollView addSubview:addView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAnchor)];
    [addView addGestureRecognizer:tap];
}


#pragma mark - func
- (void)explainBtnButtonClick {
    ExplainViewController *explainVC = [[ExplainViewController alloc] init];
    [self.navigationController pushViewController:explainVC animated:YES];
}

- (void)editButtonClick:(UIButton *)sender {
    
    if ([YLUserDefault userDefault].t_sex == 0) {
        
        [SVProgressHUD showInfoWithStatus:@"只有男用户才能邀请主播进行1对2视频"];
        return;
    }
    
    if (useable == NO) {
        MansionUseAnthAlertView *alertView = [[MansionUseAnthAlertView alloc] initWithCoin:coinNum];
        [alertView show];
        return;
    }
    if (anchors.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"暂无主播"];
        return;
    }
    
    sender.selected = !sender.selected;
    isEditing = sender.selected;
    [self editingStatusDidChanged];
}

// 移除主播
- (void)anchorDeleteButtonClick:(int)index {
    if (anchors.count > index) {
        MansionAnchorModel *model = anchors[index];
        [LXTAlertView alertViewDefaultWithTitle:@"温馨提示" message:@"是否将这个主播移除府邸？" sureHandle:^{
            [YLNetworkInterface delMansionHouseAnchorWithMansionid:self->mansionId anchorId:model.t_id success:^{
                [self->anchors removeObjectAtIndex:index];
                [self anchorsDidChanged];
                if (self->anchors.count == 0) {
                    self->isEditing = NO;
                    self->editBtn.selected = NO;
                    [self editingStatusDidChanged];
                }
            }];
        }];
    }
}

// 创建房间
- (void)createButtonClick:(UIButton *)sender {
    
    if ([YLUserDefault userDefault].t_sex == 0) {
        
        [SVProgressHUD showInfoWithStatus:@"只有男用户才能邀请主播进行1对2视频"];
        return;
    }
    
    if (useable == NO) {
        MansionUseAnthAlertView *alertView = [[MansionUseAnthAlertView alloc] initWithCoin:coinNum];
        [alertView show];
        return;
    }
    
    if (mansionId == 0) {
        [SVProgressHUD showInfoWithStatus:@"府邸ID异常"];
        return;
    }
    
    if (anchors.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"府邸暂无主播，赶快去邀请主播吧~"];
        return;
    }
    
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
    MansionCreateAlertView *createAlertView = [[MansionCreateAlertView alloc] init];
    createAlertView.mansionId = mansionId;
    [createAlertView show];
}

- (void)addAnchor {
    if ([YLUserDefault userDefault].t_sex == 0) {
        
        [SVProgressHUD showInfoWithStatus:@"只有男用户才能邀请主播进行1对2视频"];
        return;
    }
    
    if (useable == NO) {
        MansionUseAnthAlertView *alertView = [[MansionUseAnthAlertView alloc] initWithCoin:coinNum];
        [alertView show];
        return;
    }
    
    MansionInviteAlertView *alertView = [[MansionInviteAlertView alloc] initWithType:InvitiAlertTypeJoinMansion mansionid:mansionId];
    [alertView show];
    WEAKSELF;
    alertView.removeFromSuperViewBlock = ^{
        [weakSelf requestMansionMyAnchors];
    };
}

- (void)editingStatusDidChanged {
    for (int i = 0; i < maxAnchors; i ++) {
        MansionMyAnchorView *anchorView = [mainScrollView viewWithTag:1000+i];
        anchorView.deleteBtn.hidden = !isEditing;
    }
    if (anchors.count < maxAnchors) {
        addView.hidden = isEditing;
    } else if (anchors.count == maxAnchors){
        addView.hidden = YES;
    }
}

- (void)anchorsDidChanged {
    for (int i = 0; i < maxAnchors; i ++) {
        MansionMyAnchorView *anchorView = [mainScrollView viewWithTag:1000+i];
        anchorView.hidden = YES;
    }
    int num = (int)anchors.count;
    if (num > maxAnchors) {
        num = maxAnchors;
        addView.hidden = YES;
    } else if (num == maxAnchors) {
        addView.hidden = YES;
    } else {
        if (isEditing == NO) {
            addView.hidden = NO;
        }
        addView.x = (App_Frame_Width/4)*(num%4);
        addView.y = addView.height*(num/4);
    }
    mainScrollView.contentSize = CGSizeMake(App_Frame_Width, addView.y+addView.height);
    for (int i = 0; i < num; i ++) {
        MansionMyAnchorView *anchorView = [mainScrollView viewWithTag:1000+i];
        anchorView.anchorModel = anchors[i];
        anchorView.hidden = NO;
    }
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - cover
//- (void)cameraButtonClick {
//    if (useable == NO) {
//        MansionUseAnthAlertView *alertView = [[MansionUseAnthAlertView alloc] initWithCoin:coinNum];
//        [alertView show];
//        return;
//    }
//
//    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
//    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
//        [LXTAlertView alertViewDefaultWithTitle:@"温馨提示" message:@"此功能会在选择图片作为您的府邸封面服务中访问您的相机和相册权限" sureHandle:^{
//            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
//                [[UIApplication sharedApplication] openURL:settingsURL];
//            }
//        }];
//    }else{
//        [UIAlertCon_Extension alertViewChoosePictureOrCamera:@"选择图片作为您的府邸封面"
//                                              type:UIAlertControllerStyleActionSheet
//                                         controller:self
//                                       choosePicture:^(UIAlertAction *okSel)
//         {
//             [[YLChoosePicture shareInstance] choosePicture:self type:YLPickImageTypeAlbum pickBlock:^(UIImage *pickImage) {
//                 [self uploadCoverImage:pickImage];
//             }];
//         } camera:^(UIAlertAction *okSel) {
//             [[YLChoosePicture shareInstance] choosePicture:self type:YLPickImageTypeCamera pickBlock:^(UIImage *pickImage) {
//                 [self uploadCoverImage:pickImage];
//             }];
//         }];
//    }
//}

//- (void)uploadCoverImage:(UIImage *)image {
//    [[YLUploadImageExtension shareInstance] uploadImage:image uplodImageblock:^(NSString *backImageUrl) {
//        [YLNetworkInterface setMansionHouseCoverImgWithId:self->mansionId imagePath:backImageUrl success:^{
//            self->coverImageView.image = image;
//        }];
//    }];
//}


@end
