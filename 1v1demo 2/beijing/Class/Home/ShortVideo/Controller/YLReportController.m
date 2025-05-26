//
//  YLReportController.m
//  beijing
//
//  Created by zhou last on 2018/6/27.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLReportController.h"
#import "DefineConstants.h"
#import <Masonry.h>
#import "reportCell.h"
#import "UIAlertCon+Extension.h"
#import "YLChoosePicture.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "NSString+Extension.h"
#import <SVProgressHUD.h>
#import "YLUploadImageExtension.h"
#import <AVFoundation/AVFoundation.h>

#define appKeyWindow [UIApplication sharedApplication].keyWindow

@interface YLReportController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *reportArray;
    NSMutableArray *selStatusArray;
    NSMutableArray *uploadPicArray;
    
    NSString *reportContent;
    NSString *uploadImagePath;
    dispatch_group_t group;
    UIView *loadingView;
}
@property (weak, nonatomic) IBOutlet UITableView *reportTableView;

@property (weak, nonatomic) IBOutlet UIButton *reportButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnbottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopConstraint;



@end

@implementation YLReportController

- (instancetype)init
{
    if (self == [super init]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        UINavigationBar *bar = [UINavigationBar appearance];
//        bar.translucent = NO;
        bar.barTintColor = KWHITECOLOR;
        [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:IColor(48, 48, 49)}];
        
        selStatusArray = [NSMutableArray array];
        uploadPicArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self reportCustomUI];
}

#pragma mark ---- customUI
- (void)reportCustomUI
{
    
    if (IS_iPhone_4S || IS_iPhone_5)
    {
        _btnTopConstraint.constant = 32;
        _btnbottomConstraint.constant = 52;
    }
    
    [_reportButton.layer setCornerRadius:22.0];
    uploadImagePath = @"";
    reportContent   = @"";
    selStatusArray = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    self->reportArray = [NSMutableArray arrayWithObjects:@"黑屏看不到人",@"套路礼物",@"垃圾广告",@"低俗漏点",@"封面非本人",@"拉我去其他平台",@"播放视频", nil];
    
    [self.reportTableView reloadData];
}

#pragma mark ---- tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return reportArray.count;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 43;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 43;
    }else{
        return 75;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    headView.backgroundColor = IColor(237, 238, 239);
    
    UILabel *tittleLabel = [UILabel new];
    tittleLabel.textColor = IColor(49, 49, 50);
    if (section == 0) {
        tittleLabel.text = @"请告诉我们您想举报该直播的理由";
    }else{
        tittleLabel.text = @"上传证据";
    }
    tittleLabel.font = PingFangSCFont(14);
    [headView addSubview:tittleLabel];
    
    [tittleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(App_Frame_Width - 30.);
        make.height.mas_equalTo(42.);
    }];
    
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        reportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"reportCell" owner:nil options:nil] firstObject];
        }else{
            //删除cell的所有子视图
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        cell.reasonLabel.text = reportArray[indexPath.row];
        
        int selType = [selStatusArray[indexPath.row] intValue];
        if (selType == 0) {
            [cell.selImgView setImage:[UIImage imageNamed:@"report_Choosefor"]];
        }else{
            [cell.selImgView setImage:[UIImage imageNamed:@"report_Check"]];
        }
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportPictureCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reportPictureCell"];
        }else{
            //删除cell的所有子视图
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        [self pictureUpload:cell.contentView];
        
        return cell;
    }
}

#pragma mark ---- 上传图片布局
- (void)pictureUpload:(UIView *)contentView
{
    for (int index = 0; index < uploadPicArray.count; index ++) {
        UIButton *button = [self createButtonImage:uploadPicArray[index] frame:CGRectMake(15. + 65 * index, 12, 50., 50.)];
        //添加按钮
        [button.layer setCornerRadius:4.];
        [button setClipsToBounds:YES];
        [contentView addSubview:button];
    }
    
    if (IS_iPhone_5 || IS_iPhone_4S) {
        [self pictureArray:4 contentView:contentView];
    }else{
        [self pictureArray:5 contentView:contentView];
    }
}

