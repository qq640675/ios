//
//  DiscoverImageModel.h
//  beijing
//
//  Created by yiliaogao on 2019/5/17.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiscoverImageModel : SLBaseListModel

@property (nonatomic, assign) NSInteger t_id;

@property (nonatomic, assign) NSInteger t_is_examine;

@property (nonatomic, assign) NSInteger t_first;

@property (nonatomic, copy) NSString  *t_img_url;

@end

NS_ASSUME_NONNULL_END
