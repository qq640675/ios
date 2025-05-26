//
//  YLValidExtension.m
//  beijing
//
//  Created by zhou last on 2018/7/2.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLValidExtension.h"

@implementation YLValidExtension

//判断是否是手机号码
+ (BOOL)validMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }

    return YES;
//     NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
//     NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//     return [regextestmobile evaluateWithObject:mobileNum];
}

#pragma mark ---- 判断麦克风权限
+ (BOOL)judgeMicrophone
{
    AVAuthorizationStatus statusAudio = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (statusAudio == AVAuthorizationStatusDenied || statusAudio == AVAuthorizationStatusRestricted) {
        
        return NO;
    }else{
        return YES;
    }
}

@end
