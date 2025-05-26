//
//  sqlite_interface.m
//  sqliteSec_Demo
//
//  Created by w w on 13-8-7.
//  Copyright (c) 2013年 www.91train.com. All rights reserved.
//

#import "sqlite_interface.h"
#import "onlineInfo.h"

static sqlite3 *dataBase = nil;
@implementation sqlite_interface

+(sqlite3 *)sharedSqlInstance{
    if (dataBase == nil) {
        //获得数据库的路径
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        //在docPath后面添加上数据库的名字，来组成数据库的路径
        
        NSString *sqlPath = [docPath stringByAppendingPathComponent:@"/smarking00.sqlite"];
        
        NSLog(@"sqlPath*************:%@",sqlPath);
        //打开或者创建数据库
        //需要将NSString *类型的sqlPath 转化为c语言的Char*
        //使用UTF8String 转化
        if(sqlite3_open([sqlPath UTF8String], &dataBase) == SQLITE_OK){
            NSLog(@"open ok");
//            sqlite3_key(dataBase, @"hello110", 8);   //数据库文件加密
//            sqlite3_rekey(dataBase, @"ff22efe22", 2);  //数据库文件解密
        }else{
            NSLog(@"open error");
        }
    }
    return  dataBase;
}

+(void)createTableWithSql:(NSString *)createSql{
    char * errMsg = NULL;
    if(sqlite3_exec(dataBase, [createSql UTF8String], NULL, NULL, &errMsg) == SQLITE_OK){
        NSLog(@"create ok");
    }else{
        NSLog(@"create failed: %s",errMsg);
    }
}

+(BOOL)insertContentsWithSql:(NSString *)insertSql{
    char * errMsg = NULL;
    if(sqlite3_exec(dataBase, [insertSql UTF8String], NULL, NULL, &errMsg) == SQLITE_OK){
        NSLog(@"insert ok");
        return YES;
    }else{
        NSLog(@"insert failed: %s",errMsg);
        return NO;
    }

}

