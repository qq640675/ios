//
//  YLGifExtension.h
//  beijing
//
//  Created by zhou last on 2018/6/30.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "giftListHandle.h"

@interface YLGifExtension : NSObject

typedef void (^JSONGiftListHandleBlock)(giftListHandle *handle);

+ (id)shareInstance;

- (void)createGifView:(NSMutableArray *)gifArray scrollView:(UIScrollView *)scrollView block:(JSONGiftListHandleBlock)block;

@end
