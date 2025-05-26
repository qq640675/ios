//
//  SLHelper.h
//  beijing
//
//  Created by yiliaogao on 2019/1/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SLHelper : NSObject

///获取文字的高度
+ (CGFloat)labelHeight:(NSString *)str font:(UIFont *)font labelWidth:(CGFloat)width;

///获取文字的宽度
+ (CGFloat)labelWidth:(NSString *)str font:(UIFont *)font labelHeight:(CGFloat)height;

///时间戳转为几分钟前 几小时前 几天前
+ (NSString *)updateTimeForRow:(NSInteger)createTimeIn;

///创建文件临时路径
+ (NSString *)tempVideoFilePathWithExtension;

///创建视频封面图片临时路径
+ (NSString *)tempImageFilePathWithExtension:(UIImage *)image;

///视频保存路径
+ (void)convertVideoQuailtyWithInputURL:(NSURL*)inputURL outputURL:(NSURL*)outputURL completeHandler:(void (^)(AVAssetExportSession*))handler;

///时间戳转为00:00格式
+ (NSString *)getMMSSFromSS:(NSString *)totalTime;

///秒转为00：00:00
+ (NSString *)getHHMMSSFromSS:(NSString *)totalTime;

// 获取当前时间戳（秒）
+ (NSString *)getNowTimeTimestamp;

///标签随机颜色
+ (UIColor *)randomColor;

///判断定位权限是否开启
+ (BOOL)isAppLocationOpen;

///判断用户通知是否开启
+ (BOOL)isUserNotificationEnable;

///获取当前屏幕显示的VC
+ (UIViewController *)getCurrentVC;

///获取当前屏幕显示的PresentedVC
+ (UIViewController *)getPresentedViewController;

///保存粘贴板内容
+ (void)savePasteboardString;

///获取邀请码
+ (NSInteger)getPasteboardCode;

//TODO, ipcodehandle - start
+ (NSString *)getPasteboardString;
//TODO, ipcodehandle - end

///获取ip地址
+ (NSString *)getIPaddress;

///生成二维码
+ (UIImage *)getErweimaImageWithSize:(CGFloat)size link:(NSString *)link;

///带背景图的二维码图片，用于分享
+ (UIImage *)imageWithView:(UIImageView *)imageView;
//json转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


//TIM
+ (void)TIMLoginSuccess:(void(^)(void))success fail:(void (^)(void))fail;

@end

