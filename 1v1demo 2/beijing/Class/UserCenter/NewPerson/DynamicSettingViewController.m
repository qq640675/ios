//
//  DynamicSettingViewController.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/19.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "DynamicSettingViewController.h"
#import "MeDynamicViewController.h"
#import "MePhotoViewController.h"
#import "BaseView.h"

@interface DynamicSettingViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *titleArr;
}

@end

@implementation DynamicSettingViewController

#pragma makr - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"发布";
    [self setSubView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - subViews
- (void)setSubView {
    titleArr = @[@"动态", @"视频", @"照片"];
    if ([YLUserDefault userDefault].t_role == 0) {
        titleArr = @[@"视频", @"照片"];
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-SafeAreaTopHeight) style:UITableViewStylePlain];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = XZRGB(0x171717);
    }
    cell.textLabel.text = titleArr[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = titleArr[indexPath.row];
    if ([title isEqualToString:@"动态"]) {
        MeDynamicViewController *vc = [[MeDynamicViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"视频"]) {
        MePhotoViewController *photoVC = [[MePhotoViewController alloc] init];
        photoVC.type = 1;
        [self.navigationController pushViewController:photoVC animated:YES];
    } else if ([title isEqualToString:@"照片"]) {
        MePhotoViewController *photoVC = [[MePhotoViewController alloc] init];
        photoVC.type = 0;
        [self.navigationController pushViewController:photoVC animated:YES];
    }
}


@end
