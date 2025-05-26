//
//  MessageSettingViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/19.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MessageSettingViewController.h"
#import "BaseView.h"
#import "YLNetworkInterface.h"

@interface MessageSettingViewController ()<UITableViewDataSource>
{
    UITableView *tableView;
    NSArray *titleArr;
}
@property (nonatomic, assign) BOOL videoSwitch;//视频开关
@property (nonatomic, assign) BOOL voiceSwitch;//语音开关
@property (nonatomic, assign) BOOL chatSwitch;//私信开关

@end

@implementation MessageSettingViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"消息设置";
    [self setSubView];
    [self getDataWithPerson];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- Net
- (void)getDataWithPerson {
    [SVProgressHUD show];
    [YLNetworkInterface index:[YLUserDefault userDefault].t_id block:^(personalCenterHandle *handle) {
        [SVProgressHUD dismiss];
        //勿扰
        if (handle.t_is_not_disturb == 1) {
            //关闭
            self.videoSwitch = 1;
        } else {
            //开启
            self.videoSwitch = 0;
        }
        // 语音聊天
        if (handle.t_voice_switch == 1) {
            self.voiceSwitch = 1;
        } else {
            self.voiceSwitch = 0;
        }
        // 私信聊天
        if (handle.t_text_switch == 1) {
            self.chatSwitch = 1;
        } else {
            self.chatSwitch = 0;
        }
        
        [self->tableView reloadData];
    }];
}

#pragma mark - subViews
- (void)setSubView {
    titleArr = @[@"视频聊天", @"语音聊天", @"私信聊天", @"私信声音", @"私信震动"];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = [UIView new];
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.rowHeight = 52.5;
    [self.view addSubview:tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = XZRGB(0x171717);
        
        UISwitch *openSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(App_Frame_Width - 70, 10, 60, 32.5)];
        openSwitch.onTintColor = XZRGB(0x0bceb0);
        openSwitch.tag = 555;
        [cell.contentView addSubview:openSwitch];
    }
    cell.textLabel.text = titleArr[indexPath.row];
    
    UISwitch *openSwitch = [cell viewWithTag:555];
    
    if (indexPath.row == 0) {
        [openSwitch setOn:self.videoSwitch];
        [openSwitch addTarget:self action:@selector(videoSwitchClick:) forControlEvents:UIControlEventValueChanged];
    } else if (indexPath.row == 1) {
        [openSwitch setOn:self.voiceSwitch];
        [openSwitch addTarget:self action:@selector(voiceSwitchClick:) forControlEvents:UIControlEventValueChanged];
    } else if (indexPath.row == 2) {
        [openSwitch setOn:self.chatSwitch];
        [openSwitch addTarget:self action:@selector(messageSwitchClick:) forControlEvents:UIControlEventValueChanged];
    } else if (indexPath.row == 3) {
        [openSwitch setOn:[YLUserDefault userDefault].msgAudio];
        [openSwitch addTarget:self action:@selector(soundSwitchClick:) forControlEvents:UIControlEventValueChanged];
    } else if (indexPath.row == 4) {
        [openSwitch setOn:[YLUserDefault userDefault].msgVibrate];
        [openSwitch addTarget:self action:@selector(shakeSwitchClick:) forControlEvents:UIControlEventValueChanged];
    }
    return cell;
}

#pragma mark - func
- (void)videoSwitchClick:(UISwitch *)openSwitch {
    [self clickedSwitchBtn:openSwitch index:11111];
}

- (void)voiceSwitchClick:(UISwitch *)openSwitch {
    [self clickedSwitchBtn:openSwitch index:22222];
}

- (void)messageSwitchClick:(UISwitch *)openSwitch {
    [self clickedSwitchBtn:openSwitch index:33333];
}

- (void)soundSwitchClick:(UISwitch *)openSwitch {
    [YLUserDefault saveMsgAudio:![YLUserDefault userDefault].msgAudio];
}

- (void)shakeSwitchClick:(UISwitch *)openSwitch {
    [YLUserDefault saveMsgVibrate:![YLUserDefault userDefault].msgVibrate];
}

- (void)clickedSwitchBtn:(UISwitch *)sender index:(NSInteger)index {
    int isOn = sender.isOn;
    int type = 1;
    NSString *tip = @"";
    if (index == 11111) {
        type = 1;
        tip = @"关闭视频聊天后,您将收不到视频邀请";
    } else if (index == 22222) {
        type = 2;
        tip = @"关闭语音聊天后,您将收不到语音邀请";
    } else if (index == 33333) {
        type = 3;
        tip = @"关闭私信聊天后,您将收不到私聊消息";
    }
    [self switchButtonClick:isOn tip:tip type:type];
}

- (void)switchButtonClick:(int)isOn tip:(NSString *)tip type:(int)type{
    [SVProgressHUD show];
    [YLNetworkInterface setUpChatSwitchType:type switchType:isOn block:^(BOOL isSuccess) {
        if (isSuccess) {
            [SVProgressHUD dismiss];
            if (isOn == NO) {
                [SVProgressHUD showInfoWithStatus:tip];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            }
            if (type == 1) {
                self.videoSwitch = isOn;
            } else if (type == 2) {
                self.voiceSwitch = isOn;
            } else if (type == 3) {
                self.chatSwitch = isOn;
            }
        }
    }];
}




@end
