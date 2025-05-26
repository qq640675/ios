//
//  MessageHandleOptionsView.h
//  beijing
//
//  Created by 黎 涛 on 2021/3/25.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageHandleOptionsView : BaseView

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *covId;
@property (nonatomic, assign) NSInteger isFollow;
@property (nonatomic, assign) NSInteger isTop;//是否已经置顶
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, copy) void (^followButtonClickBlock)(bool isFollow);
@property (nonatomic, copy) void (^remarkButtonClickBlock)(void);

- (instancetype)initWithId:(NSInteger)userId covId:(NSString *)covId isFollow:(BOOL)isFollow sex:(int)sex;
- (void)show;

@end

NS_ASSUME_NONNULL_END
