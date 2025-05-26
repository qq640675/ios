//
//  ZYTimeStamp.m
//  ZYSqlite3Demo
//
//  Created by Mac on 2018/4/20.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ZYTimeStamp.h"

@implementation ZYTimeStamp


#pragma mark --- 将时间转换成时间戳
+ (NSString *)getTimestampFromTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *nowtimeStr = [formatter stringFromDate:datenow];//----------将nsdate按formatter格式转成nsstring
    // 时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];

    return timeSp;
}


#pragma mark ---- date 转时间戳
+ (NSString *)getTimestampFromDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
//    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *nowtimeStr = [formatter stringFromDate:date];//----------将nsdate按formatter格式转成nsstring
    // 时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    return timeSp;
}

#pragma mark ---- nsdate ->nsstring
+ (NSString *)nsdateToNSString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

#pragma mark ---- 年月日
+ (NSString *)getDatetampFromTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
//    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSDate *date = [NSDate date];
    NSString *strDate = [formatter stringFromDate:date];
    
    NSDate *birthdayDate = [formatter dateFromString:strDate];
    NSString *nowtimeStr = [formatter stringFromDate:birthdayDate];//----------将nsdate按formatter格式转成nsstring
    // 时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[birthdayDate timeIntervalSince1970]];
    
    return timeSp;
}


#pragma mark ---- 返回时间str
+ (NSString *)getDateStrFromeTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    formatter.dateFormat = @"yyyy-MM-dd";

    NSString *time = [formatter stringFromDate:[NSDate date]];
    
    return time;
}

+ (NSString *)getTimeStampUserDefault
{
   return  [[NSUserDefaults standardUserDefaults] objectForKey:@"timeStampOfAddressBook"];
}

+ (void)saveTimeStampUserDefault:(NSString *)timeStamp
{
    [[NSUserDefaults standardUserDefaults] setObject:timeStamp forKey:@"timeStampOfAddressBook"];
}


#pragma mark ---- 将时间戳转换成时间
+ (NSString *)getTimeFromTimestamp:(NSString *)timeStamp{
    //将对象类型的时间转换为NSDate类型
    //    double time = 1504667976;
    double timeStampDouble = [timeStamp doubleValue];
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:timeStampDouble];
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

#pragma mark ---- 秒转换成时分秒
+(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02d",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02d",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02d",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}


//判断是不是同一分钟 同一分钟不显示时间
+ (BOOL)judgeSaveMinute:(NSString *)lastMsg nowMsg:(NSString *)nowMsg
{
    if ([lastMsg isEqualToString:nowMsg]) {
        return NO;
    }else{
        return YES;
    }
}


+ (NSString *)achieveDayFormatByTimeString:(NSString *)timeString;
{
    if (!timeString || timeString.length < 10) {
        return @"时间未知";
    }
    //将时间戳转为NSDate类
    NSTimeInterval time = [[timeString substringToIndex:10] doubleValue];
    NSDate *inputDate=[NSDate dateWithTimeIntervalSince1970:time];
    //
    NSString *lastTime = [self compareDate:inputDate];
    return lastTime;
}

+ (NSString *)compareDate:(NSDate *)inputDate{
    
    //修正8小时的差时
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger goalInterval = [zone secondsFromGMTForDate: inputDate];
    NSDate *date = [inputDate  dateByAddingTimeInterval: goalInterval];
    
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSInteger localInterval = [zone secondsFromGMTForDate: currentDate];
    NSDate *localeDate = [currentDate  dateByAddingTimeInterval: localInterval];
    
    //今天／昨天／前天
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSDate *today = localeDate;
    NSDate *yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    NSDate *beforeOfYesterday = [yesterday dateByAddingTimeInterval: -secondsPerDay];
    
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *beforeOfYesterdayString = [[beforeOfYesterday description] substringToIndex:10];
    
    //今年
    NSString *toYears = [[today description] substringToIndex:4];
    
    //目标时间拆分为 年／月
    NSString *dateString = [[date description] substringToIndex:10];
    NSString *dateYears = [[date description] substringToIndex:4];
    
    NSString *dateContent;
    if ([dateYears isEqualToString:toYears]) {//同一年
        //今 昨 前天的时间
        NSString *time = [[date description] substringWithRange:(NSRange){11,5}];
        //其他时间
        NSString *time2 = [[date description] substringWithRange:(NSRange){5,11}];
        if ([dateString isEqualToString:todayString]){
            //今天
            dateContent = [NSString stringWithFormat:@"%@",time];
            return dateContent;
        } else if ([dateString isEqualToString:yesterdayString]){
            //昨天
            dateContent = [NSString stringWithFormat:@"昨天"];
            return dateContent;
        }else{
            //前天
            dateContent = [NSString stringWithFormat:@"%@",time2];
            return dateContent;
        }
    }else{
        //不同年，显示具体日期：如，2008-11-11
        return dateString;
    }
}



@end
