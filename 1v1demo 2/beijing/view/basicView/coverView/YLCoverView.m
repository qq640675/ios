//
//  YLCoverView.m
//  beijing
//
//  Created by zhou last on 2018/6/19.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLCoverView.h"
#import <Masonry.h>
#import "DefineConstants.h"
#import "UIAlertCon+Extension.h"
#import "YLChoosePicture.h"
#import <UIButton+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import "DiscoverImageModel.h"

@interface YLCoverView ()

@property (nonatomic ,strong) UIViewController *selfViewController;
@property (nonatomic ,strong) UIScrollView *coverScrollView;
@property (nonatomic ,strong) UIButton *addCoverButton;
@property (nonatomic ,strong) YLChoosePictureBLOCK choosePictureBlcok;

@end


@implementation YLCoverView


- (instancetype)init
{
    if (self == [super init]) {
        [self coverScrollView];
        [self addCoverButton];
    }
    
    return self;
}

+ (id)shareInstance
{
    static YLCoverView *instance ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [YLCoverView new];
    });
    return instance;
}

- (void)addCoverView:(UIView *)headView selfVC:(UIViewController *)selfVC block:(YLChoosePictureBLOCK)block pictureArray:(NSMutableArray *)pictureArray action:(SEL)action
{
    _selfViewController = selfVC;
    _choosePictureBlcok = block;
    
    [headView addSubview:_coverScrollView];
    
    [self.coverScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(App_Frame_Width);
        make.height.mas_equalTo(130);
    }];
    
    for (UIView *view in [self.coverScrollView subviews]) {
        [view removeFromSuperview];
    }
    [self pictureUpload:self.coverScrollView array:pictureArray action:action];
}

//#pragma mark ---- 上传图片布局
- (void)pictureUpload:(UIView *)contentView array:(NSMutableArray *)array action:(SEL)action
{
    CGFloat width = 110;
    CGFloat height = 115;
    
    for (int index = 0; index < array.count; index ++) {
        DiscoverImageModel *model = array[index];
        UIImageView *coverIV = [[UIImageView alloc] initWithFrame:CGRectMake(15. + (width + 10) * index, 15, width, height)];
        coverIV.layer.masksToBounds = YES;
        coverIV.layer.cornerRadius = 2;
        coverIV.contentMode = UIViewContentModeScaleAspectFill;
        coverIV.tag = index;
        [coverIV sd_setImageWithURL:[NSURL URLWithString:model.t_img_url]];
        coverIV.userInteractionEnabled = YES;
        [contentView addSubview:coverIV];
        
//        UIButton *button = [self createButtonImage:nil frame:CGRectMake(15. + (width + 10) * index, 12, width, 115)];
//        [button sd_setImageWithURL:[NSURL URLWithString:model.t_img_url] forState:UIControlStateNormal];
//        button.tag = index;
//        [button addTarget:self.selfViewController action:action forControlEvents:UIControlEventTouchUpInside];
//        [button.layer setCornerRadius:4.];
//        [button setClipsToBounds:YES];
//        [contentView addSubview:button];
        
        if (model.t_first == 0) {
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, coverIV.height-15, width, 15)];
            lb.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
            lb.text = @"主封面";
            lb.textAlignment = NSTextAlignmentCenter;
            lb.font = [UIFont systemFontOfSize:10.0f];
            lb.textColor = [UIColor whiteColor];
            [coverIV addSubview:lb];
        } else {
            UIButton *setMainB = [UIManager initWithButton:CGRectMake((width-52)/2, height-18, 52, 15) text:@"设为封面" font:10 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
            setMainB.backgroundColor = XZRGB(0xFF8EEB);
            setMainB.layer.masksToBounds = YES;
            setMainB.layer.cornerRadius = setMainB.height/2;
            setMainB.tag = 100+index;
            [setMainB addTarget:self.selfViewController action:action forControlEvents:UIControlEventTouchUpInside];
            [coverIV addSubview:setMainB];
            
            UIButton *delB = [UIManager initWithButton:CGRectMake(width+coverIV.x-20, 0, 40, 30) text:@"" font:1 textColor:nil normalImg:@"cover_del" highImg:nil selectedImg:nil];
            delB.tag = 1000+index;
            [delB addTarget:self.selfViewController action:action forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:delB];
        }
    }
    
    _addCoverButton = [UIButton buttonWithType:0];
    _addCoverButton.frame = CGRectMake(15. + array.count * (width + 10), 15, width, height);
//    [_addCoverButton setImage:[UIImage imageNamed:@"uploadCover"] forState:UIControlStateNormal];
    [_addCoverButton setBackgroundImage:[UIImage imageNamed:@"uploadCover"] forState:0];
    [_addCoverButton addTarget:self action:@selector(addButtonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.coverScrollView addSubview:_addCoverButton];

    int maxCovers = 6; //最大封面数
    if (array.count < maxCovers) {
        _addCoverButton.hidden = NO;
        self.coverScrollView.contentSize = CGSizeMake(15. + (array.count+1) * (width + 10), 130);
    }else{
        _addCoverButton.hidden = YES;
        self.coverScrollView.contentSize = CGSizeMake(15. + array.count * (width + 10), 130);
    }
}



//- (UIButton *)createButtonImage:(UIImage *)image frame:(CGRect)frame
//{
//    UIButton  *button = [UIButton new];
//    [button setImage:image forState:UIControlStateNormal];
//    button.frame = frame;
//    //添加按钮
//
//    return button;
//}

#pragma mark ---- 上传封面的添加按钮
- (void)addButtonBeClicked:(UIButton *)sender
{
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [UIAlertCon_Extension seeWeixinOrPhone:@"此功能会在上传您的主播封面服务中访问您的相机权限" type:UIAlertControllerStyleAlert controller:self.selfViewController delSel:^(UIAlertAction *okSel) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        } oktittle:@"去开启"];
    }else{
        [UIAlertCon_Extension alertViewChoosePictureOrCamera:@"上传您的主播封面,以供主播页展示"
                                                        type:UIAlertControllerStyleActionSheet
                                                  controller:_selfViewController
                                               choosePicture:^(UIAlertAction *okSel)
         {
             [[YLChoosePicture shareInstance] choosePicture:self.selfViewController type:YLPickImageTypeAlbum pickBlock:^(UIImage *pickImage) {
                 self.choosePictureBlcok(pickImage);
             }];
         } camera:^(UIAlertAction *okSel) {
             [[YLChoosePicture shareInstance] choosePicture:self.selfViewController type:YLPickImageTypeCamera pickBlock:^(UIImage *pickImage) {
                 self.choosePictureBlcok(pickImage);
             }];
         }];
    };
}

- (UIScrollView *)coverScrollView {
    if (_coverScrollView == nil) {
        _coverScrollView = [UIScrollView new];
        _coverScrollView.showsVerticalScrollIndicator = NO;
        _coverScrollView.showsHorizontalScrollIndicator = YES;
    }
    
    return _coverScrollView;
}


@end
