//
//  liveSuffiView.m
//  beijing
//
//  Created by zhou last on 2018/12/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "liveSuffiView.h"

@implementation liveSuffiView

- (void)cordius
{
    [self.alphaView.layer setCornerRadius:5.];
    [self.alphaView setClipsToBounds:YES];
    
    [self.insuffBgView.layer setCornerRadius:5.];
    [self.insuffBgView setClipsToBounds:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
