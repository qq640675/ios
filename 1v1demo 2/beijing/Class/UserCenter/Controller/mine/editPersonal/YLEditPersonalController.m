//
//  YLEditPersonalController.m
//  beijing
//
//  Created by zhou last on 2018/6/19.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLEditPersonalController.h"
#import "DefineConstants.h"
#import <Masonry.h>
#import "YLCoverView.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "NSString+Extension.h"
#import "YLUploadImageExtension.h"
#import "UIAlertCon+Extension.h"
#import "YLChoosePicture.h"
#import "YLEPPickerController.h"
#import "YLImageLabel.h"
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import "YLEditPhoneController.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+Extension.h"
#import "BaseViewController.h"
#import "EditInfoViewController.h"
#import "DiscoverImageModel.h"
#import "MJExtension.h"
#import "ToolManager.h"
#import <CoreLocation/CoreLocation.h>
#import "YLNCertifyController.h"

typedef enum {
    YLCericationTypeNick, //昵称
    YLCericationTypeAge, //年龄
    YLCericationTypeHeight, //身高
    YLCericationTypeWeight, //体重
    YLCericationTypeMarriageM,//婚姻
    YLCericationTypeVocation, //职业
    YLCericationTypeCity, //城市
    YLCericationTypeAutograph, //个性签名
} YLCericationType;


#define keyWindowView [UIApplication sharedApplication].keyWindow

@interface YLEditPersonalController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    NSArray *tittleArray; //标题
    NSArray *apiNameArray;  //名称
    NSMutableArray *valueArray; //名称对应的值
    
    NSMutableDictionary *editDic;  //修改个人资料的zi di a
    NSString *coverStr;
    CLLocationManager *locManager;//位置
    
    UIView *headView;
}

@property (weak, nonatomic) IBOutlet UITableView *editPersonInfoTableView;
@property (nonatomic, strong) NSMutableArray    *coverModelImageArray;

@end

@implementation YLEditPersonalController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    editDic = [NSMutableDictionary dictionary];
    valueArray = [NSMutableArray array];
    tittleArray = @[@"昵称",@"年龄",@"身高",@"体重",@"婚姻",@"职业",@"城市",@""];
    apiNameArray = @[@"t_nickName",@"t_age",@"t_height",@"t_weight",@"t_marriage",@"t_vocation",@"t_city",@"t_autograph"];
    coverStr = @"";
    
    [self editPersonalInfoCustomUI];
//    [_editPersonInfoTableView reloadData];
    
    [self getDataWithUser];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark ---- customUI
- (void)editPersonalInfoCustomUI {
    [self addTableHeaderView];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 100+SafeAreaBottomHeight)];
    footerView.backgroundColor = UIColor.whiteColor;
    _editPersonInfoTableView.tableFooterView = footerView;
    
    UIButton *commitBtn = [ToolManager defaultMutableColorButtonWithFrame:CGRectMake((APP_FRAME_WIDTH-300)/2, 56, 300, 49) title:@"确认修改" isCycle:YES];
    [commitBtn addTarget:self action:@selector(commitButtonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:commitBtn];
}

#pragma mark - header
- (void)addTableHeaderView {
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 225)];
    headView.backgroundColor = UIColor.whiteColor;
    
    [YLNetworkInterface index:[YLUserDefault userDefault].t_id block:^(personalCenterHandle *handle) {
        [YLUserDefault saveRole:handle.t_role];
        [YLUserDefault saveVip:handle.t_is_vip];
        [YLUserDefault saveCity:handle.t_city];
        
        if (handle.t_sex == 1){
            
            
            
        }else{
           
            _editPersonInfoTableView.tableHeaderView = headView;
            
          
            
           
        }
        UILabel *tipL = [UIManager initWithLabel:CGRectMake(15, headView.height-85, App_Frame_Width-30, 80) text:@"注：必须上传本人清晰正面照，衣着不得过分暴露（如漏乳沟、肉色吊带、露肩装、露背装等）不得有故意搞怪表情（如吐舌头、诱惑等）不得用手机遮挡面部，否则不予通过。" font:11 textColor:XZRGB(0xEF1231)];
        tipL.textAlignment = NSTextAlignmentLeft;
        tipL.numberOfLines = 0;
        [headView addSubview:tipL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headView.height-3, APP_FRAME_WIDTH, 3)];
        line.backgroundColor = IColor(238, 238, 238);
        [headView addSubview:line];
        [self reloadHeaderView];
    }];
    
   
}

