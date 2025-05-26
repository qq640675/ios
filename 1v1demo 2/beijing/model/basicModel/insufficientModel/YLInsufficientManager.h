//
//  YLInsufficientManager.h
//  beijing
//
//  Created by zhou last on 2018/10/8.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLInsufficientManager : NSObject

+(id)shareInstance;

- (void)insufficientShow;

- (void)removeInsufficient;

@end

NS_ASSUME_NONNULL_END