+(BOOL)updateContentsWithSql:(NSString *)updateSql{
    char *errMsg = NULL;
    
    if (sqlite3_exec(dataBase, [updateSql UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) {
        NSLog(@"update ok");
        return YES;
    }else{
        NSLog(@"update failed:%s",errMsg);
        return NO;
    }
}

+(void)deleteContentsWithSql:(NSString *)deleteSql{
    char *errMsg = NULL;
    
    if (sqlite3_exec(dataBase, [deleteSql UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) {
        NSLog(@"delete ok");
    }else{
        NSLog(@"delete failed:%s",errMsg);
    }

}

+(void)dropTableWithSql:(NSString *)dropSql{
    char *errMsg = NULL;
    
    if (sqlite3_exec(dataBase, [dropSql UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) {
        NSLog(@"drop ok");
    }else{
        NSLog(@"drop failed:%s",errMsg);
    }

}

+(NSMutableArray *)queryTableWithSqlChatHistory:(NSString *)querySql
{
    NSMutableArray *chatHistoryMutableArray = [NSMutableArray array];
    sqlite3_stmt *statement = NULL;
    if (sqlite3_prepare_v2(dataBase, [querySql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //student
//            int ID = sqlite3_column_int(statement, 0);
//            const char *chatId = (const char *)sqlite3_column_text(statement,1);
//            const char *chatName = (const char *)sqlite3_column_text(statement,2);
//            const char *chatTime = (const char *)sqlite3_column_text(statement,3);
//            const char *chatHeaderUrl = (const char*)sqlite3_column_text(statement,4);
//            const char *chatContent = (const char*)sqlite3_column_text(statement,5);
//            const char *chatVoicePath = (const char*)sqlite3_column_text(statement,6);
//            const char *chatVideoPath = (const char*)sqlite3_column_text(statement,7);
//            const char *chatPhotoPath = (const char*)sqlite3_column_text(statement,8);
//            const char *chatType = (const char*)sqlite3_column_text(statement,9);
//            int isRead = sqlite3_column_int(statement, 10);
//            int isSender = sqlite3_column_int(statement, 11);
//            int isShowTime = sqlite3_column_int(statement, 12);
//            const char *userId = (const char*)sqlite3_column_text(statement,13);
            
//            const char *pic = (const char *)sqlite3_column_text(statement,4);
//            NSLog(@"&&&&&&&studentid:%d name:%s mac:%s pic:%s id:%d",idf,name,mac,pic,type);
//            ZYChatInfo *chatInfo = [[ZYChatInfo alloc] init];
//
//            [chatInfo setID:ID];
//            [chatInfo setChatId:[NSString stringWithCString:chatId encoding:NSUTF8StringEncoding]];
//            [chatInfo setChatName:[NSString stringWithCString:chatName encoding:NSUTF8StringEncoding]];
//            [chatInfo setChatTime:[NSString stringWithCString:chatTime encoding:NSUTF8StringEncoding]];
//            [chatInfo setUserId:[NSString stringWithCString:userId encoding:NSUTF8StringEncoding]];
//            if (chatHeaderUrl) {
//                [chatInfo setChatHeaderUrl:[NSString stringWithCString:chatHeaderUrl encoding:NSUTF8StringEncoding]];
//            }
//
//            if (chatContent) {
//                [chatInfo setChatContent:[NSString stringWithCString:chatContent encoding:NSUTF8StringEncoding]];
//            }
//
//            if (chatVoicePath) {
//                [chatInfo setChatVoicePath:[NSString stringWithCString:chatVoicePath encoding:NSUTF8StringEncoding]];
//            }
//
//            if (chatVideoPath) {
//                [chatInfo setChatVideoPath:[NSString stringWithCString:chatVideoPath encoding:NSUTF8StringEncoding]];
//            }
//
//            if (chatPhotoPath) {
//                [chatInfo setChatPhotoPath:[NSString stringWithCString:chatPhotoPath encoding:NSUTF8StringEncoding]];
//            }
//
//            if (chatType) {
//                [chatInfo setChatType:[NSString stringWithCString:chatType encoding:NSUTF8StringEncoding]];
//            }
//
//            [chatInfo setIsRead:isRead];
//            [chatInfo setIsSender:isSender];
//            [chatInfo setIsShowTime:isShowTime];
//
//            [chatHistoryMutableArray addObject:chatInfo];
        }
    }
    return chatHistoryMutableArray;
}

+(NSMutableArray *)queryTableWithSqlBase:(NSString *)querySql
{
    NSMutableArray *baseArray = [NSMutableArray array];
    sqlite3_stmt *statement = NULL;
    if (sqlite3_prepare_v2(dataBase, [querySql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //base_command_info
            int idf = sqlite3_column_int(statement, 0);
            const char *name = (const char *)sqlite3_column_text(statement,1);
            const char *city = (const char *)sqlite3_column_text(statement,2);
            int age = sqlite3_column_int(statement, 3);
            int userId = sqlite3_column_int(statement, 4);
            int report = sqlite3_column_int(statement, 5);

            onlineInfo *info = [onlineInfo new];
            info.name = [NSString stringWithUTF8String:(const char *)name];
            info.city = [NSString stringWithUTF8String:(const char *)city];
            info.age  = age;
            info.userId = userId;
            info.report = report;
            info.ID   = idf;

            [baseArray addObject:info];
        }
    }
    return baseArray;
}


+(NSMutableArray *)queryTableWithSqlMsgList:(NSString *)querySql
{
    NSMutableArray *msgListArray = [NSMutableArray array];
    sqlite3_stmt *statement = NULL;
    if (sqlite3_prepare_v2(dataBase, [querySql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //student
            int ID = sqlite3_column_int(statement, 0);
            const char *chatId = (const char *)sqlite3_column_text(statement,1);
            const char *chatTime = (const char *)sqlite3_column_text(statement,2);
            const char *chatContent = (const char*)sqlite3_column_text(statement,3);
            const char *chatType = (const char*)sqlite3_column_text(statement,4);
            const char *userId = (const char*)sqlite3_column_text(statement,5);
            int topPriority = sqlite3_column_int(statement, 6);
            const char *headUrl = (const char *)sqlite3_column_text(statement,7);
            const char *chatName = (const char *)sqlite3_column_text(statement,8);
            const char *unReadMsgCount = (const char *)sqlite3_column_text(statement,9);
            
            //            const char *pic = (const char *)sqlite3_column_text(statement,4);
            //            NSLog(@"&&&&&&&studentid:%d name:%s mac:%s pic:%s id:%d",idf,name,mac,pic,type);
//            ZYChatInfo *chatInfo = [[ZYChatInfo alloc] init];
//            
//            [chatInfo setID:ID];
//            [chatInfo setChatId:[NSString stringWithCString:chatId encoding:NSUTF8StringEncoding]];
//            [chatInfo setChatTime:[NSString stringWithCString:chatTime encoding:NSUTF8StringEncoding]];
//            [chatInfo setUserId:[NSString stringWithCString:userId encoding:NSUTF8StringEncoding]];
//            if (chatContent) {
//                [chatInfo setChatContent:[NSString stringWithCString:chatContent encoding:NSUTF8StringEncoding]];
//            }
//            if (chatType) {
//                [chatInfo setChatType:[NSString stringWithCString:chatType encoding:NSUTF8StringEncoding]];
//            }
//            [chatInfo setTopPriority:topPriority];
//            
//            if (headUrl) {
//                [chatInfo setChatHeaderUrl:[NSString stringWithCString:headUrl encoding:NSUTF8StringEncoding]];
//            }
//            
//            if (chatName) {
//                [chatInfo setChatName:[NSString stringWithCString:chatName encoding:NSUTF8StringEncoding]];
//            }
//            
//            if (unReadMsgCount) {
//                [chatInfo setUnReadMsgCount:[NSString stringWithCString:unReadMsgCount encoding:NSUTF8StringEncoding]];
//            }
//
//            
//            [msgListArray addObject:chatInfo];
        }
    }
    return msgListArray;
}

+(void)closeDataBase{
    sqlite3_close(dataBase);
//    sqlite3_rekey(dataBase, NULL, NULL);
}
@end
