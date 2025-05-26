//
//  UIManager.m
//  beijing
//
//  Created by yiliaogao on 2018/12/25.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "UIManager.h"

@implementation UIManager

/*UILabel*/
+ (UILabel *)initWithLabel:(CGRect)rect text:(NSString *)str font:(CGFloat)fontSize textColor:(UIColor *)color{
    UILabel *lb = [[UILabel alloc] initWithFrame:rect];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = PingFangSCFont(fontSize);
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = color;
    if ([str isKindOfClass:[NSString class]]) {
        if ([str containsString:@"null"]) {
            lb.text = @"";
        } else {
            lb.text = str;
        }
    } else {
        lb.text = @"";
    }
    return lb;
}

/*UIButton setImage*/
+ (UIButton *)initWithButton:(CGRect)rect text:(NSString *)title font:(CGFloat)fontSize textColor:(UIColor *)color normalImg:(NSString *)nImg highImg:(NSString *)hImg selectedImg:(NSString *)sImg{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    btn.titleLabel.font = PingFangSCFont(fontSize);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    if (nImg) {
        [btn setImage:[UIImage imageNamed:nImg] forState:UIControlStateNormal];
    }
    if (hImg) {
        [btn setImage:[UIImage imageNamed:hImg] forState:UIControlStateHighlighted];
    }
    if (sImg) {
        [btn setImage:[UIImage imageNamed:sImg] forState:UIControlStateSelected];
    }
    btn.backgroundColor = [UIColor clearColor];
    return btn;
}

/*UIButton setBackGroundImage*/
+ (UIButton *)initWithButton:(CGRect)rect text:(NSString *)title font:(CGFloat)fontSize textColor:(UIColor *)color normalBackGroudImg:(NSString *)nImg highBackGroudImg:(NSString *)hImg selectedBackGroudImg:(NSString *)sImg{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    if (nImg) {
        [btn setBackgroundImage:[UIImage imageNamed:nImg] forState:UIControlStateNormal];
    }
    if (hImg) {
        [btn setBackgroundImage:[UIImage imageNamed:hImg] forState:UIControlStateHighlighted];
    }
    if (sImg) {
        [btn setBackgroundImage:[UIImage imageNamed:sImg] forState:UIControlStateSelected];
    }
    return btn;
}

+ (void)minePageLineWithY:(CGFloat)y superView:(UIView *)superView {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(3, y, App_Frame_Width, 4)];
    line.backgroundColor = XZRGB(0xf2f3f7);
    [superView addSubview:line];
}



@end
