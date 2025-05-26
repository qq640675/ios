//
//  AuthenticationVideoViewController.m
//  beijing
//
//  Created by 黎 涛 on 2019/10/9.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "AuthenticationVideoViewController.h"
#import "LXTAlertView.h"
#import "HVideoViewController.h"
#import <AVKit/AVKit.h>
#import "YLUploadVideoManager.h"
#import "ToolManager.h"

@interface AuthenticationVideoViewController ()
{
    UILabel *tipLabel;
}

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, copy) NSString *videoImagePath;
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, strong) NSURL *defaultUrl; //原视频url  需删除缓存

@property (nonatomic, strong) AVPlayer *avplayer;
@property (nonatomic, strong) UIView *playerView;

@end

@implementation AuthenticationVideoViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"视频认证";
    [self setSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

#pragma mark - subViews
- (void)setSubViews {
    
    _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, App_Frame_Width/2)];
//    _coverImageView.image = [UIImage imageNamed:@"HomePgae_speed_bg"];
    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    _coverImageView.backgroundColor = XZRGB(0xebebeb);
    _coverImageView.userInteractionEnabled = YES;
    _coverImageView.layer.masksToBounds = YES;
    [self.view addSubview:_coverImageView];
    UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo)];
    [_coverImageView addGestureRecognizer:playTap];
    
    _addBtn = [UIManager initWithButton:CGRectMake((App_Frame_Width-55)/2, (App_Frame_Width/2-55)/2, 55, 55) text:@"" font:1 textColor:nil normalImg:@"rz_video_img" highImg:nil selectedImg:nil];
    [_addBtn addTarget:self action:@selector(cameraUpload) forControlEvents:UIControlEventTouchUpInside];
    [_coverImageView addSubview:_addBtn];
    
    tipLabel = [UIManager initWithLabel:CGRectMake(15, CGRectGetMaxY(_coverImageView.frame), App_Frame_Width-30, 50) text:[NSString stringWithFormat:@"请正对摄像头，大声朗读以下内容：\n你好，我在新游山的ID是%d，快来找我聊天吧！", [YLUserDefault userDefault].t_id+10000] font:15 textColor:XZRGB(0x333333)];
    tipLabel.backgroundColor = UIColor.whiteColor;
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.numberOfLines = 2;
    tipLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:tipLabel];
    
    UIButton *btn = [ToolManager defaultMutableColorButtonWithFrame:CGRectMake((App_Frame_Width-290)/2, CGRectGetMaxY(_coverImageView.frame)+150, 290, 40) title:@"提 交" isCycle:YES];
    [btn addTarget:self action:@selector(uploadVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    _playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    _playerView.backgroundColor = UIColor.blackColor;
    _playerView.hidden = YES;
    [[[UIApplication sharedApplication] keyWindow] addSubview:_playerView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pause)];
    [_playerView addGestureRecognizer:tap];
}

#pragma mark - upload video
- (void)cameraUpload {
    HVideoViewController *videoVC = [[NSBundle mainBundle] loadNibNamed:@"HVideoViewController" owner:nil options:nil].lastObject;
    videoVC.HSeconds = 15;//设置可录制最长时间
    videoVC.labelTipTitle.text = @"按住拍摄15s自拍小视频";
    videoVC.isAuth = YES;
    videoVC.tipString = tipLabel.text;
    videoVC.takeBlock = ^(id item, UIImage *coverImage, NSUInteger sec, NSUInteger size) {
        if ([item isKindOfClass:[NSURL class]]) {
            //视频
            self.defaultUrl = (NSURL *)item;
            self.coverImageView.image = coverImage;
            self.videoPath = [SLHelper tempVideoFilePathWithExtension];
            self.videoImagePath = [SLHelper tempImageFilePathWithExtension:coverImage];
            
            NSURL *newVideoUrl = [NSURL fileURLWithPath:self.videoPath];
            [SLHelper convertVideoQuailtyWithInputURL:(NSURL *)item outputURL:newVideoUrl completeHandler:nil];
        } else {
            //图片
            
        }
    };
    videoVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:videoVC animated:YES completion:nil];
}

#pragma mark - play
- (void)playVideo {
    if (self.videoPath == nil) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.playerView.hidden = NO;
    }];
    
    AVPlayerItem *avplayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:self.videoPath]];
    _avplayer = [AVPlayer playerWithPlayerItem:avplayerItem];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_avplayer];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
    [self.playerView.layer addSublayer:layer];
    [_avplayer play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avplayer.currentItem];
}

- (void)pause {
    [_avplayer pause];
    _avplayer = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.playerView.hidden = YES;
    }];
}


#pragma mark - func
- (void)uploadVideo {
    if (self.videoPath == nil) {
        [SVProgressHUD showInfoWithStatus:@"请上传10s自拍短视频"];
        return;
    }
    [SVProgressHUD show];
    [YLNetworkInterface getVoideSignBlock:^(NSString *token) {
        if (token.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"上传视频失败"];
            self.view.userInteractionEnabled = YES;
            return ;
        }
        
        //上传视频
        [[YLUploadVideoManager shareInstance] uploadVideoWithPath:self.videoPath coverPath:self.videoImagePath signature:token finishBlock:^(TXPublishResult *publishResult) {
            if (publishResult.retCode == 0) {
                [self commitWithFileUrl:publishResult.videoURL];
            } else {
                [SVProgressHUD showInfoWithStatus:@"上传视频失败"];
                self.view.userInteractionEnabled = YES;
            }
        }];
    }];
}

- (void)commitWithFileUrl:(NSString *)fileUrl {
    NSDictionary *param = @{@"userId" : @([YLUserDefault userDefault].t_id),
                            @"t_user_video" : [NSString stringWithFormat:@"%@", fileUrl],
                            @"t_type":@"1"
    };
    [SVProgressHUD show];
    [YLNetworkInterface submitIdentificationDataWithParam:param success:^{
        [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:self.videoPath] error:nil];
        [[NSFileManager defaultManager] removeItemAtURL:self.defaultUrl error:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.playerView removeFromSuperview];
            [self.avplayer pause];
            self.avplayer = nil;
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
    
}

#pragma mark - dealloc
- (void)dealloc {
    [_playerView removeFromSuperview];
    [_avplayer pause];
    _avplayer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
