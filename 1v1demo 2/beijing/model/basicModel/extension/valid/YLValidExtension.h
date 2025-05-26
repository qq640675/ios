//
//  YLValidExtension.h
//  beijing
//
//  Created by zhou last on 2018/7/2.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLValidExtension : NSObject

//判断是否是手机号码
+ (BOOL)validMobileNumber:(NSString *)mobileNum;

+ (BOOL)judgeMicrophone;

@end
