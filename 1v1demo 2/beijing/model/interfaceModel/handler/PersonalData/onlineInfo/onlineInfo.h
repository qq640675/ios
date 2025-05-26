//
//  onlineInfo.h
//  beijing
//
//  Created by zhou last on 2018/9/27.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface onlineInfo : NSObject

@property (nonatomic ,strong) NSString *name; //名称
@property (nonatomic ,strong) NSString *city; //城市
@property (nonatomic ,assign) int age;       //年龄
@property (nonatomic ,assign) int ID;        //ID
@property (nonatomic ,assign) int userId;    //用户id
@property (nonatomic ,assign) int report;    //举报

@end

NS_ASSUME_NONNULL_END
