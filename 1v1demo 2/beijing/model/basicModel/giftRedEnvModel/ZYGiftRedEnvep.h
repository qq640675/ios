//
//  ZYGiftRedEnvep.h
//  beijing
//
//  Created by zhou last on 2018/11/1.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYGiftRedEnvep : NSObject

typedef void (^YLSendSuccessBlock)(BOOL isSuccess,NSString *name,NSString *giftUrl,NSString *gifUrl,int giftId,int coins);

+ (id)shareInstance;

- (void)giftViewTap:(int)godnessId hiddenReward:(BOOL)isHidden target:(id)target block:(YLSendSuccessBlock)block;

- (void)hideBlackMaskView;

@end

NS_ASSUME_NONNULL_END
