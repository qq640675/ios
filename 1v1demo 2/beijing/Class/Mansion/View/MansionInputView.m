//
//  MansionInputView.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/8.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MansionInputView.h"

@implementation MansionInputView

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        CGFloat height = 55+(SafeAreaBottomHeight-49);
        self.frame = CGRectMake(0, APP_Frame_Height-height, App_Frame_Width, height);
        self.backgroundColor = UIColor.clearColor;
        [self setSubViews];
    }
    return self;
}

#pragma mark -subViews
- (void)setSubViews {
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _whiteView.alpha = 0;
    _whiteView.backgroundColor = UIColor.whiteColor;
    [self addSubview:_whiteView];
    
    UIView *tfBG = [[UIView alloc] initWithFrame:CGRectMake(15, 5, App_Frame_Width-135, 35)];
    tfBG.layer.masksToBounds = YES;
    tfBG.layer.cornerRadius = 17.5;
    tfBG.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
    [self addSubview:tfBG];
    
    _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, tfBG.width-30, 35)];
    _inputTextField.font = [UIFont systemFontOfSize:17];
    _inputTextField.textColor = UIColor.whiteColor;
    _inputTextField.returnKeyType = UIReturnKeySend;
    _inputTextField.delegate = self;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"一起聊聊~" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:_inputTextField.font}];
    _inputTextField.attributedPlaceholder = attrString;
    [tfBG addSubview:_inputTextField];
    
    _emojiBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-100, 5, 35, 35) text:@"" font:1 textColor:nil normalImg:@"mansion_room_emoji" highImg:nil selectedImg:nil];
    [_emojiBtn addTarget:self action:@selector(emojiButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_emojiBtn];
    
    _giftBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-50, 5, 35, 35) text:@"" font:1 textColor:nil normalImg:@"mansion_room_gift" highImg:nil selectedImg:nil];
    [_giftBtn addTarget:self action:@selector(giftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_giftBtn];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"发送内容不能为空"];
        return NO;
    }
    if (self.sendTextBlock) {
        self.sendTextBlock(textField.text);
    }
    return YES;
}

#pragma mark - func
- (void)emojiButtonClick {
    if (self.emojiButtonClickBlock) {
        self.emojiButtonClickBlock();
    }
}

- (void)giftButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    if (self.sendGiftButtonClickBlock) {
        self.sendGiftButtonClickBlock();
    }
}




@end
