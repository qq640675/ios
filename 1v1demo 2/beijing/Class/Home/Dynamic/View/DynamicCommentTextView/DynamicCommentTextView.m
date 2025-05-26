//
//  DynamicCommentTextView.m
//  beijing
//
//  Created by yiliaogao on 2019/1/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicCommentTextView.h"

@implementation DynamicCommentTextView

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
    self.backgroundColor = KWHITECOLOR;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, .5)];
    lineView.backgroundColor = XZRGB(0xe1e1e1);
    [self addSubview:lineView];
    
    self.textView = [[SLPlaceHolderTextView alloc] initWithFrame:CGRectMake(5, 5, App_Frame_Width-95, 40)];
    self.textView.font = PingFangSCFont(15.0);
    self.textView.placeholder = @"快给主播评论一个吧～";
    self.textView.placeholderColor = XZRGB(0x868686);
    self.textView.textColor = XZRGB(0x868686);
    self.textView.delegate = self;
    self.textView.scrollEnabled = NO;
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.backgroundColor = KWHITECOLOR;
    [self addSubview:self.textView];
    
    UIButton *sendBtn = [UIManager initWithButton:CGRectZero text:@"发布" font:15 textColor:UIColor.whiteColor normalBackGroudImg:nil highBackGroudImg:nil selectedBackGroudImg:nil];
    sendBtn.backgroundColor = [XZRGB(0xAE4FFD) colorWithAlphaComponent:0.7];
    [sendBtn addTarget:self action:@selector(clickedSendBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(85, 49));
    }];
}

- (void)clickedSendBtn {
    if (_clickedSendBtnBlock && _textView.text.length > 0) {
        _clickedSendBtnBlock(_textView.text);
        [self endEditing:YES];
        self.textView.text = nil;
        [self upSelfCGRectSize];
    } else {
        [self endEditing:YES];
    }
}

#pragma mark -
#pragma mark - Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (_fTextWidth == 0) {
        _fTextWidth = textView.frame.size.width;
        
    }
    /*本身View 大小*/
    CGRect rect = self.frame;
    rect.size.height = self.textView.frame.size.height+10;
    rect.origin.y = rect.origin.y-(rect.size.height-self.frame.size.height);
    self.frame = rect;
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    CGSize size   = [textView.text sizeWithAttributes:@{NSFontAttributeName:PingFangSCFont(15.0f)}];
    CGFloat width = size.width+10;
    
    if (width < self.textView.frame.size.width) {
        if (_bChanged) {
            
            [self upSelfCGRectSize];
        }
        self.bChanged = NO;
    }
    else {
        self.bChanged  = YES;
        [self upSelfCGRectSize];
    }
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //第三方换行
    if ([@"\r\r" isEqualToString:text]) {
        return NO;
    }
    
    if ([@"\n" isEqualToString:text]) {
        [self clickedSendBtn];
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark - 更新输入框、本身View大小
- (void)upSelfCGRectSize{
    [UIView animateWithDuration:.3 animations:^{
        /*textView 大小*/
        CGRect bounds  = self.textView.bounds;
        CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
        CGSize newSize = [self.textView sizeThatFits:maxSize];
        
        self.textView.frame = CGRectMake(5, 5, self.fTextWidth, newSize.height);
        
        /*本身View 大小*/
        CGRect rect = self.frame;
        rect.size.height = self.textView.frame.size.height+10;
        rect.origin.y = rect.origin.y-(rect.size.height-self.frame.size.height);
        self.frame = rect;
        
        
        
    }];
}

@end
