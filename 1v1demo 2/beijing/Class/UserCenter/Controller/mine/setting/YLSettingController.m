//
//  YLSettingController.m
//  beijing
//
//  Created by zhou last on 2018/9/15.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLSettingController.h"
#import "DefineConstants.h"
#import "YLBasicView.h"
#import "YLTapGesture.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "WelcomeViewController.h"
#import "KJJPushHelper.h"
#import <SVProgressHUD.h>
#import "YLHelpCenterController.h"
#import "YLFeedbackController.h"
#import <Masonry.h>
#import "CachesManager.h"
#import "BlackListViewController.h"
#import "FullScreenNotView.h"
#import "NewMessageAlertView.h"
#import "LockSettingViewController.h"
#import "HelpCenterViewController.h"
#import "ToolManager.h"
#import "YLEditPaypassController.h"

@interface YLSettingController ()
{
    NSArray *titleArray;
    UIActivityIndicatorView *activityIndicator;
    UILabel *fileLabel;
}

@property (weak, nonatomic) IBOutlet UITableView *setTableView;

@end

@implementation YLSettingController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingCustomUI];

}


#pragma mark ---- customUI
- (void)settingCustomUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.setTableView.tableFooterView = [UIView new];
    
    titleArray = @[@"支付密码",@"私聊声音", @"私聊震动", @"群聊声音", @"群聊震动", @"未成年模式", @"版本号", @"清除缓存", @"意见反馈", @"用户协议", @"黑名单"];
    [_setTableView reloadData];
    _setTableView.bounces = NO;
    
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 100)];
    footerV.backgroundColor = UIColor.whiteColor;
    _setTableView.tableFooterView = footerV;
    
    UIButton *logoutBtn = [ToolManager defaultMutableColorButtonWithFrame:CGRectMake(80, 27, App_Frame_Width-160, 46) title:@"退出登录" isCycle:YES];
    [logoutBtn addTarget:self action:@selector(quitBtnBeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerV addSubview:logoutBtn];
}

