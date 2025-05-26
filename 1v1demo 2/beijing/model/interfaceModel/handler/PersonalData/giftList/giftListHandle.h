//
//  giftListHandle.h
//  beijing
//
//  Created by zhou last on 2018/8/3.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface giftListHandle : NSObject

@property (nonatomic ,strong) NSString *t_gift_gif_url;       //gif地址
@property (nonatomic ,strong) NSString *t_gift_gold;          //消耗金币
@property (nonatomic ,strong) NSString *t_gift_id;            //礼物编号
@property (nonatomic ,strong) NSString *t_gift_name;          //礼物名称
@property (nonatomic ,strong) NSString *t_gift_still_url;     //静态图地址

@property (nonatomic ,strong) NSString *t_nickName;        //昵称
@property (nonatomic ,strong) NSString *t_create_time;     //时间
@property (nonatomic ,strong) NSString *t_handImg;        //头像

@property (nonatomic, strong) NSArray *twoGiftList;


//收到礼物
@property (nonatomic ,strong) NSString *t_amount;     //消耗金币
@property (nonatomic ,assign) int t_consume_type;     //礼物类型 7.红包 9.图片礼物


@end
