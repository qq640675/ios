//
//  AppDelegate.h
//  beijing
//
//  Created by zhou last on 2018/7/18.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CHANNEL @"Publish channel"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSData *deviceToken;

@property (assign, nonatomic) int selectIndex;//判断在那个页面的

-(void) initTencentOss;
-(void)initAgora;
@end

