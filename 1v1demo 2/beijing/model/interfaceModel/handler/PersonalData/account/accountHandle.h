//
//  accountHandle.h
//  beijing
//
//  Created by zhou last on 2018/8/16.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface accountHandle : NSObject

@property (nonatomic ,assign) int t_id;       //套餐名称
@property (nonatomic ,assign) int t_type;       //类型
@property (nonatomic ,strong) NSString *t_real_name;       //真名
@property (nonatomic ,strong) NSString *t_nick_name;       //昵称
@property (nonatomic ,strong) NSString *t_account_number;       //套餐名称
@property (nonatomic ,assign) int totalMoney;       //金币
@property (nonatomic ,strong) NSString *t_head_img;       //头像
@property (nonatomic ,copy) NSString *qrCode;


@end
