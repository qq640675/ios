//
//  JsonToModelTool.m
//  beijing
//
//  Created by yiliaogao on 2018/12/28.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "JsonToModelTool.h"
#import "DynamicListModel.h"

@implementation JsonToModelTool

+ (NSMutableArray *)dynamicListJsonToModelWithJsonArray:(NSArray *)jsonArray isMine:(BOOL)isMine {
    NSMutableArray *models = [NSMutableArray new];
    for (int i = 0; i < [jsonArray count]; i++) {
        NSDictionary *dic = jsonArray[i];
        DynamicListModel *model = [[DynamicListModel alloc] initWithData:dic];
        model.isMine = isMine;
        [models addObject:model];
    }
    return models;
}

+ (NSMutableArray *)DetailDynamicListJsonToModelWithJsonArray:(NSArray *)jsonArray isMine:(BOOL)isMine {
    NSMutableArray *models = [NSMutableArray new];
    for (int i = 0; i < [jsonArray count]; i++) {
        NSDictionary *dic = jsonArray[i];
        DynamicListModel *model = [[DynamicListModel alloc] initWithData:dic];
        model.isMine = isMine;
        model.isAnchorDetail = YES;
        [models addObject:model];
    }
    return models;
}

@end
