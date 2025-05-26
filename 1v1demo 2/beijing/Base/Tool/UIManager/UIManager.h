//
//  UIManager.h
//  beijing
//
//  Created by yiliaogao on 2018/12/25.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefineConstants.h"

@interface UIManager : NSObject

+ (UILabel *)initWithLabel:(CGRect)rect
                      text:(NSString *)str
                      font:(CGFloat)fontSize
                 textColor:(UIColor *)color;

+ (UIButton *)initWithButton:(CGRect)rect
                        text:(NSString *)title
                        font:(CGFloat)fontSize
                   textColor:(UIColor *)color
                   normalImg:(NSString *)nImg
                     highImg:(NSString *)hImg
                 selectedImg:(NSString *)sImg;

+ (UIButton *)initWithButton:(CGRect)rect
                        text:(NSString *)title
                        font:(CGFloat)fontSize
                   textColor:(UIColor *)color
          normalBackGroudImg:(NSString *)nImg
            highBackGroudImg:(NSString *)hImg
        selectedBackGroudImg:(NSString *)sImg;

+ (void)minePageLineWithY:(CGFloat)y superView:(UIView *)superView;

@end

