//
//  YLConstraint.h
//  beijing
//
//  Created by zhou last on 2018/6/27.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface YLConstraint : NSObject

+ (void)masConstraint:(UIView *)view x:(float)x y:(float)y w:(float)w h:(float)h;

+ (void)masConstraint:(UIView *)view centerx:(UIView *)centerView  y:(float)y w:(float)w h:(float)h;

@end
