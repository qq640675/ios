//
//  ChooseChatViewController.m
//  beijing
//
//  Created by 黎 涛 on 2019/9/29.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "ChooseChatViewController.h"
#import "homePageListHandle.h"
#import "VideoImageView.h"
#import "LXTAlertView.h"
#import "ChatLiveManager.h"
#import "ToolManager.h"

@interface ChooseChatViewController ()

@property (nonatomic, strong) UIImageView *headImageView;
//@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureLayer;
//@property (nonatomic, strong) AVCaptureDeviceInput *captureInput;
//@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) NSMutableArray *anchors;
@property (nonatomic, assign) NSInteger deleteIndex;
@property (nonatomic, strong) UIView *noVipView;

@end

@implementation ChooseChatViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    _anchors = [NSMutableArray array];
    
    [self setSubViews];
//    [self showSelf];
    [self addNot];
    [self addNoVipView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self play];
//    [self showSelf];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    for (int i = 0; i < _anchors.count; i ++) {
        VideoImageView *imageV = [self.view viewWithTag:1000+i];
        [imageV pause];
    }
//    [self closeSelf];
}

#pragma mark - not
- (void)addNot {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homePageMenuChanged:) name:@"HOMEPAGEMUNECHANGED" object:nil];
}

- (void)homePageMenuChanged:(NSNotification *)not {
    NSDictionary *dic = not.userInfo;
    int isChat = [dic[@"isChat"] intValue];
    if (isChat == YES) {
        [self play];
//        [self showSelf];
    } else {
        [SVProgressHUD dismiss];
        for (int i = 0; i < _anchors.count; i ++) {
            VideoImageView *imageV = [self.view viewWithTag:1000+i];
            [imageV pause];
        }
//        [self closeSelf];
    }
}

- (void)addNoVipView {
    if ([YLUserDefault userDefault].t_role == 1 || [YLUserDefault userDefault].t_is_vip == 0) {
        [self getThreeAnchorData];
        return;
    }
    self.noVipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight-SafeAreaBottomHeight+10)];
    _noVipView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_noVipView];
    
    UILabel *labbel = [UIManager initWithLabel:CGRectMake(0, _noVipView.height/2-60, App_Frame_Width, 30) text:@"VIP用户才能使用选聊功能哦~" font:17 textColor:XZRGB(0x333333)];
    [_noVipView addSubview:labbel];
    
    UIButton *vipBtn = [UIManager initWithButton:CGRectMake((_noVipView.width-120)/2, CGRectGetMaxY(labbel.frame)+10, 120, 36) text:@"立即升级" font:18 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    vipBtn.backgroundColor = XZRGB(0xfe2947);
    vipBtn.layer.masksToBounds = YES;
    vipBtn.layer.cornerRadius = 18;
    [vipBtn addTarget:self action:@selector(rechargeVIP) forControlEvents:UIControlEventTouchUpInside];
    [_noVipView addSubview:vipBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedVip) name:@"CHANGEDVIP" object:nil];
}

- (void)rechargeVIP {
    [YLPushManager pushVipWithEndTime:nil];
}

- (void)changedVip {
    if (_noVipView) {
        [_noVipView removeFromSuperview];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHANGEDVIP" object:nil];
}

#pragma mark - net
- (void)getThreeAnchorData {
    [SVProgressHUD show];
    [YLNetworkInterface getHomePageList:[YLUserDefault userDefault].t_id page:1 queryType:4 block:^(NSMutableArray *listArray) {
        [SVProgressHUD dismiss];
        [self.anchors removeAllObjects];
        if (listArray.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"暂无主播在线"];
        }
        NSInteger num = listArray.count;
        if (listArray.count > 3) {
            num = 3;
        }
        for (int i = 0; i < num; i ++) {
            homePageListHandle *handle = listArray[i];
            NSString *t_addres_url = handle.t_addres_url;
            if (t_addres_url.length > 0 && ![t_addres_url containsString:@"null"]) {
                [self.anchors addObject:handle];
            }
        }
        [self play];
    }];
}

- (void)getOneAnchorData {
    if (_deleteIndex > self.anchors.count-1) {
        return;
    }
    homePageListHandle *handle = self.anchors[_deleteIndex];
    int t_id = handle.t_id;
    [YLNetworkInterface getSelectCharAnotherWithAnchorId:t_id success:^(NSMutableArray *listArray) {
        if (listArray.count > 0) {
            homePageListHandle *handle = listArray[0];
            [self.anchors removeObjectAtIndex:self.deleteIndex];
            [self.anchors insertObject:handle atIndex:self.deleteIndex];
            VideoImageView *imageV = [self.view viewWithTag:1000+self.deleteIndex];
            imageV.defaultUrl = handle.t_addres_url;
        } else {
            if (self.anchors.count > self.deleteIndex) {
                [self.anchors removeObjectAtIndex:self.deleteIndex];
                [self play];
            }
        }
    }];
}

