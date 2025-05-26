//
//  SLDefaultsHelper.h
//  JFQ
//
//  Created by lunubao on 2018/6/28.
//  Copyright © 2018年 LSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLDefaultsHelper : NSObject


/**
 获取Defaults数据

 @param strKey 关键字
 @return 对象
 */
+ (NSObject *)getSLDefaults:(NSString *)strKey;

/**
 保存Defaults数据

 @param obj 保存的对象
 @param strKey 关键字
 */
+ (void)saveSLDefaults:(NSObject* )obj key:(NSString *)strKey;

/**
 删除Defaults数据

 @param strKey 关键字
 */
+ (void)deleteSLDefaulte:(NSString *)strKey;

@end
