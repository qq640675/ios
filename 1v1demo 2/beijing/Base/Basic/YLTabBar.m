//
//  YLTabBar.m
//  beijing
//
//  Created by yiliaogao on 2019/2/18.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "YLTabBar.h"

@implementation YLTabBar

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
    self.translucent = NO;
    
    self.centerView = [[YLTabbarCenterView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width/5, SafeAreaBottomHeight+30)];
    [self addSubview:_centerView];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = 49;

    self.centerView.center = CGPointMake(width * 0.5, height * 0.5);
    self.centerView.y = -30;

    int index = 0;

    CGFloat tabBarButtonW = width / 5;
    CGFloat tabBarButtonH = 49;
    CGFloat tabBarButtonY = 0;

    for (UIView *tabBarButton in self.subviews) {

        if (![NSStringFromClass(tabBarButton.class) isEqualToString:@"UITabBarButton"]) continue;

        CGFloat tabBarButtonX = index * tabBarButtonW;

        tabBarButton.frame = CGRectMake(tabBarButtonX, tabBarButtonY, tabBarButtonW, tabBarButtonH);

        index++;
    }
    
    [self bringSubviewToFront:self.centerView];

}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (self.isHidden == NO) { // 当前界面 tabBar显示
        
        CGPoint newPoint = [self convertPoint:point toView:self.centerView];
        
        if ( [self.centerView pointInside:newPoint withEvent:event]) { // 点 属于按钮范围
            return self.centerView.centerBtn;
            
        }else{
            return [super hitTest:point withEvent:event];
        }
    }
    else {
        return [super hitTest:point withEvent:event];
    }
}

@end
