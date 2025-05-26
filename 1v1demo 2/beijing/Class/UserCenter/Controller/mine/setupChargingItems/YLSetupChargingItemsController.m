//
//  YLSetupChargingItemsController.m
//  beijing
//
//  Created by zhou last on 2018/6/30.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLSetupChargingItemsController.h"
#import "DefineConstants.h"
#import "YLNetworkInterface.h"
#import "anchorChargeSetupHandle.h"
#import "YLEPPickerController.h"
#import "YLCordius.h"
#import <SVProgressHUD.h>
#import "YLUserDefault.h"
#import "YLBasicView.h"
#import "SLPickerViewController.h"

typedef enum {
    YLChargeTypeVideo = 0, //视频
    YLChargeTypeText, //文字
    YLChargeTypePhone, //查看手机号
    YLChargeTypeWeixin,  //微信
    YLChargeTypePrivatePhoto,//私密照片
    YLChargeTypePrivateVideo,//私密视频
}YLChargeType;

@interface YLSetupChargingItemsController ()<UITableViewDelegate,UITableViewDataSource,SLPickerViewControllerDelegate>
{
    NSArray *itemTittleArray;
    NSMutableArray *coinsArray;
    anchorChargeSetupHandle *achargeSetupHandle;
}

@property (weak, nonatomic) IBOutlet UITableView *chargeItemTableView;
//提交
@property (weak, nonatomic) IBOutlet UIButton *admitButton;
//加入QQ群背景图
@property (weak, nonatomic) IBOutlet UIView *qqGroupBgView;

@property (nonatomic, strong) SLPickerViewController    *pickerViewController;

@property (nonatomic, strong) NSMutableArray   *videoCoinsArray;

@property (nonatomic, strong) NSMutableArray   *voiceCoinsArray;

@property (nonatomic, strong) NSMutableArray   *textCoinsArray;

//@property (nonatomic, strong) NSMutableArray   *phoneCoinsArray;
//
//@property (nonatomic, strong) NSMutableArray   *weixinCoinsArray;
//
//@property (nonatomic, strong) NSMutableArray *qqCoinsArray;

@property (nonatomic, assign) NSInteger         actionRow;


@end

@implementation YLSetupChargingItemsController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self getAnchorChargeSetup];
    
    [self getDataWithAnthorChargeList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChargeCustomUI];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.pickerViewController.view];
    _pickerViewController.view.hidden = YES;
}

#pragma mark ---- customUI
- (void)setupChargeCustomUI
{
    itemTittleArray = @[@"视频聊天",@"语音聊天",@"文字私聊"];
    [_chargeItemTableView reloadData];
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.chargeItemTableView.tableFooterView = footerView;
    
    [YLCordius codius:_admitButton radian:4.];
    
    self.qqGroupBgView.backgroundColor = [UIColor colorWithPatternImage:[YLBasicView imageCompressFitSizeScale:[UIImage imageNamed:@"charge_bg"] targetSize:CGSizeMake(App_Frame_Width, 280)]];
}

#pragma mark ---- api请求
- (void)getAnchorChargeSetup
{
    coinsArray = [NSMutableArray array];
    dispatch_queue_t queue = dispatch_queue_create("获取主播收费设置", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        //获取主播收费设置
        [YLNetworkInterface getAnchorChargeSetup:[YLUserDefault userDefault].t_id block:^(anchorChargeSetupHandle *handle) {
                self->achargeSetupHandle = handle;
                
                if (handle) {
                    [self->coinsArray addObject:self->achargeSetupHandle.t_video_gold];
                    [self->coinsArray addObject:self->achargeSetupHandle.t_voice_gold];
                    [self->coinsArray addObject:self->achargeSetupHandle.t_text_gold];
                    
//                    if ([self->achargeSetupHandle.t_phone_gold isEqualToString:@"0"]) {
//                        [self->coinsArray addObject:@"私密(不公开)"];
//                    }else{
//                        [self->coinsArray addObject:self->achargeSetupHandle.t_phone_gold];
//                    }
//                    if ([self->achargeSetupHandle.t_weixin_gold isEqualToString:@"0"]) {
//                        [self->coinsArray addObject:@"私密(不公开)"];
//                    }else{
//                        [self->coinsArray addObject:self->achargeSetupHandle.t_weixin_gold];
//                    }
//                    if ([self->achargeSetupHandle.t_qq_gold isEqualToString:@"0"]) {
//                        [self->coinsArray addObject:@"私密(不公开)"];
//                    }else{
//                        [self->coinsArray addObject:self->achargeSetupHandle.t_qq_gold];
//                    }
                    
                }else{
                    [SVProgressHUD showInfoWithStatus:@"收费设置数据获取失败"];
                }
                
                [self.chargeItemTableView reloadData];
        }];
    });
}

