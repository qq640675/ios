//
//  YLJsonExtension.m
//  beijing
//
//  Created by zhou last on 2018/7/23.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLJsonExtension.h"

@implementation YLJsonExtension


/**
 json字符串转换成字典

 @param jsonString json字符串
 @return 返回一个字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


/**
 data转换成json字符串

 @param data 二进制流
 @return 返回json字符串
 */
+ (NSString *)jsonStrWithNSData:(NSData *)data
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    NSString *jsonObject = [[NSString alloc]initWithData:data encoding:enc];
    
    return jsonObject;
}


/**
 字典转换成json字符串

 @param dic 字典
 @return 返回json字符串
 */
+ (NSString*)jsonStrWitNSDictonary:(NSDictionary *)dic

{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

@end
