//
//  YLBrushGigft.h
//  presentAnimation
//
//  Created by zhou last on 2018/8/9.
//  Copyright © 2018年 许博. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GiftModel.h"


@interface YLBrushGigft : NSObject

+ (instancetype)sharedInstance;

- (GiftModel *)modelHeadImage:(UIImage *)headImage name:(NSString *)name giftName:(NSString *)giftName gifImage:(UIImage *)gifImage count:(int)count;

- (void)brushUserId:(NSString *)userId model:(GiftModel *)model view:(UIView *)selfView;

@end