- (void)getDataWithAnthorChargeList {
    
    self.videoCoinsArray = [NSMutableArray new];
    self.voiceCoinsArray = [NSMutableArray array];
    self.textCoinsArray  = [NSMutableArray new];
//    self.phoneCoinsArray = [NSMutableArray new];
//    self.weixinCoinsArray= [NSMutableArray new];
//    self.qqCoinsArray = [NSMutableArray array];
    
    WEAKSELF
    [YLNetworkInterface getAnthorChargeList:[YLUserDefault userDefault].t_id block:^(NSMutableArray *listArray) {
        for (anchorChargeSetupHandle *handle in listArray) {
            if (handle.t_project_type == 5) {
                [weakSelf.videoCoinsArray addObjectsFromArray:[handle.t_extract_ratio componentsSeparatedByString:@","]];
            }else if (handle.t_project_type == 6){
                [weakSelf.textCoinsArray addObjectsFromArray:[handle.t_extract_ratio componentsSeparatedByString:@","]];
            }
//            else if (handle.t_project_type == 7){
//                [weakSelf.phoneCoinsArray addObject:@"私密(不公开)"];
//                [weakSelf.phoneCoinsArray addObjectsFromArray:[handle.t_extract_ratio componentsSeparatedByString:@","]];
//            }else if (handle.t_project_type == 8){
//                [weakSelf.weixinCoinsArray addObject:@"私密(不公开)"];
//                [weakSelf.weixinCoinsArray addObjectsFromArray:[handle.t_extract_ratio componentsSeparatedByString:@","]];
//            }
            else if (handle.t_project_type == 12) {
                [weakSelf.voiceCoinsArray addObjectsFromArray:[handle.t_extract_ratio componentsSeparatedByString:@","]];
            }
//            else if (handle.t_project_type == 13) {
//                [weakSelf.qqCoinsArray addObject:@"私密(不公开)"];
//                [weakSelf.qqCoinsArray addObjectsFromArray:[handle.t_extract_ratio componentsSeparatedByString:@","]];
//            }
        }

    }];
}

- (void)didSLPickerViewControllerSureBtn:(NSInteger)row {
    _pickerViewController.view.hidden = YES;
    NSString *selectedString = nil;
    switch (_actionRow) {
        case 0: {
            selectedString = _videoCoinsArray[row];
        }
            break;
        case 1: {
            selectedString = _voiceCoinsArray[row];
        }
            break;
        case 2: {
            selectedString = _textCoinsArray[row];
        }
            break;
//        case 3: {
//            selectedString = _phoneCoinsArray[row];
//        }
//            break;
//        case 4: {
//            selectedString = _weixinCoinsArray[row];
//        }
//            break;
//        case 5: {
//            selectedString = _qqCoinsArray[row];
//        }
//            break;
        default:
            break;
    }
    coinsArray[_actionRow] = selectedString;
    
    [_chargeItemTableView reloadData];
}

- (void)didSLPickerViewControllerCancelBtn {
    _pickerViewController.view.hidden = YES;
}

