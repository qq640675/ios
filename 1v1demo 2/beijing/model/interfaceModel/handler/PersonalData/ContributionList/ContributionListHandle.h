//
//  ContributionListHandle.h
//  beijing
//
//  Created by zhou last on 2018/9/14.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContributionListHandle : NSObject

//公会
@property (nonatomic ,assign) int totalGold;   //贡献金币
@property (nonatomic ,assign) int t_anchor_id;  //主播编号

//cps
@property (nonatomic ,assign) int recharge_money;  //充值金额
@property (nonatomic ,assign) float t_devote_value;  //贡献值
@property (nonatomic ,assign) int t_ratio;         //贡献比例

//公用
@property (nonatomic ,assign) int pageCount;  //总页码
@property (nonatomic ,strong) NSString *t_handImg; //主播头像
@property (nonatomic ,strong) NSString *t_nickName; //主播昵称


@end
