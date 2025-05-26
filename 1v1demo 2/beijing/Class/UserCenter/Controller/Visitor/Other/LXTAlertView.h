//
//  LXTAlertView.h
//  
//
//  Created by 黎涛 on 2019/2/26.
//  Copyright © 2019 XY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXTAlertView : NSObject

/**
 * 自定义弹窗 AlsertView类型 默认只带确定按钮 不带方法
 * @param title   弹窗标题
 * @param message 弹窗内容
 */
+ (void)alertViewDefaultOnlySureWithTitle:(NSString *)title
                                  message:(NSString *)message;


/**
 * 自定义弹窗 AlsertView类型 默认只带确定按钮 带方法
 * @param title   弹窗标题
 * @param message 弹窗内容
 * @param sure    确定按钮的回调
 */
+ (void)alertViewDefaultOnlySureWithTitle:(NSString *)title
                                  message:(NSString *)message
                               sureHandle:(void(^)(void))sure;

/**
 * 自定义弹窗 AlertView类型 默认按钮为“取消”和“确定” 取消不带方法 确定带方法 可为nil
 * @param title   弹窗标题
 * @param message 弹窗内容
 * @param sure    确定按钮的回调
 */
+ (void)alertViewDefaultWithTitle:(NSString *)title
                          message:(NSString *)message
                       sureHandle:(void(^)(void))sure;


/**
 * 自定义弹窗 AlertView类型 自定义确定和取消按钮的文字 取消不带方法 确定带方法 可为nil
 * @param title 弹窗标题
 * @param message 弹窗内容
 * @param cancleTitle 取消按钮的文字
 * @param sureTitle 确定按钮的文字
 * @param sure 确定按钮的回调
 */
+ (void)alertViewWithTitle:(NSString *)title
                   message:(NSString *)message
               cancleTitle:(nullable NSString *)cancleTitle
                 sureTitle:(NSString *)sureTitle
                sureHandle:(nullable void(^)(void))sure;

+ (void)alertViewWithTitle:(NSString *)title
                   message:(NSString *)message
               cancleTitle:(nullable NSString *)cancleTitle
                 sureTitle:(NSString *)sureTitle
                sureHandle:(nullable void(^)(void))sure
              cancleHandle:(nullable void(^)(void))cansle;

/**
 * 自定义弹窗 AlertAction类型
 * @param title 弹窗标题
 * @param message 内容
 * @param actionArr 回调方法标题数组
 * @param sure 选中按钮index的回调
 */
+ (void)alertActionWithTitle:(nullable NSString *)title
                     message:(nullable NSString *)message
                   actionArr:(NSArray<NSString *> *)actionArr
                actionHandle:(void(^)(int index))sure;

+ (void)vipAlertWithContent:(NSString *)content;

+ (void)videoVIPAlert;
+ (void)vipWithContet:(NSString *)content;

+ (void)dismiss:(void(^)(void))handle;

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentViewController;
+ (UIViewController *)getCurrentViewControllerFrom:(UIViewController *)rootVC;

@end

NS_ASSUME_NONNULL_END
