//
//  NearTableViewCell.h
//  beijing
//
//  Created by 黎 涛 on 2020/5/14.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "distanceHandle.h"
#import "fansListHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface NearTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isBoyUser; //是否男用户页面

- (void)setNearHandle:(distanceHandle * _Nonnull)handle;

- (void)setFansHandle:(fansListHandle *)handle;

@end

NS_ASSUME_NONNULL_END
