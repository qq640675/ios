//
//  imLoginExtension.m
//  beijing
//
//  Created by zhou last on 2018/7/31.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "imLoginExtension.h"
#import "YLNetworkInterface.h"
//#import <ImSDK/ImSDK.h>

@implementation imLoginExtension

+ (void)loginWithIMSDK:(int)userId block:(IMLoginBlock)block
{
//    [YLNetworkInterface getImUserSign:userId block:^(NSString *token) {
//        TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
//        
//        // accountType 和 sdkAppId 通讯云管理平台分配
//        // identifier为用户名，userSig 为用户登录凭证
//        // appidAt3rd 在私有帐号情况下，填写与sdkAppId 一样
//        login_param.accountType = @"31470";
//        login_param.identifier = [NSString stringWithFormat:@"%d",userId];
//        login_param.userSig = token;
//        login_param.appidAt3rd = @"1400113821";
//        login_param.sdkAppId = 1400113821;
//        
//        NSLog(@"____id:%d userSig:%@",userId,token);
//        [[TIMManager sharedInstance] login: login_param succ:^(){
//            NSLog(@"_____success");
//            block(YES);
//        } fail:^(int code, NSString * err) {
//            NSLog(@"Login Failed: %d->%@", code, err);
//            block(NO);
//        }];
//    }];
}

@end
