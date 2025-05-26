//
//  ZYTimeStamp.h
//  ZYSqlite3Demo
//
//  Created by Mac on 2018/4/20.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYTimeStamp : NSObject

//时间转时间戳
+ (NSString *)getTimestampFromTime;

//时间戳转时间
+ (NSString *)getTimeFromTimestamp:(NSString *)timeStamp;

//date 转时间戳
+ (NSString *)getTimestampFromDate:(NSDate *)date;

//年月日
+ (NSString *)getDatetampFromTime;

//返回时间str
+ (NSString *)getDateStrFromeTime;

//userDefault 通讯录里的时间戳保存与读取
+ (NSString *)getTimeStampUserDefault;

+ (void)saveTimeStampUserDefault:(NSString *)timeStamp;

//nsdate ->nsstring
+ (NSString *)nsdateToNSString:(NSDate *)date;

//秒转换成时分秒
+(NSString *)getMMSSFromSS:(NSString *)totalTime;

//判断是不是同一分钟 同一分钟不显示时间
+ (BOOL)judgeSaveMinute:(NSString *)lastMsg nowMsg:(NSString *)nowMsg;


+ (NSString *)achieveDayFormatByTimeString:(NSString *)timeString;

@end
