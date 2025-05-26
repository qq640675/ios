//
//  ToolManager.h
//  beijing
//
//  Created by 黎 涛 on 2019/7/13.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToolManager : NSObject

#pragma mark - 将时间戳转换成字符串
/**
 将时间戳转换成字符串

 @param time 时间戳 秒为单位 如果是毫秒 须先除以1000
 @param formatString 时间格式 YYYY MM dd HH mm ss
 @return 返回时间戳字符串
 */
+ (NSString *)getTimeFromTimestamp:(NSInteger)time formatStr:(NSString *)formatString;

/**
 获取当前时间戳

 @return 返回毫秒  字符串
 */
#pragma mark - 获取当前时间戳
+ (NSString *)getNowTimeTimestamp3;

#pragma mark - 获取字符串的宽度
/**
 获取字符串的宽度

 @param text 字符串内容
 @param font 字符串的font
 @return 返回字符串的宽度
 */
+ (CGFloat)getWidthWithText:(NSString *)text font:(UIFont *)font;
// height
+ (CGFloat)getHeightWithText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth;

#pragma mark - 获取一个imageView上面的内容并生成一个image
/**
获取一个imageView上面的内容并生成一个image

 @param imageView 使用的imageView
 @return 返回一个内容的iamge
 */
+ (UIImage *)imageWithView:(UIImageView *)imageView;

#pragma mark - 生成二维码
/**
 生成二维码

 @param codeStr 二维码内容字符串
 @param size 生成二维码图片的尺寸边长
 @return 返回二维码图片
 */
+ (UIImage *)createQRCodeWithString:(NSString *)codeStr size:(CGFloat)size;
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

#pragma mark - 生成毛玻璃效果
/**
 生成毛玻璃效果

 @param image 原图片image
 @return 毛玻璃image
 */
+ (UIImage *)blurImageWithImage:(UIImage *)image;

#pragma mark - 设置渐变色

/// 设置渐变色
/// @param startColor 开始颜色
/// @param endColor 结束颜色
/// @param isH 是否水平方向
/// @param view 变色的视图
+ (void)mutableColor:(UIColor *)startColor end:(UIColor *)endColor isH:(BOOL)isH view:(UIView *)view;
+ (UIButton *)mutableColorButtonWithFrame:(CGRect)frame
                                    title:(NSString *)title
                                     font:(UIFont *)font
                               titleColor:(UIColor *)titleColor
                               startColor:(UIColor *)startColor
                                 endColor:(UIColor *)endColor;
+ (UIButton *)defaultMutableColorButtonWithFrame:(CGRect)frame title:(NSString *)title isCycle:(BOOL)isCycle;

#pragma mark - 字典转字符串
+ (NSString *)dictionaryToString:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
