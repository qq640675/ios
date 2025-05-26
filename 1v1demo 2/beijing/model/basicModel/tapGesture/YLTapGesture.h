//
//  YLTapGesture.h
//  beijing
//
//  Created by zhou last on 2018/6/26.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface YLTapGesture : NSObject

+ (void)tapGestureTarget:(id)selfTarget sel:(SEL)tapAction view:(UIView *)view;

+ (void)addTaget:(id)selfTarget sel:(SEL)tapAction view:(UIButton *)button;

@end
