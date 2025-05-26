//
//  YLSocketExtension.h
//  beijing
//
//  Created by zhou last on 2018/7/26.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@interface YLSocketExtension : NSObject

@property (nonatomic ,strong) GCDAsyncSocket *clientSocket;

typedef void (^YLSocketBlock)(NSString *jsonStr);

+ (id)shareInstance;

- (void)connectHost;

- (void)disconnect;

- (BOOL)isConnected;

@end
