//
//  DynamicAddressSearchView.m
//  beijing
//
//  Created by yiliaogao on 2019/1/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicAddressSearchView.h"
#import "DefineConstants.h"

@implementation DynamicAddressSearchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = XZRGB(0xedeced);
    
    UIButton *cancelBtn = [UIManager initWithButton:CGRectZero text:@"取消" font:15.0f textColor:KBLACKCOLOR normalImg:nil highImg:nil selectedImg:nil];
    cancelBtn.tag = 1;
    [cancelBtn addTarget:self action:@selector(clickedCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(self).offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 35));
    }];
    
    [self addSubview:self.searchTextField];
}

- (void)clickedCancelBtn {
    _searchTextField.text = nil;
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectDynamicAddressSearchViewWithCancel)]) {
        [_delegate didSelectDynamicAddressSearchViewWithCancel];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectDynamicAddressSearchViewWithSearch:)]) {
            [_delegate didSelectDynamicAddressSearchViewWithSearch:textField.text];
        }
    }
    return YES;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, self.width-20, 35)];
        _searchTextField.backgroundColor = KWHITECOLOR;
        _searchTextField.layer.cornerRadius = 5;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.font = PingFangSCFont(15.0f);
        _searchTextField.textColor = KBLACKCOLOR;
        _searchTextField.delegate = self;
        _searchTextField.placeholder = @"搜索附近位置";
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Dynamic_search"]];
        imageView.frame = CGRectMake(5, 5, 15, 15);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 25, 25)];
        [view addSubview:imageView];
        _searchTextField.leftView = view;
        
    }
    return _searchTextField;
}

@end