- (void)reloadHeaderView {
    [[YLCoverView shareInstance] addCoverView:headView selfVC:self block:^(UIImage *image) {

        [self uploadImage:image];

    } pictureArray:_coverModelImageArray action:@selector(editCoverButtonBeClicked:)];
  
}

- (void)uploadImage:(UIImage *)image {
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [[YLUploadImageExtension shareInstance] uploadImage:image uplodImageblock:^(NSString *backImageUrl) {
        [self postDataWithDiscoverImage:backImageUrl];
    }];
}

- (void)postDataWithDiscoverImage:(NSString *)imageUrl {
    NSInteger isFirst = 1;
    if (_coverModelImageArray.count == 0) {
        isFirst = 0;
    }
    [YLNetworkInterface uploadCoverImage:imageUrl isFirst:isFirst block:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        
        DiscoverImageModel *coverModel = [DiscoverImageModel new];
        coverModel.t_id = [dic[@"m_object"] integerValue];
        coverModel.t_first = isFirst;
        coverModel.t_img_url = imageUrl;
        
        [self.coverModelImageArray addObject:coverModel];
        [self reloadHeaderView];
        
        [SVProgressHUD showInfoWithStatus:@"上传成功"];
    }];
}

- (void)postDataWithMainDiscoverImage:(NSInteger)fileId {
    [YLNetworkInterface setMainCoverImage:fileId block:^(NSDictionary *dic) {
        for (DiscoverImageModel *model in self.coverModelImageArray) {
            if (model.t_id == fileId) {
                model.t_first = 0;
            } else {
                model.t_first = 1;
            }
        }
        [self reloadHeaderView];
    }];
}

- (void)editCoverButtonBeClicked:(UIButton *)sender
{
    if (sender.tag < 1000) {
        //设封面
        [LXTAlertView alertViewDefaultWithTitle:@"提示" message:@"是否设置为主封面" sureHandle:^{
            NSInteger index = sender.tag-100;
            DiscoverImageModel *model = self.coverModelImageArray[index];
            if (model.t_first == 1) {
                [self postDataWithMainDiscoverImage:model.t_id];
            }else{
                [SVProgressHUD showInfoWithStatus:@"已经是主封面"];
            }
        }];
    } else {
        //删除封面
        [LXTAlertView alertViewDefaultWithTitle:@"提示" message:@"是否删除封面" sureHandle:^{
            NSInteger index = sender.tag-1000;
            DiscoverImageModel *model = self.coverModelImageArray[index];
            if (model.t_first == 1) {
                [YLNetworkInterface deleteCoverImage:model.t_id block:^(NSDictionary *dic) {
                    [self.coverModelImageArray removeObject:model];
                    [self reloadHeaderView];
                }];
            }else{
                [SVProgressHUD showInfoWithStatus:@"主封面不能删除"];
            }
        }];
    }
}

#pragma mark - location
- (void)startLocation {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        locManager = [[CLLocationManager alloc] init];
        locManager.delegate = self;
        locManager.desiredAccuracy= kCLLocationAccuracyBest;
        [locManager requestWhenInUseAuthorization];
    } else if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        locManager = [[CLLocationManager alloc] init];
        locManager.delegate = self;
        locManager.desiredAccuracy= kCLLocationAccuracyBest;
    }else{
        [LXTAlertView alertViewDefaultWithTitle:@"温馨提示" message:@"定位服务未开启，请进入系统【设置】>【隐私】>【定位服务】中打开开关" sureHandle:^{
            [NSString openScheme:UIApplicationOpenSettingsURLString];
        }];
    }

    [locManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [manager stopUpdatingLocation];
    
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks,NSError *error)
     {
        CLPlacemark *placemark = placemarks.lastObject;
        NSString *city = [NSString stringWithFormat:@"%@", placemark.locality];
        self->valueArray[YLCericationTypeCity] = city;
        [self.editPersonInfoTableView reloadData];
        [self->editDic setValue:city  forKey:@"t_city"];
        NSLog(@"_____city :%@", city);
     }];
    
}

