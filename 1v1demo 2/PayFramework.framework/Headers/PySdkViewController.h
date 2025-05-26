//
//  PySdkViewController.h
//  PayFramework
//
//  Created by 陈小瑞 on 2020/8/30.
//  Copyright © 2020 crx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PySdkViewController : UIViewController
@property (nonatomic, copy) void(^tokenIDBlock)(NSString *currentText);
@property (nonatomic, copy) void(^PayfailureBlock)(NSString *message);
@property (nonatomic, copy) void(^UPPayPayBlock)(NSString *tnStr);


-(void)weixin:(NSDictionary*)payDic;
-(void)alipay:(NSDictionary*)payDic;
-(void)UPPay:(NSDictionary*)payDic;

@end

NS_ASSUME_NONNULL_END
