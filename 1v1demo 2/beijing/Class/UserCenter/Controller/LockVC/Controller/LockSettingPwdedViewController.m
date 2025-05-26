//
//  LockSettingPwdedViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/11/14.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "LockSettingPwdedViewController.h"
#import "LockPwdTempView.h"

@interface LockSettingPwdedViewController ()

@property (weak, nonatomic) IBOutlet UILabel *oneLb;
@property (weak, nonatomic) IBOutlet UILabel *twoLb;
@property (weak, nonatomic) IBOutlet UILabel *threeLb;
@property (weak, nonatomic) IBOutlet UILabel *fourLb;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@end

@implementation LockSettingPwdedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"验证密码";
    _pwdTextField.tintColor = [UIColor clearColor];
    [_pwdTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_pwdTextField becomeFirstResponder];
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
    
    if ([_oldPwd isEqualToString:_pwdTextField.text]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [SLDefaultsHelper saveSLDefaults:_oldPwd key:@"lock_mode_pwd_key"];
        [SLDefaultsHelper saveSLDefaults:@"1" key:@"lock_mode_pwd_is_open_key"];
        [SVProgressHUD showInfoWithStatus:@"设置成功"];
        
        [self addViewWithLockPwdTempView];
        
    }
    
}

- (void)addViewWithLockPwdTempView {
    LockPwdTempView *lockTempView = [[LockPwdTempView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    lockTempView.tag = 10086;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:lockTempView];
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
