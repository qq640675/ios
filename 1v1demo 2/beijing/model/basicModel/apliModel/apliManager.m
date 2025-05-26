//
//  apliManager.m
//  apliDemo
//
//  Created by zhou last on 2018/8/17.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "apliManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import <SVProgressHUD.h>

@implementation apliManager

+(id)sharePayManager
{
    static apliManager *asAlixPay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        asAlixPay = [[apliManager alloc] init];
    });
 
    return asAlixPay;
}

-(void)handleOrderPayWithParams:(NSString *)aParam block:(YLApliPayBlock)block
{
    NSLog(@"aParm = %@",aParam);
    NSString *appScheme = @"demoalisdk";
//    NSString *orderString = aParam[@"payInfo"];
    
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:aParam fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        int statusCode = [resultDic[@"resultStatus"]  intValue];
        
        if (statusCode == 9000)
        {
            //订单支付
            NSLog(@"______支付成功");
//            [MBProgressHUD showText:@"支付成功"];
            block(YES);
        }
        else
        {
            //交易失败
            // [[NSNotificationCenter defaultCenter] postNotificationName:@"PAY_STATUS" object:@"0"];
//            [MBProgressHUD showText:@"支付异常"];
            [SVProgressHUD showInfoWithStatus:@"支付失败!"];
            
            block(NO);
        }
        
    }];
}



@end