#pragma mark ---- tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
        cell.textLabel.text = titleArray[indexPath.row];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.textLabel.textColor = XZRGB(0x171717);
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    if (indexPath.row == 0+1) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        UISwitch *openSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(App_Frame_Width - 70, 10, 60, 32.5)];
        openSwitch.onTintColor = XZRGB(0x0bceb0);
        [cell.contentView addSubview:openSwitch];
        [openSwitch setOn:[YLUserDefault userDefault].msgAudio];
        [openSwitch addTarget:self action:@selector(soundSwitchClick:) forControlEvents:UIControlEventValueChanged];
    } else if (indexPath.row == 1+1) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        UISwitch *openSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(App_Frame_Width - 70, 10, 60, 32.5)];
        openSwitch.onTintColor = XZRGB(0x0bceb0);
        [cell.contentView addSubview:openSwitch];
        [openSwitch setOn:[YLUserDefault userDefault].msgVibrate];
        [openSwitch addTarget:self action:@selector(shakeSwitchClick:) forControlEvents:UIControlEventValueChanged];
    } else if (indexPath.row == 2+1) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        UISwitch *openSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(App_Frame_Width - 70, 10, 60, 32.5)];
        openSwitch.onTintColor = XZRGB(0x0bceb0);
        [cell.contentView addSubview:openSwitch];
        [openSwitch setOn:[YLUserDefault userDefault].groupMsgAudio];
        [openSwitch addTarget:self action:@selector(groupSoundSwitchClick:) forControlEvents:UIControlEventValueChanged];
    } else if (indexPath.row == 3+1) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        UISwitch *openSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(App_Frame_Width - 70, 10, 60, 32.5)];
        openSwitch.onTintColor = XZRGB(0x0bceb0);
        [cell.contentView addSubview:openSwitch];
        [openSwitch setOn:[YLUserDefault userDefault].groupMsgVibrate];
        [openSwitch addTarget:self action:@selector(groupShakeSwitchClick:) forControlEvents:UIControlEventValueChanged];
    } else if (indexPath.row == 5+1) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];

        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        UILabel *versionLabel = [YLBasicView createLabeltext:[[CachesManager sharedManager] getAllTheCacheFileSize] size:PingFangSCFont(15) color:XZRGB(0xf554da) textAlignment:NSTextAlignmentRight];
        versionLabel.text = app_Version;
        [cell.contentView addSubview:versionLabel];
        [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(App_Frame_Width - 165);
            make.centerY.mas_equalTo(cell.contentView);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(20);
        }];
    }else if (indexPath.row == 6+1){
        [cell setAccessoryType:UITableViewCellAccessoryNone];

        //清除缓存
        float fileSize = [[CachesManager sharedManager] requestCachesFileSize];

        fileLabel = [YLBasicView createLabeltext:[[CachesManager sharedManager] getAllTheCacheFileSize] size:PingFangSCFont(15) color:XZRGB(0xf554da) textAlignment:NSTextAlignmentRight];
        [cell.contentView addSubview:fileLabel];
        [fileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(App_Frame_Width - 165);
            make.centerY.mas_equalTo(cell.contentView);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(20);
        }];
        
        if (fileSize > 0.01){
        }else{
            fileLabel.text = @"0 M";
        }
        
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        [cell.contentView addSubview:activityIndicator];
        //设置小菊花颜色
        activityIndicator.hidden = YES;
        
        [activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(App_Frame_Width - 45);
            make.centerY.mas_equalTo(cell.contentView);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        //设置背景颜色
        //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //未成年模式
        
        YLEditPaypassController *vc = [YLEditPaypassController new];
        vc.title = @"修改支付密码";
        
//        YLEditPaypassController *vc = [[YLEditPaypassController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 4+1) {
        //未成年模式
        LockSettingViewController *vc = [[LockSettingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 6+1) {
        //清除缓存
        float fileSize = [[CachesManager sharedManager] requestCachesFileSize];

        if (fileSize > 0.01) {
            activityIndicator.hidden = NO;
            fileLabel.hidden = YES;
            [activityIndicator startAnimating];
            
            [self clearCache];
        }else{
            [SVProgressHUD showInfoWithStatus:@"当前没有缓存可清理"];
        }
    }
//    else if (indexPath.row == 3) {
//        //用户帮助
//        HelpCenterViewController *vc = [[HelpCenterViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    else if (indexPath.row == 7+1) {
        //意见反馈
        YLFeedbackController *feedbackVC = [YLFeedbackController new];
        feedbackVC.title              = @"意见反馈";
        [self.navigationController pushViewController:feedbackVC animated:YES];
    } else if (indexPath.row == 8+1) {
        //用户协议
        YLHelpCenterController *vc = [YLHelpCenterController new];
        vc.title   = @"用户协议书";
        vc.urlPath = @"userment";
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 9+1) {
        //黑名单
        BlackListViewController *blackVC = [[BlackListViewController alloc] init];
        [self.navigationController pushViewController:blackVC animated:YES];
    }
}

- (void)soundSwitchClick:(UISwitch *)openSwitch {
    [YLUserDefault saveMsgAudio:![YLUserDefault userDefault].msgAudio];
}

- (void)shakeSwitchClick:(UISwitch *)openSwitch {
    [YLUserDefault saveMsgVibrate:![YLUserDefault userDefault].msgVibrate];
}

- (void)groupSoundSwitchClick:(UISwitch *)openSwitch {
    [YLUserDefault saveGroupMsgAudio:![YLUserDefault userDefault].groupMsgAudio];
}

- (void)groupShakeSwitchClick:(UISwitch *)openSwitch {
    [YLUserDefault saveGroupMsgVibrate:![YLUserDefault userDefault].groupMsgVibrate];
}

#pragma mark ---- 清除缓存
- (void)clearCache
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
       
       for (NSString *p in files) {
           NSError *error;
           NSString *path = [cachPath stringByAppendingPathComponent:p];
           
           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
           }
       }
        [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
    });
}

-(void)clearCacheSuccess
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showInfoWithStatus:@"清理成功"];

        [self->activityIndicator stopAnimating];
        [self.setTableView reloadData];
    });
}

#pragma mark ---- 退出登录
- (IBAction)quitBtnBeClicked:(id)sender {
    [YLNetworkInterface logout:[YLUserDefault userDefault].t_id block:^(BOOL isSuccess) {
        if (isSuccess) {
            [KJJPushHelper deleteAlias];
            
            [FullScreenNotView tearDownView];
            [NewMessageAlertView tearDownView];
            
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"T_TOKEN"];
            WelcomeViewController *loginVC = [WelcomeViewController new];
            self.view.window.rootViewController = loginVC;
            
            [[TIMManager sharedInstance] logout:nil fail:nil];
            [YLUserDefault saveUserDefault:@"0" t_id:@"0" t_is_vip:@"1" t_role:@"0"];
        }
    }];
}


@end
