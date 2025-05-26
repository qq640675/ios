//
//  apliManager.h
//  apliDemo
//
//  Created by zhou last on 2018/8/17.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface apliManager : NSObject

typedef void(^YLApliPayBlock)(BOOL isSuccess);

//生成支付宝单例类
+(id)sharePayManager;

//支付宝支付
//aParam 后端返回支付信息
-(void)handleOrderPayWithParams:(NSString *)aParam block:(YLApliPayBlock)block;

@end
