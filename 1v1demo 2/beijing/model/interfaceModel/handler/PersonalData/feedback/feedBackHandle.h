//
//  feedBackHandle.h
//  beijing
//
//  Created by zhou last on 2018/7/25.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface feedBackHandle : NSObject

@property (nonatomic ,assign) int t_id;              //id
@property (nonatomic ,assign) int t_is_handle;       //是否处理 0.未处理 1.已处理
@property (nonatomic ,strong) NSString *t_content;    //反馈内容


@end
