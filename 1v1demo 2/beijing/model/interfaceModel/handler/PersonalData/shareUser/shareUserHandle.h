//
//  shareUserHandle.h
//  beijing
//
//  Created by zhou last on 2018/8/21.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLBaseListModel.h"

@interface shareUserHandle : SLBaseListModel

@property (nonatomic ,assign) int t_id;                     //id
@property (nonatomic ,strong) NSString *t_handImg;          //头像
@property (nonatomic ,strong) NSString *t_create_time;      //创建时间
@property (nonatomic ,strong) NSString *t_nickName;         //昵称
@property (nonatomic ,strong) NSString *spreadMoney;        //贡献金币数
@property (nonatomic ,strong) NSString *totalStorageGold;   //总金币数
@property (nonatomic ,strong) NSString *balance;            //剩余金币数
@property (nonatomic ,assign) int pageCount;                //id

@end
