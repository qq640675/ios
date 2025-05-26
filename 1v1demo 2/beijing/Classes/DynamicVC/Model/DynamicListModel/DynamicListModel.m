//
//  DynamicListModel.m
//  beijing
//
//  Created by yiliaogao on 2018/12/27.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "DynamicListModel.h"

@implementation DynamicListModel

- (instancetype)initWithData:(NSDictionary *)data {
    if (self = [super initWithData:data]) {
        self.t_id = [data[@"t_id"] integerValue];
        if (![data[@"t_age"] isKindOfClass:[NSNull class]]) {
            self.t_age = [data[@"t_age"] integerValue];
        }
        if (![data[@"t_sex"] isKindOfClass:[NSNull class]]) {
            self.t_sex = [data[@"t_sex"] integerValue];
        }
        self.t_dynamicId   = [data[@"dynamicId"] integerValue];
        self.t_create_time = [data[@"t_create_time"] integerValue];
        self.t_praiseCount = [data[@"praiseCount"] integerValue];
        self.t_commentCount = [data[@"commentCount"] integerValue];
        
        self.t_content = data[@"t_content"];
        self.t_nickName= data[@"t_nickName"];
        
        if (![NSString isNullOrEmpty:data[@"t_handImg"]]) {
            self.t_handImg = data[@"t_handImg"];
        }
        
        if (![NSString isNullOrEmpty:data[@"t_address"]]) {
            self.t_address = data[@"t_address"];
        }
        
        NSInteger follow = [data[@"isFollow"] integerValue];
        if (follow == 1) {
            self.isFollow = YES;
        }
        NSInteger praise = [data[@"isPraise"] integerValue];
        if (praise == 1) {
            self.isPraise = YES;
        }
        if (![NSString isNullOrEmpty:self.t_address]) {
            self.isHaveAddress = YES;
        }
        NSArray *array = data[@"dynamicFiles"];
        NSMutableArray *models= [NSMutableArray new];
        for (int i = 0; i < [array count]; i++) {
            DynamicFileModel *model = [[DynamicFileModel alloc] initWithData:array[i]];
            [models addObject:model];
        }
        self.fileArrays = models;
        
    }
    return self;
}

@end
