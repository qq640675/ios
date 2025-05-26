//
//  JsonToModelTool.h
//  beijing
//
//  Created by yiliaogao on 2018/12/28.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JsonToModelTool : NSObject

///动态列表
+ (NSMutableArray *)dynamicListJsonToModelWithJsonArray:(NSArray *)jsonArray isMine:(BOOL)isMine;
+ (NSMutableArray *)DetailDynamicListJsonToModelWithJsonArray:(NSArray *)jsonArray isMine:(BOOL)isMine;

@end

NS_ASSUME_NONNULL_END
