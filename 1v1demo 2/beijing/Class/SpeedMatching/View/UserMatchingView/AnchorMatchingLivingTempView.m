//
//  AnchorMatchingLivingTempView.m
//  beijing
//
//  Created by yiliaogao on 2019/2/22.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "AnchorMatchingLivingTempView.h"

@implementation AnchorMatchingLivingTempView

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
    UIImageView *cryImgView = [UIImageView new];
    cryImgView.image = [UIImage imageNamed:@"video_cry"];
    cryImgView.frame = CGRectMake(0, 0, 30, 30);
    [self addSubview:cryImgView];
    
    UILabel *cryContentLabel = [UILabel new];
    cryContentLabel.text = @"对方关闭了摄像头";
    cryContentLabel.textColor = KWHITECOLOR;
    cryContentLabel.font = [UIFont fontWithName:@"Arial" size:12];
    cryContentLabel.frame = CGRectMake(40, 5, 120, 20);
    [self addSubview:cryContentLabel];
    
}

@end