#pragma mark - net
- (void)getDataWithUser {
    WEAKSELF
    self.coverModelImageArray = [NSMutableArray array];
    [YLNetworkInterface getPersonalData:[YLUserDefault userDefault].t_id personalData:^(PersonalDataHandle *handle) {
        weakSelf.handle = handle;
        
        //封面
        for (NSDictionary *dic  in handle.coverList) {
            DiscoverImageModel *model = [DiscoverImageModel mj_objectWithKeyValues:dic];
            [self.coverModelImageArray addObject:model];
        }
        [self reloadHeaderView];
        [weakSelf getUserInfo];
        [self startLocation];
    }];

}

//获取用户的数据
- (void)getUserInfo {
    //昵称
    if (![NSString isNullOrEmpty:_handle.t_nickName]) {
        [valueArray addObject:_handle.t_nickName];
        [self->editDic setValue:_handle.t_nickName forKey:@"t_nickName"];
    } else {
        [valueArray addObject:@"请输入昵称(选填)"];
    }
    
    //年龄
    if (![NSString isNullOrEmpty:_handle.t_age]) {
        [valueArray addObject:[NSString stringWithFormat:@"%@岁",_handle.t_age]];
        [self->editDic setValue:_handle.t_age forKey:@"t_age"];
    }else{
        [valueArray addObject:@"20岁"];
        [self->editDic setValue:@"20" forKey:@"t_age"];
    }
    
    //身高
    if (![NSString isNullOrEmpty:_handle.t_height] ) {
        [valueArray addObject:[NSString stringWithFormat:@"%@cm",_handle.t_height]];
        [self->editDic setValue:_handle.t_height forKey:@"t_height"];
    } else {
        [valueArray addObject:@"160cm"];
        [self->editDic setValue:@"160" forKey:@"t_height"];
    }
    
    //体重
    if (![NSString isNullOrEmpty:_handle.t_weight] ) {
        [valueArray addObject:[NSString stringWithFormat:@"%@kg",_handle.t_weight]];
        [self->editDic setValue:_handle.t_weight forKey:@"t_weight"];
    } else {
        [valueArray addObject:@"40kg"];
        [self->editDic setValue:@"40" forKey:@"t_weight"];
    }
    
    //婚姻
    if (![NSString isNullOrEmpty:_handle.t_marriage]) {
        [valueArray addObject:_handle.t_marriage];
        [self->editDic setValue:_handle.t_marriage forKey:@"t_marriage"];
    } else {
        [valueArray addObject:@"保密"];
        [self->editDic setValue:@"保密" forKey:@"t_marriage"];
    }
    
    //职业
    if (![NSString isNullOrEmpty:_handle.t_vocation]) {
        [valueArray addObject:_handle.t_vocation];
        [self->editDic setValue:_handle.t_vocation forKey:@"t_vocation"];
    } else {
        [valueArray addObject:@"网红"];
        [self->editDic setValue:@"网红" forKey:@"t_vocation"];
    }
    
    //城市
    if (![NSString isNullOrEmpty:_handle.t_city] ) {
        [valueArray addObject:_handle.t_city];
        [self->editDic setValue:_handle.t_city forKey:@"t_city"];
    } else {
        [valueArray addObject:@"北京东城"];
        [self->editDic setValue:@"北京东城" forKey:@"t_city"];
    }
    
    //个性签名
    if (![NSString isNullOrEmpty:_handle.t_autograph] ) {
        [valueArray addObject:_handle.t_autograph];
    } else{
        [valueArray addObject:@"写下你的个性签名"];
    }
    
    [self.editPersonInfoTableView reloadData];
}