#pragma mark - play pause
- (void)play {
    for (int i = 0; i < 3; i ++) {
        VideoImageView *imageV = [self.view viewWithTag:1000+i];
        imageV.hidden = YES;
    }
    for (int i = 0; i < self.anchors.count; i ++) {
        VideoImageView *imageV = [self.view viewWithTag:1000+i];
        imageV.hidden = NO;
        homePageListHandle *handle = self.anchors[i];
        imageV.defaultUrl = handle.t_addres_url;
    }
}

#pragma mark - subViews
- (void)setSubViews {
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 80, 80)];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 40;
    _headImageView.image = [YLUserDefault userDefault].headImage;
    [self.view addSubview:_headImageView];
    
    UILabel *titleLabel = [UIManager initWithLabel:CGRectMake(120, 40, 150, 30) text:@"视频选聊" font:20 textColor:XZRGB(0x3f3b48)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titleLabel];
    
    UILabel *subTitleLabel = [UIManager initWithLabel:CGRectMake(120, 70, 180, 30) text:@"优选美女主播，私密聊天!" font:15 textColor:XZRGB(0x3f3b48)];
    subTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:subTitleLabel];
    
    UILabel *tipLabel = [UIManager initWithLabel:CGRectMake(15, 150, App_Frame_Width-30, 30) text:@"选择美女主播，开始私密聊天~" font:15 textColor:XZRGB(0x3f3b48)];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tipLabel];
    
    CGFloat width = (App_Frame_Width-30)/3;
    CGFloat height = width/9*16;
    WEAKSELF;
    for (int i = 0; i < 3; i ++) {
        VideoImageView *imageV = [[VideoImageView alloc] initWithFrame:CGRectMake(5+(width+10)*i, CGRectGetMaxY(tipLabel.frame)+15, width, height)];
        imageV.tag = 1000+i;
        imageV.hidden = YES;
        [self.view addSubview:imageV];
        imageV.deleteButtonClick = ^{
            [weakSelf deleteButtonClick:i];
        };
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoWithAnchor:)];
        [imageV addGestureRecognizer:tap];
    }
    
    UIButton *changeBtn = [ToolManager defaultMutableColorButtonWithFrame:CGRectMake((App_Frame_Width-width)/2, CGRectGetMaxY(tipLabel.frame)+70+height, width, 30) title:@"换一批" isCycle:YES];
//    UIButton *changeBtn = [UIManager initWithButton:CGRectMake((App_Frame_Width-110)/2, CGRectGetMaxY(tipLabel.frame)+70+height, 110, 30) text:@"换一批" font:16 textColor:UIColor.whiteColor normalBackGroudImg:@"chat_exchang_btn" highBackGroudImg:nil selectedBackGroudImg:nil];
//    [changeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 13, 0, -13)];
    [changeBtn addTarget:self action:@selector(getThreeAnchorData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
}

#pragma mark - me
//- (void)showSelf {
//    if (_captureLayer) {
//        return;
//    }
//
//    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
//        return;
//    }
//
//    _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:[self cameraWithPosition:AVCaptureDevicePositionFront] error:nil];
//    _captureSession = [[AVCaptureSession alloc] init];
//    [_captureSession addInput:_captureInput];
//    [_captureSession startRunning];
//    _captureLayer = [AVCaptureVideoPreviewLayer layerWithSession: _captureSession];
//    _captureLayer.frame = CGRectMake(0, 0, _headImageView.width, _headImageView.height);
//    _captureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    [_headImageView.layer addSublayer: _captureLayer];
//}

//- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
//    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
//    for (AVCaptureDevice *device in devices) {
//        if ([device position] == position) {
//            return device;
//        }
//    }
//    return nil;
//}

//- (void)closeSelf {
//    [_captureLayer removeFromSuperlayer];
//    _captureLayer = nil;
//    [_captureSession stopRunning];
//    _captureInput = nil;
//}

#pragma mark - func
- (void)deleteButtonClick:(int)index {
    _deleteIndex = index;
    [self getOneAnchorData];
}

- (void)videoWithAnchor:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag-1000;
    if (index > _anchors.count-1) {
        return;
    }
    homePageListHandle *handle = self.anchors[index];
    NSInteger t_id = handle.t_id;
    [self clickedVideoWithId:t_id];
}

- (void)clickedVideoWithId:(NSInteger)anchorId {
    [[ChatLiveManager shareInstance] getVideoChatAutographWithOtherId:(int)anchorId type:1 fail:nil];
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
