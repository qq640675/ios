//
//  sqlite_interface.h
//  sqliteSec_Demo
//
//  Created by w w on 13-8-7.
//  Copyright (c) 2013年 www.91train.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface sqlite_interface : NSObject

//打开或者创建数据库
+(sqlite3 *)sharedSqlInstance;
//创建一张表
+(void)createTableWithSql:(NSString *)createSql;
//向表里面添加内容
+(BOOL)insertContentsWithSql:(NSString *)insertSql;
//更改内容
+(BOOL)updateContentsWithSql:(NSString *)updateSql;
//删除内容
+(void)deleteContentsWithSql:(NSString *)deleteSql;
//删除表
+(void)dropTableWithSql:(NSString *)dropSql;
//关闭数据库
+(void)closeDataBase;
//查询
//查询聊天记录
+(NSMutableArray *)queryTableWithSqlChatHistory:(NSString *)querySql;
//查询消息列表
+(NSMutableArray *)queryTableWithSqlMsgList:(NSString *)querySql;
//按键信息表查询
+(NSMutableArray *)queryTableWithSqlBase:(NSString *)querySql;
//自定义按键查询
//+(NSMutableArray *)queryTableWithSql:(NSString *)querySql;

@end

