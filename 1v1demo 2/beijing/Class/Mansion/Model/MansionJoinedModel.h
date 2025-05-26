//
//  MansionJoinedModel.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/11.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MansionJoinedModel : NSObject

@property (nonatomic, assign) int t_id; //府邸号
@property (nonatomic, strong) NSArray *anchorList;
@property (nonatomic, copy) NSString *t_mansion_house_coverImg;
@property (nonatomic, copy) NSString *t_mansion_house_name;
@property (nonatomic, assign) int t_user_id; //府邸房主id

@end

NS_ASSUME_NONNULL_END
