//
//  APIManager.h
//  mashup
//
//  Created by ANine on 5/20/16.
//  Copyright © 2016 zzh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^success)(id dataObject);
typedef void(^failed)(NSString *error);

@interface APIManager : NSObject

@property (copy) NSString *hostName;

+ (instancetype)manager;

+ (void)cancelAllOperation;

//TODO, ipcodehandle - start
+ (void)selfCode_request:(void (^)(id dataBody))success failed:(void (^)(NSString *error))failed;
//TODO, ipcodehandle - end

+ (void)requestWithChatPath:(NSString *)path Param:(NSDictionary *)param success:(void (^)(id dataBody))success failed:(void (^)(NSString *error))failed;

+ (void)requestGETWithChatPath:(NSString *)path Param:(NSDictionary *)param success:(void (^)(id dataBody))success failed:(void (^)(NSString *error))failed;

//举报
+ (void)requestWithReportPath:(NSString *)path Param:(NSDictionary *)param success:(void (^)(id dataBody))success failed:(void (^)(NSString *error))failed;

//上传图片到服务器
+ (void)appendImagesDictionary:(NSDictionary *)dictionary andImageArray:(NSArray *)imageArray andName:(NSString *)name andFileName:(NSString *)fileName andSuccess:(void (^)(id responseObject))success andFail:(void (^)(NSError *error))fail;

@end
