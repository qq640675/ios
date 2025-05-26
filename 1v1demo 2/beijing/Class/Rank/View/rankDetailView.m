//
//  rankDetailView.m
//  beijing
//
//  Created by zhou last on 2018/10/6.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "rankDetailView.h"
#import "YLBasicView.h"

@implementation rankDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)cordius
{
    [self.headImgView.layer setCornerRadius:25.];
    [self.headImgView setClipsToBounds:YES];
    
    [self.whiteBgView.layer setCornerRadius:5.];
    [self.whiteBgView setClipsToBounds:YES];
    
    [YLBasicView topRightAngleBottomCorner:self.blueBgView firstCorner:UIRectCornerTopLeft secondCorner:UIRectCornerTopRight radius:5.];
}

@end
