//
//  SLPhotoLockView.m
//  beijing
//
//  Created by yiliaogao on 2018/12/28.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "SLPhotoLockView.h"

@implementation SLPhotoLockView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //毛玻璃视图
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.tag = 99;
        [self addSubview:effectView];
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.top.and.bottom.equalTo(self).offset(0);
        }];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 14)];
        imageView.image = [UIImage imageNamed:@"Dynamic_list_lock"];
        imageView.tag = 10;
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UILabel *timeLb = [UIManager initWithLabel:CGRectZero text:nil font:12.0f textColor:[UIColor whiteColor]];
        timeLb.textAlignment = NSTextAlignmentLeft;
        timeLb.tag = 100;
        [self addSubview:timeLb];
        [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-5);
            make.right.equalTo(self).offset(-5);
            make.height.offset(15);
        }];
        
    }
    return self;
}




@end
