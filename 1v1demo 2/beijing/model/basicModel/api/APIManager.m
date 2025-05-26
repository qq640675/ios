  //
//  APIManager.m
//  mashup
//
//  Created by ANine on 5/20/16.
//  Copyright © 2016 zzh. All rights reserved.
//

#import "APIManager.h"
//#import "Config.h"
//#import "SystemHelper.h"
#import "NSString+Util.h"
#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>
#import "RSA.h"
#import "JChatConstants.h"
#import "YLUserDefault.h"
#import "SVProgressHUD.h"
//#import "CoreSVP.h"
#import "LXTAlertView.h"
#import "WelcomeViewController.h"
#import "KJJPushHelper.h"

static CGFloat const TIMEOUT = 100.f;
@implementation APIManager

static AFHTTPSessionManager *_manager;

+ (void)initialize {
    _manager = [AFHTTPSessionManager manager];
    [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    _manager.requestSerializer.timeoutInterval = TIMEOUT;
    [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

+ (instancetype)manager {
    static APIManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

+ (void)cancelAllOperation{
    [_manager.operationQueue cancelAllOperations];
}

#pragma - mark private function

+ (void)requestWithChatPath:(NSString *)path Param:(NSDictionary *)param success:(void (^)(id dataBody))success failed:(void (^)(NSString *error))failed {
    
    NSMutableDictionary *tokenDic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    if ([YLUserDefault userDefault].t_id > 0) {
        //userId
        [tokenDic setObject:[NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id] forKey:@"tokenId"];
    }
    NSString *t_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"T_TOKEN"];
    if (t_token.length > 0) {
        //token
        [tokenDic setObject:[NSString stringWithFormat:@"%@", t_token] forKey:@"t_token"];
    }
    
    //参数dic转json
    NSString *json = [tokenDic JSONString];
    //公钥加密
    NSString *encryptStr = [RSA encryptString:json publicKey:RSAPublicKey];

    NSDictionary *jsonDic = @{@"param":encryptStr};
    
    NSDictionary *headers = @{@"appVersionCode":APP_version,
                              @"appBuildCode":APP_create_version,
                              @"appSystem":@"1"
    };
    [_manager POST:path parameters:jsonDic headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL isError = NO;
        NSError *jsonError;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if ([resultDict isKindOfClass:[NSDictionary class]]) {
            int code = [[NSString stringWithFormat:@"%@", resultDict[@"m_istatus"]] intValue];
            if (code == -1020) {
                [SVProgressHUD dismiss];
                NSLog(@"___url:%@", path);
                NSLog(@"___dic:%@", tokenDic);
                NSLog(@"___error :%@", resultDict);
                //登录失效
                [LXTAlertView alertViewDefaultOnlySureWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",resultDict[@"m_strMessage"]] sureHandle:^{
                    [KJJPushHelper deleteAlias];
                    [YLUserDefault saveUserDefault:@"0" t_id:@"0" t_is_vip:@"1" t_role:@"0"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"T_TOKEN"];
                    WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] init];
                    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                    window.rootViewController = welcomeVC;
                }];
                return ;
            } else if (code == -1030) {
                [YLPushManager appNeedUptateWithData:resultDict[@"m_object"]];
                return;
            }
        }
        if (!isError) {
            success(resultDict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"___error:%@",error);
        [SVProgressHUD showInfoWithStatus:@"请检查网络连接！"];
        if (failed) {
            failed(@"");
        }
    }];
}

+ (void)requestGETWithChatPath:(NSString *)path Param:(NSDictionary *)param success:(void (^)(id dataBody))success failed:(void (^)(NSString *error))failed {
    NSMutableDictionary *tokenDic = [NSMutableDictionary dictionaryWithDictionary:param];
    NSString *t_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"T_TOKEN"];
    if (t_token.length > 0) {
        [tokenDic setObject:[NSString stringWithFormat:@"%@", t_token] forKey:@"t_token"];
    }
    
    
    
    [_manager GET:path parameters:tokenDic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL isError = NO;
        NSError *jsonError;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if ([resultDict isKindOfClass:[NSDictionary class]]) {
            int code = [resultDict[@"m_istatus"] intValue];
            if (code == -1020) {
                //登录失效
                [LXTAlertView alertViewDefaultOnlySureWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",resultDict[@"m_strMessage"]] sureHandle:^{
                    [KJJPushHelper deleteAlias];
                    [YLUserDefault saveUserDefault:@"0" t_id:@"0" t_is_vip:@"1" t_role:@"0"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"T_TOKEN"];
                    WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] init];
                    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                    window.rootViewController = welcomeVC;
                }];
                return ;
            }
        }
        
        if (!isError) {
            success(resultDict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        success(error);
    }];
}


//举报
+ (void)requestWithReportPath:(NSString *)path
                        Param:(NSDictionary *)param
                      success:(void (^)(id dataBody))success
                       failed:(void (^)(NSString *error))failed
{
    [_manager POST:path parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL isError = NO;
        NSError *jsonError;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if (!isError) {
            success(resultDict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"___error:%@",error);
    }];
    
}

+ (void)appendImagesDictionary:(NSDictionary *)dictionary andImageArray:(NSArray *)imageArray andName:(NSString *)name andFileName:(NSString *)fileName andSuccess:(void (^)(id responseObject))success andFail:(void (^)(NSError *error))fail {
    for (int i = 0; i < imageArray.count; i ++) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",INTERFACEADDRESS,@"/share/uploadAPPFile.html"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                             @"text/html",
                                                             @"image/jpeg",
                                                             @"image/png",
                                                             @"application/octet-stream",
                                                             @"text/json",
                                                             nil];
        
        [manager POST:urlString parameters:dictionary headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            UIImage *image = imageArray[i];
            
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"%@%d",name, i] fileName:[NSString stringWithFormat:@"%@%d.jpg", fileName, i] mimeType:@"image/jpg"];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseObject) {
                NSDictionary *resultDict = (NSDictionary *)responseObject;
                if ([[NSString stringWithFormat:@"%@", resultDict[@"m_istatus"]] intValue] == 1) {
                    NSString *imgUrl = resultDict[@"m_object"];
                    if (success) {
                        success(imgUrl);
                    }
                } else {
                    NSLog(@"____上传图片到服务器失败:%@", resultDict[@"m_strMessage"]);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"____上传图片到服务器失败:%@", error);
        }];

    }
}

//TODO, ipcodehandle - start
+ (void)selfCode_request:(void (^)(id dataBody))success failed:(void (^)(NSString *error))failed {
    
    [_manager GET:[NSString stringWithFormat:@"%@/index/index/getYaoqingma.html?field=userId&autoget=1",IPCODEURL] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSString *data = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failed) {
            failed(@"");
        }
    }];
}
//TODO, ipcodehandle - end

@end
