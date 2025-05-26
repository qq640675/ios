//
//  LockPwdViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/11/14.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "LockPwdViewController.h"

@interface LockPwdViewController ()

@property (weak, nonatomic) IBOutlet UILabel *oneLb;
@property (weak, nonatomic) IBOutlet UILabel *twoLb;
@property (weak, nonatomic) IBOutlet UILabel *threeLb;
@property (weak, nonatomic) IBOutlet UILabel *fourLb;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@end

@implementation LockPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"关闭未成年模式";
    _pwdTextField.tintColor = [UIColor clearColor];
    [_pwdTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_pwdTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *tempView = [window viewWithTag:10086];
    tempView.hidden = YES;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *tempView = [window viewWithTag:10086];
    tempView.hidden = NO;
    NSString *isOpen = (NSString *)[SLDefaultsHelper getSLDefaults:@"lock_mode_pwd_is_open_key"];
    if ([isOpen isEqualToString:@"0"]) {
        tempView.hidden = YES;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= 4) {
        //输入的字符个数大于4，则无法继续输入，返回NO表示禁止输入
        return NO;
    } else {
        return YES;
    }
}


- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length == 0) {
        _oneLb.text = @"";
        _twoLb.text = @"";
        _threeLb.text = @"";
        _fourLb.text  = @"";
    } else if (textField.text.length == 1) {
        _oneLb.text = @"●";
        _twoLb.text = @"";
        _threeLb.text = @"";
        _fourLb.text  = @"";
    } else if (textField.text.length == 2) {
        _oneLb.text = @"●";
        _twoLb.text = @"●";
        _threeLb.text = @"";
        _fourLb.text  = @"";
    } else if (textField.text.length == 3) {
        _oneLb.text = @"●";
        _twoLb.text = @"●";
        _threeLb.text = @"●";
        _fourLb.text  = @"";
    } else {
        _oneLb.text = @"●";
        _twoLb.text = @"●";
        _threeLb.text = @"●";
        _fourLb.text  = @"●";
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)clickedNextBtn:(id)sender {
    
    NSString *pwd = (NSString *)[SLDefaultsHelper getSLDefaults:@"lock_mode_pwd_key"];
    
    if ([pwd isEqualToString:_pwdTextField.text]) {
        [SLDefaultsHelper saveSLDefaults:@"" key:@"lock_mode_pwd_key"];
        [SLDefaultsHelper saveSLDefaults:@"0" key:@"lock_mode_pwd_is_open_key"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [SVProgressHUD showInfoWithStatus:@"设置成功"];
    } else {
        [SVProgressHUD showInfoWithStatus:@"密码错误"];
    }
    
    
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
