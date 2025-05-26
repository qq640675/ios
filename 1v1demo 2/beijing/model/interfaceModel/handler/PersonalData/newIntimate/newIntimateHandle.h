//
//  newIntimateHandle.h
//  beijing
//
//  Created by zhou last on 2018/10/30.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface newIntimateHandle : NSObject

@property (nonatomic ,assign) int t_id;  //用户编号
@property (nonatomic ,assign) int grade;  //金币档(和主页相同)
@property (nonatomic ,assign) int totalGold;  //金币
@property (nonatomic ,assign) int pageCount;  //页码
@property (nonatomic ,strong) NSString *t_handImg; //用户头像
@property (nonatomic ,strong) NSString *t_nickName; //用户昵称

//礼物柜
@property (nonatomic ,strong) NSString *t_gift_still_url; //礼物图片地址
@property (nonatomic ,assign) int totalCount;  //收到数量
@property (nonatomic ,assign) int total;  //总收到礼物份数
@property (nonatomic ,strong) NSString *t_gift_name; //礼物名称



@end

NS_ASSUME_NONNULL_END
