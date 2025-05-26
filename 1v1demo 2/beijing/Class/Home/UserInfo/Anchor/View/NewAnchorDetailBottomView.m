//
//  NewAnchorDetailBottomView.m
//  beijing
//
//  Created by 黎 涛 on 2020/4/14.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "NewAnchorDetailBottomView.h"
#import "UIButton+LXMImagePosition.h"

@implementation NewAnchorDetailBottomView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowColor = UIColor.blackColor.CGColor;
        self.layer.shadowRadius = 6;
        [self setSubViews];
    }
    return self;
}

#pragma mark - UI
- (void)setSubViews {
    
    NSArray *imgArr = @[@"info_item_chat",@"info_item_gift", @"info_item_video"];
    CGFloat width = App_Frame_Width/(imgArr.count);
    for (int i = 0; i < imgArr.count; i ++) {
        UIButton *btn = [UIManager initWithButton:CGRectMake(width*i, 0, width, 80) text:@"" font:15 textColor:XZRGB(0x3f3b48) normalImg:imgArr[i] highImg:nil selectedImg:nil];
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if ( i == 0) {
            btn.frame = CGRectMake(10, 0, 90, 60);
        } else if (i == 1) {
            btn.frame = CGRectMake(100, 0, 90, 60);
        } else if (i == 2) {
            btn.frame = CGRectMake(App_Frame_Width-170, 0, 150, 60);
        }
    }
}

#pragma mark - func
- (void)bottomButtonClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    NSInteger index = sender.tag-1000;
    if (self.bottomViewButtonClick) {
        self.bottomViewButtonClick(index);
    }
}




@end
