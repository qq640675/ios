//
//  YLUserDefault.m
//  beijing
//
//  Created by zhou last on 2018/7/2.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLUserDefault.h"
#import "NSString+Extension.h"
#import "XZTabBarController.h"

@implementation YLUserDefault

+ (YLUserDefault *)userDefault
{
    YLUserDefault *userD = [YLUserDefault new];
    
    return userD;
}

//保存用户信息
+ (void)saveUserDefault:(NSString *)gold t_id:(NSString *)t_id t_is_vip:(NSString *)t_is_vip t_role:(NSString *)t_role
{
    [[NSUserDefaults standardUserDefaults] setObject:gold forKey:@"gold"];
    [[NSUserDefaults standardUserDefaults] setObject:t_id forKey:@"t_id"];
//    [[NSUserDefaults standardUserDefaults] setObject:t_role forKey:@"t_role"];

    if (![NSString isNullOrEmpty:t_is_vip]) {
        [[NSUserDefaults standardUserDefaults] setObject:t_is_vip forKey:@"t_is_vip"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"t_is_vip"];
    }
    
//    if ([t_role intValue] == 1) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"t_role"];
//    }else{
//        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"t_role"];
//    }
    [self saveRole:[t_role intValue]];
}

+ (void)saveNickName:(NSString *)nickName {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", nickName] forKey:@"t_nickName"];
}

+ (void)saveLocalVideo:(BOOL)isLocal
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isLocal] forKey:@"localVideo"];
}

+ (void)saveAppInstall:(BOOL)isFirst
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isFirst] forKey:@"isFirstInstall"];
}

+ (void)saveMsgAudio:(BOOL)isOn
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isOn] forKey:@"imsgAudio"];
}

+ (void)saveMsgVibrate:(BOOL)isOn
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isOn] forKey:@"imsgVibrate"];
}

+ (void)saveGroupMsgAudio:(BOOL)isOn
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isOn] forKey:@"groupImsgAudio"];
}

+ (void)saveGroupMsgVibrate:(BOOL)isOn
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isOn] forKey:@"groupImsgVibrate"];
}


+ (void)saveRole:(int)t_role
{
    if ([self userDefault].t_role != t_role) {
        UIViewController *nowVC = [SLHelper getCurrentVC];
        if ([nowVC.tabBarController isKindOfClass:[XZTabBarController class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserRoleBecomeTrue" object:nil];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", t_role] forKey:@"t_role"];
}

+ (void)saveVip:(BOOL)t_is_vip
{
    if ([self userDefault].t_is_vip == 1 && t_is_vip == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEDVIP" object:nil];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:t_is_vip] forKey:@"t_is_vip"];
}


+ (void)saveAppOnBack:(BOOL)isOn roomId:(int)roomId socketOnLine:(BOOL)socketOnLine
{
    [[NSUserDefaults standardUserDefaults] setBool:isOn forKey:@"appOnBack"];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isOn] forKey:@"appOnBack"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:roomId] forKey:@"roomId"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:socketOnLine] forKey:@"socketOnLine"];
}

+ (void)saveStyle:(NSString *)style
{
    [[NSUserDefaults standardUserDefaults] setObject:style forKey:@"style"];
}

+ (void)savePhone:(NSString *)phone
{
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"phone"];
}

+ (void)saveConnet:(BOOL)isConnect
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isConnect] forKey:@"connectOnLine"];
}

+ (void)saveSex:(NSString *)t_sex
{
    [[NSUserDefaults standardUserDefaults] setObject:t_sex forKey:@"t_sex"];
}

+ (void)saveOnLine:(NSString *)online
{
    [[NSUserDefaults standardUserDefaults] setObject:online forKey:@"online"];
}


+ (void)saveHeadImage:(UIImage *)image
{
    if (image == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation([UIImage imageNamed:@"default"]) forKey:@"t_headImage"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:@"t_headImage"];
    }
}

+ (void)saveEULA:(BOOL)EULA
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:EULA] forKey:@"EULA"];
}

- (BOOL)eula
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"EULA"] boolValue];
}

- (int)gold
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"gold"] intValue];
}

- (BOOL)isFirstInstall
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstInstall"] intValue];
}

- (BOOL)connectOnLine
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"connectOnLine"] boolValue];
}

- (BOOL)msgAudio
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"imsgAudio"] boolValue];
}

- (BOOL)msgVibrate
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"imsgVibrate"] boolValue];
}

- (BOOL)groupMsgAudio
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"groupImsgAudio"] boolValue];
}

- (BOOL)groupMsgVibrate
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"groupImsgVibrate"] boolValue];
}

- (BOOL)openLocalVideo
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"localVideo"] boolValue];
}

- (NSString *)style
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"style"];
}

- (int)t_id
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"t_id"] intValue];
}

- (BOOL)t_is_vip
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"t_is_vip"] boolValue];
}


- (int)t_role
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"t_role"] intValue];
}
                        
- (int)t_sex
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"t_sex"] boolValue];
}

- (NSString *)phone
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
}

- (BOOL)online
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"online"] boolValue];
}

- (BOOL)appOnBack
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"appOnBack"];
}

- (BOOL)socketOnLine
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"socketOnLine"] boolValue];
}

- (int)roomId
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"roomId"] intValue];
}

- (NSString *)t_nickName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"t_nickName"];
}

- (UIImage *)headImage
{
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"t_headImage"];
    UIImage* image = [UIImage imageWithData:imageData];
    return image;
}

+ (void)saveDic:(NSDictionary *)dic
{
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"videochatSocketNoti"];
}

+ (void)saveQQCustomer:(NSString *)qqNum
{
    [[NSUserDefaults standardUserDefaults] setObject:qqNum forKey:@"QQCustomer"];
}

- (NSString *)qqCustomer
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"QQCustomer"];
}

- (NSDictionary *)socketdic
{
    return (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:@"videochatSocketNoti"];

}

+ (void)saveCity:(NSString *)city {
    [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"t_city"];
}

- (NSString *)t_city {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"t_city"];
}


@end
