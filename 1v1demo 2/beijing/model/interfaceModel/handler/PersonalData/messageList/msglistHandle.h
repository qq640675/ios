//
//  msglistHandle.h
//  beijing
//
//  Created by zhou last on 2018/8/2.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface msglistHandle : NSObject

@property (nonatomic ,strong) NSString *identifier;       //id
@property (nonatomic ,strong) NSString *nickname;       //昵称
@property (nonatomic ,strong) NSString *faceURL;       //头像
@property (nonatomic ,strong) NSString *recentMsg;       //最后一条消息


@end