- (UIButton *)createButtonImage:(UIImage *)image frame:(CGRect)frame
{
    UIButton  *button = [UIButton new];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = frame;
    //添加按钮
    
    return button;
}

- (void)pictureArray:(int)count contentView:(UIView *)contentView
{
    if (uploadPicArray.count < count) {
        UIButton *button = [self createButtonImage:[UIImage imageNamed:@"report_Uploadevidence"] frame:CGRectMake(15. + uploadPicArray.count * 65, 12, 50, 50)];
        [button addTarget:self action:@selector(choosePictureOrCameraButtonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
    }
}


#pragma mark ---- 选择图片或拍照
- (void)choosePictureOrCameraButtonBeClicked:(UIButton *)sender
{
    
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [UIAlertCon_Extension seeWeixinOrPhone:@"此功能会在上传你要举报该主播的照片截图证据服务中访问您的相机权限" type:UIAlertControllerStyleAlert controller:self delSel:^(UIAlertAction *okSel) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        } oktittle:@"去开启"];
    }else{
        [UIAlertCon_Extension alertViewChoosePictureOrCamera:@"上传你要举报该主播的照片截图证据"
                                                        type:UIAlertControllerStyleActionSheet
                                                  controller:self
                                               choosePicture:^(UIAlertAction *okSel)
         {
             [[YLChoosePicture shareInstance] choosePicture:self type:YLPickImageTypeAlbum pickBlock:^(UIImage *pickImage) {
                 [self->uploadPicArray addObject:pickImage];
                 
                 [self->_reportTableView reloadData];
             }];
         } camera:^(UIAlertAction *okSel) {
             [[YLChoosePicture shareInstance] choosePicture:self type:YLPickImageTypeCamera pickBlock:^(UIImage *pickImage) {
                 [self->uploadPicArray addObject:pickImage];
                 
                 [self->_reportTableView reloadData];
             }];
         }];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        int selType = [selStatusArray[indexPath.row] intValue];
        
        if (selType == 0) {
            selStatusArray[indexPath.row] = @"1";
        }else{
            selStatusArray[indexPath.row] = @"0";
        }
        [_reportTableView reloadData];
    }else{
    }
}


- (IBAction)reportButtonBeClicked:(id)sender {
    //举报内容
    [self getReportContent];
    
    if ([NSString isNullOrEmpty:reportContent]) {
        [SVProgressHUD showInfoWithStatus:@"请选择举报内容!"];
        return;
    }
    
    [self saveComplaint];
}

- (void)saveComplaint
{
    self->loadingView = [UIView new];
    self->loadingView.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
    self->loadingView.backgroundColor = KBLACKCOLOR;
    self->loadingView.alpha = .3;
    [appKeyWindow addSubview:self->loadingView];
    [SVProgressHUD showWithStatus:@"提交数据中"];
    
    //上传多张图片
    [[YLUploadImageExtension shareInstance] uploadKindsOfPictures:self->uploadPicArray block:^(NSString *backImageUrl) {

        [YLNetworkInterface saveComplaintUserId:[YLUserDefault userDefault].t_id coverUserId:self->_godId comment:self->reportContent img:self->uploadImagePath block:^(BOOL isSuccess) {
            [self->loadingView removeFromSuperview];
            [SVProgressHUD showInfoWithStatus:@"已举报,我们会在24小时内进行处理"];
            if (isSuccess) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
}

#pragma mark ---- 举报内容
- (void)getReportContent
{
    for (int index = 0; index < selStatusArray.count; index ++) {
        int sel = [selStatusArray[index] intValue];
        if (sel == 1) {
            if (reportContent.length == 0) {
                reportContent = [reportContent stringByAppendingString:reportArray[index]];
            }else{
                reportContent = [reportContent stringByAppendingString:[NSString stringWithFormat:@",%@",reportArray[index]]];
            }
        }
    }
}

@end
