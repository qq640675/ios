//
//  YLUserDefault.m
//  beijing
//
//  Created by zhou last on 2018/7/2.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLThirdSetup.h"
#import "NSString+Extension.h"

@implementation YLThirdSetup

+ (YLThirdSetup *)thirdDefault
{
    YLThirdSetup *userD = [YLThirdSetup new];
    
    return userD;
}

- (NSString *)we_chat_app_id
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"t_we_chat_app_id"];
}
- (NSString *)we_chat_secret
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"t_we_chat_secret"];
}
- (NSString *)qq_app_id
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"t_qq_app_id"];
}
- (NSString *)tencent_cloud_app_id
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"t_tencent_cloud_app_id"];
}
- (NSString *)tencent_cloud_bucket
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"t_tencent_cloud_bucket"];
}
- (NSString *)tencent_cloud_secret_id
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"t_tencent_cloud_secret_id"];
}
- (NSString *)tencent_cloud_secret_key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"t_tencent_cloud_secret_key"];
}
- (NSString *)tencent_cloud_region
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"t_tencent_cloud_region"];
}
- (NSString *)agora_app_id
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"t_agora_app_id"];
}
- (NSString *)tim_app_id
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"t_tim_app_id"];
}
- (NSString *)jpush_appkey
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"t_jpush_appkey"];
}
- (NSString *)sharetrace_appkey
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"t_sharetrace_appkey"];
}
- (NSString *)amap_apikey
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"t_amap_apikey"];
}

- (NSString *)btkey_ios_ver
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"t_btkey_ios_ver"];
}
- (NSString *)btkey_ios_file
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"t_btkey_ios_file"];
}


- (NSString *)serverurl
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"serverurl"];
}

- (NSString *)socketip
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"socketip"];
}

- (NSString *)selfcodeurl
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"selfcodeurl"];
}


@end
