//
//  IMRemakeAlertView.h
//  beijing
//
//  Created by 黎 涛 on 2020/11/18.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMRemakeAlertView : BaseView

@property (nonatomic, copy) void (^ setRemakeSuccess)(NSString *remake);
- (instancetype)initWithFriendIMId:(NSInteger)imId;

@end

NS_ASSUME_NONNULL_END
