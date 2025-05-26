//
//  NSString+Util.h
//  CQTNews
//
//  Created by ANine on 6/8/16.
//  Copyright © 2016 zzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Util)

typedef void(^YLPrivilegyBlock)(BOOL granted);

- (NSString *)getMd5;

/**
 *  判断是否为空
 *  @param string 判断的值
 *
 *  @return BOOL
 */

//内网IP
+ (NSString *)deviceIPAdress;

+ (BOOL)getIsIpad;

//外网IP
+(NSString *)getWANIP;

//soket
+ (NSMutableData *)encodeSocket:(NSString *)conent;

+ (void)openScheme:(NSString *)scheme;

+ (NSString *)defaultUserAgentString;

+ (BOOL) isNullOrEmpty:(NSString *)string;

+ (NSString *)getStringWithEmpty:(NSString *)string;

- (NSString *)proccessNilString;

+ (void)adjustScrollView:(UIScrollView *)scrollView VC:(const  UIViewController *)vc nav:(float)nav tabbar:(int)tabbar;


+ (NSString*)encodeString:(NSString*)unencodedString;

/*!判断系统版本号
 versionA 被比较的版本号
 versionB 比较的版本号
 */
+ (BOOL)isVersion:(NSString*)versionA biggerThanVersion:(NSString*)versionB;

+ (NSInteger)getLinesArrayOfStringInLabel:(UILabel *)label;

+ (BOOL)hasContainsOrginString:(NSString *)string checkString:(NSString *)checkSatring;
/**
 字符串的去空格方法
 */
- (NSString *)noWhiteSpaceString;


//授权相机
+ (void)checkVideoAuthStatus:(YLPrivilegyBlock)block;

//检查麦克风权限
+ (void) checkAudioStatus:(YLPrivilegyBlock)block;

@end
