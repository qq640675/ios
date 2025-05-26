//
//  weixinPayHandle.h
//  beijing
//
//  Created by zhou last on 2018/8/14.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface weixinPayHandle : NSObject

@property (nonatomic ,strong) NSString *appid;          //id
@property (nonatomic ,strong) NSString *noncestr;       //noncestr
@property (nonatomic ,strong) NSString *package;        //package
@property (nonatomic ,strong) NSString *partnerid;      //套餐;
@property (nonatomic ,strong) NSString *prepayid;       //prepayid
@property (nonatomic ,strong) NSString *sign;           //签名
@property (nonatomic ,strong) NSString *timestamp;      //时间戳


@end
