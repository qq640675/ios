//
//  EditInfoViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/5/6.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "EditInfoViewController.h"

@interface EditInfoViewController ()

@property (nonatomic, strong) UITextField   *editTextField;

@end

@implementation EditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = [NSString stringWithFormat:@"编辑%@",_strTitle];
    
    UIButton *naviRightBtn = [UIManager initWithButton:CGRectMake(0, 0, 44, 44) text:@"完成" font:16.0f textColor:XZRGB(0xAE4FFD) normalImg:nil highImg:nil selectedImg:nil];
    [naviRightBtn addTarget:self action:@selector(clickedNaviRightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:naviRightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.editTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, SafeAreaTopHeight+30, App_Frame_Width-20, 40)];
    _editTextField.text = _strContent;
    _editTextField.placeholder = [NSString stringWithFormat:@"请输入%@",_strTitle];
    [_editTextField becomeFirstResponder];
    [self.view addSubview:_editTextField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, SafeAreaTopHeight+75, App_Frame_Width-20, 1)];
    lineView.backgroundColor = XZRGB(0xebebeb);
    [self.view addSubview:lineView];
    
}

- (void)clickedNaviRightBtn {
    if (_editTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"内容不能为空"];
        return;
    }
    if (_editFinishBlock) {
        _editFinishBlock(_editTextField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
