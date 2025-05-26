//
//  SLDateHelper.h
//  Qiaqia
//
//  Created by yiliaogao on 2019/6/27.
//  Copyright © 2019 yiliaogaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLDateHelper : NSObject


/**
 获取当前年

 @return 返回年
 */
+ (NSInteger)getDateCurrentYear;


/**
 获取当前月

 @return 返回月
 */
+ (NSInteger)getDateCurrentMonth;

/**
 获取年月日

 @return 年月日字符串
 */
+ (NSString *)getDateCurrentYearMonthDay;


/**
 获取当前时间戳

 @return 时间戳字符串
 */
+ (NSString *)getNowTimeTimestamp;


/**
 im时间

 @param date 时间
 @return 时间字符串
 */
+ (NSString *)getMessageTimeWithDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
