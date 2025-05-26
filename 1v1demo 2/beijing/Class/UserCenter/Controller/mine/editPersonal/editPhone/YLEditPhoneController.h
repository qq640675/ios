//
//  YLEditPhoneController.h
//  beijing
//
//  Created by zhou last on 2018/8/17.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLEditPhoneController : UIViewController

@property (nonatomic, assign) BOOL  isLock;

@property (nonatomic, copy) NSString *phoneStr;//已绑定的手机号

@property (nonatomic, assign) BOOL isNeesLoadMain;//是否需要加载主页 针对微信登录绑定手机的界面

@end
