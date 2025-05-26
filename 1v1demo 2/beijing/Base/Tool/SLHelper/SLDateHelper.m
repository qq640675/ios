//
//  SLDateHelper.m
//  Qiaqia
//
//  Created by yiliaogao on 2019/6/27.
//  Copyright © 2019 yiliaogaoke. All rights reserved.
//

#import "SLDateHelper.h"

@implementation SLDateHelper

+ (NSInteger)getDateCurrentYear {

    NSDate *newDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:newDate];
    
    NSInteger year = [dateComponent year];
    
    return year;
}

+ (NSInteger)getDateCurrentMonth {
    
    NSDate *newDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:newDate];
    
    NSInteger month = [dateComponent month];

    return month;
}

+ (NSString *)getDateCurrentYearMonthDay {
    
    NSDate *newDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | kCFCalendarUnitDay;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:newDate];
    
    NSInteger year  = [dateComponent year];
    
    NSInteger month = [dateComponent month];
    
    NSInteger day   = [dateComponent day];
    
    NSString *strMonth = [NSString stringWithFormat:@"%ld",month];
    if (month < 10) {
        strMonth = [NSString stringWithFormat:@"0%ld",month];
    }
    
    NSString *strDay = [NSString stringWithFormat:@"%ld",day];
    if (day < 10) {
        strDay = [NSString stringWithFormat:@"0%ld",day];
    }
    
    return [NSString stringWithFormat:@"%ld%@%@",year,strMonth,strDay];
}

+ (NSString *)getNowTimeTimestamp {
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];

    NSTimeInterval a = [date timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a*1000];
    
    return timeString;
    
}

+ (NSString *)getMessageTimeWithDate:(NSDate *)date {
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:date];
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc ] init ];
    
    NSDateComponents *comp =  [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd";
    }
    else{
        if (nowCmps.day==myCmps.day) {
            dateFmt.dateFormat = @"HH:mm";
        } else if((nowCmps.day-myCmps.day)==1) {
            dateFmt.AMSymbol = @"上午";
            dateFmt.PMSymbol = @"下午";
            dateFmt.dateFormat = @"昨天 HH:mm";
        } else {
            if ((nowCmps.day-myCmps.day) <=7) {
                switch (comp.weekday) {
                    case 1:
                        dateFmt.dateFormat = @"星期日 HH:mm";
                        break;
                    case 2:
                        dateFmt.dateFormat = @"星期一 HH:mm";
                        break;
                    case 3:
                        dateFmt.dateFormat = @"星期二 HH:mm";
                        break;
                    case 4:
                        dateFmt.dateFormat = @"星期三 HH:mm";
                        break;
                    case 5:
                        dateFmt.dateFormat = @"星期四 HH:mm";
                        break;
                    case 6:
                        dateFmt.dateFormat = @"星期五 HH:mm";
                        break;
                    case 7:
                        dateFmt.dateFormat = @"星期六 HH:mm";
                        break;
                    default:
                        break;
                }
            }else {
                dateFmt.dateFormat = @"yyyy/MM/dd";
            }
        }
    }
    return [dateFmt stringFromDate:date];
}

@end