#pragma mark ---- tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return coinsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chargeItemCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chargeItemCell"];
    }else{
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    cell.textLabel.text = itemTittleArray[indexPath.row];
    cell.textLabel.textColor = KBLACKCOLOR;
    cell.textLabel.font = PingFangSCFont(16);
    
    UILabel *coinsLbabel = [UILabel new];
    coinsLbabel.frame = CGRectMake(App_Frame_Width - 140, 0, 90, 45);
    coinsLbabel.textAlignment = NSTextAlignmentRight;
    coinsLbabel.textColor = IColor(115, 116, 117);
    coinsLbabel.font = PingFangSCFont(15);
    [cell.contentView addSubview:coinsLbabel];
    
    if (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5) {
        if ([coinsArray[indexPath.row] isEqualToString:@"私密(不公开)"]) {
            coinsLbabel.text = @"私密";
        }else{
            coinsLbabel.text = [NSString stringWithFormat:@"%@ 金币",coinsArray[indexPath.row]];
        }
    }else{
        coinsLbabel.text = [NSString stringWithFormat:@"%@ 金币",coinsArray[indexPath.row]];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            self.pickerViewController.pickerDataArray = _videoCoinsArray;
            
            break;
        case 1:
            self.pickerViewController.pickerDataArray = _voiceCoinsArray;
            
            break;
        case 2:
            self.pickerViewController.pickerDataArray = _textCoinsArray;

            break;
//        case 3:
//            self.pickerViewController.pickerDataArray = _phoneCoinsArray;
//
//            break;
//        case 4:
//            self.pickerViewController.pickerDataArray = _weixinCoinsArray;
//
//            break;
//        case 5:
//            self.pickerViewController.pickerDataArray = _qqCoinsArray;
//
//            break;
        default:
            break;
    }
    _pickerViewController.view.hidden = NO;
    _pickerViewController.selectedRow = 0;
    [_pickerViewController.pickerView selectRow:0 inComponent:0 animated:NO];
    _actionRow = indexPath.row;
}

- (IBAction)setchargeAdmitButtonClicked:(id)sender {
    
    if (!achargeSetupHandle) {
        [SVProgressHUD showInfoWithStatus:@"请刷新数据在试！"];
        
        return;
    }
    
    if (coinsArray.count < 3) {
        [SVProgressHUD showInfoWithStatus:@"您还没选择收费标准！"];
        
        return;
    }
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    muDic[@"userId"] = [NSString stringWithFormat:@"%@",achargeSetupHandle.t_user_id];
    muDic[@"t_video_gold"]= coinsArray[0];
    muDic[@"t_voice_gold"] = coinsArray[1];
    muDic[@"t_text_gold"] = coinsArray[2];
    
//    if ([coinsArray[3] isEqualToString:@"私密(不公开)"]) {
//        muDic[@"t_phone_gold"] = @"0";
//    }else{
//        muDic[@"t_phone_gold"] = coinsArray[3];
//    }
//    if ([coinsArray[4] isEqualToString:@"私密(不公开)"]) {
//        muDic[@"t_weixin_gold"] = @"0";
//    }else{
//        muDic[@"t_weixin_gold"] = coinsArray[4];
//    }
//    if ([coinsArray[5] isEqualToString:@"私密(不公开)"]) {
//        muDic[@"t_qq_gold"] = @"0";
//    }else{
//        muDic[@"t_qq_gold"] = coinsArray[5];
//    }
    
    [YLNetworkInterface updateAnchorChargeSetup:muDic block:^(BOOL isSuccess) {
        if (isSuccess) {

            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (SLPickerViewController *)pickerViewController {
    if (!_pickerViewController) {
        _pickerViewController  = [[SLPickerViewController alloc] init];
        _pickerViewController.view.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        _pickerViewController.pickerDataUnit = @"金币";
        _pickerViewController.delegate = self;
        [_pickerViewController setupUI];
    }
    return _pickerViewController;
}

@end
