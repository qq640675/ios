//
//  YLJsonExtension.h
//  beijing
//
//  Created by zhou last on 2018/7/23.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLJsonExtension : NSObject

//json -> dictonary
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//nsdata -> json
+ (NSString *)jsonStrWithNSData:(NSData *)data;

//nsdictonary ->json
+ (NSString *)jsonStrWitNSDictonary:(NSDictionary *)dic;

@end
