//
//  YLTabbarCenterView.m
//  beijing
//
//  Created by yiliaogao on 2019/2/18.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "YLTabbarCenterView.h"

@implementation YLTabbarCenterView

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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = [UIImage imageNamed:@"tabbar_mansion"];
    imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self).offset(12);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    self.centerLb = [UIManager initWithLabel:CGRectZero text:@"府邸" font:10.0f textColor:XZRGB(0x32434d)];
    _centerLb.font = [UIFont boldSystemFontOfSize:10.0f];
    [self addSubview:_centerLb];
    [_centerLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(64);
        make.size.mas_equalTo(CGSizeMake(self.width, 15));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    self.centerBtn = [UIManager initWithButton:CGRectMake(0, 0, self.width, 79) text:nil font:12.0f textColor:[UIColor whiteColor] normalImg:nil highImg:nil selectedImg:nil];
    [self addSubview:self.centerBtn];
    
    
}



@end
