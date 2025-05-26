//
//  SLWaitingView.m
//  GY_Teacher
//
//  Created by apple on 2017/4/27.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "SLWaitingView.h"

@implementation SLWaitingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithUI];
    }
    return self;
}


- (void)initWithUI {
    UIActivityIndicatorView*    indicatorView   = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.center        = self.center;
    self.indicatorView          = indicatorView;
    [self addSubview:self.indicatorView];
}



@end
