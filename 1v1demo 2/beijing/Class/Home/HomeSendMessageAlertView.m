//
//  HomeSendMessageAlertView.m
//  beijing
//
//  Created by 黎 涛 on 2020/9/14.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "HomeSendMessageAlertView.h"
#import "ToolManager.h"

@implementation HomeSendMessageAlertView

- (instancetype)initWithMessageArray:(NSArray *)array {
    self = [super init];
    if (self) {
        self.messageArray = array;
        self.backgroundColor = UIColor.clearColor;
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        [self setSubViews];
    }
    return self;
}

#pragma mark - subViews
- (void)setSubViews {
    CGFloat bottomSafeHeight = SafeAreaTopHeight-49;
    CGFloat bgViewHeight = 400+bottomSafeHeight;
    CGFloat grayHeight = APP_Frame_Height-bgViewHeight;
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, grayHeight)];
    grayView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
    [self addSubview:grayView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [grayView addGestureRecognizer:tap];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, grayHeight, App_Frame_Width, bgViewHeight)];
    bgView.backgroundColor = UIColor.whiteColor;
    [self addSubview:bgView];
    
    UIButton *titleBtn = [UIManager initWithButton:CGRectMake((App_Frame_Width-150)/2, 10, 150, 50) text:@"打招呼" font:24 textColor:XZRGB(0x333333) normalImg:@"message_hi" highImg:nil selectedImg:nil];
    titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleBtn.userInteractionEnabled = NO;
    [titleBtn setImagePosition:0 spacing:8];
    [bgView addSubview:titleBtn];
    
    UIButton *closeBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-50, 10, 50, 50) text:@"" font:1 textColor:nil normalImg:@"message_close" highImg:nil selectedImg:nil];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];
    
    UIButton *sendBtn = [UIManager initWithButton:CGRectMake((App_Frame_Width-250)/2, bgView.height-bottomSafeHeight-46-17, 250, 46) text:@"发送" font:18 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    sendBtn.backgroundColor = KDEFAULTCOLOR;
    sendBtn.layer.masksToBounds = YES;
    sendBtn.layer.cornerRadius = sendBtn.height/2;
    [sendBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sendBtn];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, App_Frame_Width, bgView.height-70-80-bottomSafeHeight)];
    _scrollView.backgroundColor = UIColor.whiteColor;
    _scrollView.showsVerticalScrollIndicator = NO;
    [bgView addSubview:_scrollView];
    
    CGFloat y = 0;
    
    for (int i = 0; i < self.messageArray.count; i ++) {
        NSDictionary *dic = self.messageArray[i];
        NSString *text = [NSString stringWithFormat:@"%@", dic[@"t_content"]];
        CGFloat labelHeight = [ToolManager getHeightWithText:text font:[UIFont systemFontOfSize:14] maxWidth:_scrollView.width]+20;
        if (labelHeight < 50) {
            labelHeight = 50;
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y, _scrollView.width, labelHeight)];
        view.backgroundColor = UIColor.whiteColor;
        view.tag = 1000+i;
        [_scrollView addSubview:view];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
        [view addGestureRecognizer:tap];
        
        UILabel *label = [UIManager initWithLabel:CGRectMake(15, 0, _scrollView.width-30, view.height) text:text font:14 textColor:XZRGB(0x333333)];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 3;
        label.backgroundColor = UIColor.clearColor;
        [view addSubview:label];
        if (i == 0) {
            self.selectedMessageId = [NSString stringWithFormat:@"%@", dic[@"t_id"]];
            view.backgroundColor = XZRGB(0xe5e5e5);
        }
        
        y = CGRectGetMaxY(view.frame);
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, labelHeight-1, _scrollView.width, 1)];
        line.backgroundColor = XZRGB(0xebebeb);
        [view addSubview:line];
    }
    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 1)];
//    line.backgroundColor = XZRGB(0xebebeb);
//    [_scrollView addSubview:line];
    
    _scrollView.contentSize = CGSizeMake(App_Frame_Width, y);
}

#pragma mark - func
- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)viewTap:(UITapGestureRecognizer *)tap {
    for (int i = 0; i < self.messageArray.count; i ++) {
        UIView *view = (UIView *)[_scrollView viewWithTag:1000+i];
        view.backgroundColor = UIColor.whiteColor;
    }
    
    UIView *view = (UIView *)tap.view;
    view.backgroundColor = XZRGB(0xe5e5e5);
    
    NSInteger index = tap.view.tag-1000;
    if (self.messageArray.count > index) {
        NSDictionary *dic = self.messageArray[index];
        self.selectedMessageId = [NSString stringWithFormat:@"%@", dic[@"t_id"]];
    }
}

- (void)sendMessage:(UIButton *)sender {
    NSLog(@"_______id:%@", self.selectedMessageId);
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    [YLNetworkInterface sendIMToUserMesWithMessage:self.selectedMessageId success:^{
        [self removeFromSuperview];
    }];
}


@end
