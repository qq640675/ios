//
//  IndentiViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/7/13.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "IndentiViewController.h"
#import "personalCenterHandle.h"
#import "AuthenticationVideoViewController.h"
#import "YLEditPhoneController.h"
#import "AuthenticationPicViewController.h"

@interface IndentiViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tableView;
    NSArray *titleArr;
    NSMutableArray *subTitleArr;
}
//个人数据
@property (nonatomic, strong) personalCenterHandle      *personHandle;

@end

@implementation IndentiViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"身份认证";
    [self setSubViews];
    [self requestPeronalData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - net
- (void)requestPeronalData {
    [SVProgressHUD show];
    [YLNetworkInterface index:[YLUserDefault userDefault].t_id block:^(personalCenterHandle *handle) {
        self.personHandle = handle;
        
        NSString *videoIdentityStr;
        NSString *phoneIdentityStr;
        NSString *idcardIdentityStr;
        if (handle.videoIdentity == 1) {
            videoIdentityStr = @"已认证";
        } else if (handle.videoIdentity == 2) {
            videoIdentityStr = @"认证中";
        } else {
            videoIdentityStr = @"未认证";
        }
        
        if (handle.phoneIdentity == 1) {
            phoneIdentityStr = @"已认证";
        } else {
            phoneIdentityStr = @"未认证";
        }
        
        if (handle.idcardIdentity == 1) {
            idcardIdentityStr = @"已认证";
        } else if (handle.idcardIdentity == 2) {
            idcardIdentityStr = @"认证中";
        } else {
            idcardIdentityStr = @"未认证";
        }
        self->subTitleArr = [NSMutableArray arrayWithArray:@[videoIdentityStr, phoneIdentityStr, idcardIdentityStr]];
        
        [self->tableView reloadData];
    }];
}

#pragma maek - subViews
- (void)setSubViews {
    titleArr = @[@"视频认证", @"手机认证"];
    subTitleArr = [NSMutableArray arrayWithArray:@[@"未认证", @"未认证"]];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = [UIView new];
    tableView.dataSource = self;
    tableView.delegate = self;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.textColor = XZRGB(0x171717);
    }
    cell.textLabel.text = titleArr[indexPath.row];
    cell.detailTextLabel.text = subTitleArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([cell.detailTextLabel.text isEqualToString:@"已认证"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (_personHandle.videoIdentity == 1) return;
        // 视频认证
        AuthenticationVideoViewController *videoVC = [[AuthenticationVideoViewController alloc] init];
        [self.navigationController pushViewController:videoVC animated:YES];
    } else if (indexPath.row == 1) {
        if (_personHandle.phoneIdentity == 1) return;
        // 手机认证
        YLEditPhoneController *editPhoneVC = [YLEditPhoneController new];
        editPhoneVC.title = @"手机号认证";
        [self.navigationController pushViewController:editPhoneVC animated:YES];
    } else if (indexPath.row == 2) {
        if (_personHandle.idcardIdentity == 1) return;
        // 身份认证
        AuthenticationPicViewController *picVC = [[AuthenticationPicViewController alloc] init];
        [self.navigationController pushViewController:picVC animated:YES];
    }
}



@end
