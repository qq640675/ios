//
//  imLoginExtension.h
//  beijing
//
//  Created by zhou last on 2018/7/31.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface imLoginExtension : NSObject

typedef void (^IMLoginBlock)(BOOL isSuccess);


+ (void)loginWithIMSDK:(int)userId block:(IMLoginBlock)block;

@end
