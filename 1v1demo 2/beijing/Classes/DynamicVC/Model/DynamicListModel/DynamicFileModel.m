//
//  DynamicFileModel.m
//  beijing
//
//  Created by yiliaogao on 2018/12/28.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "DynamicFileModel.h"

@implementation DynamicFileModel

- (instancetype)initWithData:(NSDictionary *)data {
    if (self = [super initWithData:data]) {
        self.t_id = [data[@"t_id"] integerValue];
        self.t_file_type = [data[@"t_file_type"] integerValue];
        self.t_gold = [data[@"t_gold"] integerValue];
        
        self.t_file_url = data[@"t_file_url"];
        self.t_cover_img_url = data[@"t_cover_img_url"];
        self.t_video_time = data[@"t_video_time"];
        
        NSInteger private = [data[@"t_is_private"] integerValue];
        if (private == 1) {
            self.isPrivate = YES;
        }
        NSInteger consume = [data[@"isConsume"] integerValue];
        if (consume == 1) {
            self.isConsume = YES;
        }
        
    }
    return self;
}

@end
