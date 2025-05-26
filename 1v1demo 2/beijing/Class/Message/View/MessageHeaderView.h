//
//  MessageHeaderView.h
//  beijing
//
//  Created by 黎 涛 on 2020/5/19.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageHeaderView : BaseView

@property (nonatomic, assign) int systemNum;
@property (nonatomic, copy) NSString *systemContent;

- (void)setMansionCount:(int)mansionCount;

@end

NS_ASSUME_NONNULL_END