#pragma mark ---- tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return valueArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editPersonalInfoCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editPersonalInfoCell"];
        cell.clipsToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    cell.textLabel.text = tittleArray[indexPath.row];
    cell.textLabel.textColor = KDEFAULTBLACKCOLOR;
    
    UILabel *nameLabel = nil;
    
    if (nameLabel == nil) {
        nameLabel            = [UILabel new];
        nameLabel.textColor    = IColor(189, 189, 189);
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.numberOfLines = 2;
        [cell.contentView addSubview:nameLabel];
    }
    nameLabel.text = valueArray[indexPath.row];
    
    
    if (indexPath.row == YLCericationTypeAutograph) {
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = XZRGB(0x898989);
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(cell.contentView);
            make.right.mas_equalTo(-15);
        }];
    } else {
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.textColor = XZRGB(0x868686);
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(App_Frame_Width - 200 - 30);
            make.centerY.mas_equalTo(cell.contentView);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(21);
        }];
        
        UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width-25, 20, 8, 14)];
        nextImageView.image = IChatUImage(@"PersonCenter_next");
        [cell.contentView addSubview:nextImageView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == YLCericationTypeVocation) {
        //职业
        [self chooseType:YLEditPersonalTypeProfession row:indexPath.row];
    } else if (indexPath.row == YLCericationTypeMarriageM) {
        [self chooseType:YLEditPersonalTypeHunyin row:indexPath.row];
    } else if (indexPath.row == YLCericationTypeCity) {
        //城市
        [self chooseType:YLEditPersonalTypeCity row:indexPath.row];
    } else if(indexPath.row == YLCericationTypeHeight) {
        //身高
        [self chooseType:YLEditPersonalTypeHeight row:indexPath.row];
    } else if (indexPath.row == YLCericationTypeAge) {
        // 年龄
        [self chooseType:YLEditPersonalTypeAge row:indexPath.row];
    } else if (indexPath.row == YLCericationTypeWeight) {
        //体重
        [self chooseType:YLEditPersonalTypeWeight row:indexPath.row];
    } else {
        EditInfoViewController *editVC = [[EditInfoViewController alloc] init];
        NSString *name = apiNameArray[indexPath.row];
        NSString *content = @"";
        if (editDic[name]) {
            content = valueArray[indexPath.row];
        }
        if (indexPath.row == YLCericationTypeAutograph) {
            editVC.strTitle = @"个性签名";
        } else {
            editVC.strTitle = tittleArray[indexPath.row];
        }
        editVC.strContent = content;
        editVC.editFinishBlock = ^(NSString * _Nonnull editText) {
            [self->editDic setValue:editText forKey:name];
            self->valueArray[indexPath.row] = editText;
            [self->_editPersonInfoTableView reloadData];
        };
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

#pragma mark - func
- (void)chooseType:(YLEditPersonalType)type row:(NSInteger)row {
    [[YLEPPickerController shareInstance]customUI];
    
    [[YLEPPickerController shareInstance] reloadPickerViewData:type block:^(NSString *tittle) {
        self->valueArray[row] = tittle;
        NSString *name = self->apiNameArray[row];
        
        if (type == YLEditPersonalTypeHeight) {
            tittle = [tittle stringByReplacingOccurrencesOfString:@" cm" withString:@""];
            
        }else if (type == YLEditPersonalTypeWeight){
            tittle = [tittle stringByReplacingOccurrencesOfString:@" kg" withString:@""];
        }else if (type == YLEditPersonalTypeAge){
            tittle = [tittle stringByReplacingOccurrencesOfString:@" 岁" withString:@""];
        }
        
        [self->editDic setValue:tittle forKey:name];
        [self->_editPersonInfoTableView reloadData];
    }];
}

- (void)commitButtonBeClicked:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    
    [editDic setValue:[NSNumber numberWithInt:[YLUserDefault userDefault].t_id] forKey:@"userId"];
    
    if ([YLUserDefault userDefault].t_role == 1) {
        if (_coverModelImageArray.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"主播封面必传！"];
            return;
        }
    }
    
    [SVProgressHUD showWithStatus:@"修改资料中..."];

    [YLNetworkInterface updatePersonalData:self->editDic editblock:^(BOOL isSuccess) {
        if (isSuccess) {
            //更新IM头像和昵称
            
            [SLDefaultsHelper saveSLDefaults:self->editDic[@"t_nickName"] key:@"user_nick_name"];
            
            [[TIMFriendshipManager sharedInstance] modifySelfProfile:@{TIMProfileTypeKey_Nick:self->editDic[@"t_nickName"]} succ:nil fail:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}



@end
