
/* --- UIColor 分类 --- */

#import <UIKit/UIKit.h>
/**
 渐变方式
 
 - FXGradientChangeDirectionHorizontal:              水平渐变
 - FXGradientChangeDirectionVertical:           竖直渐变
 - FXGradientChangeDirectionUpwardDiagonalLine: 向下对角线渐变
 - FXGradientChangeDirectionDownDiagonalLine:   向上对角线渐变
 */
typedef NS_ENUM(NSInteger, FXGradientChangeDirection) {
    FXGradientChangeDirectionHorizontal,
    FXGradientChangeDirectionVertical,
    FXGradientChangeDirectionUpwardDiagonalLine,
    FXGradientChangeDirectionDownDiagonalLine,
};
NS_ASSUME_NONNULL_BEGIN
#pragma mark - 实例化
#pragma mark -
@interface UIColor (YX_UIColorInstantiation)
/**
 实例化(16进制数字)
 
 @param hex 16进制无符号32位整数
 @return UIColor
 */
+ (instancetype)yx_colorWithHex:(uint32_t)hex;
/**
 实例化(16进制数字+透明度)

 @param hex 16进制无符号32位整数
 @param alpha 透明度(0.0-1.0)
 @return UIColor
 */
+ (instancetype)yx_colorWithHex:(uint32_t)hex withAlpha:(CGFloat)alpha;
/**
 实例化(RGB)
 
 @param red 红
 @param green 绿
 @param blue 蓝
 @return UIColor
 */
+ (instancetype)yx_colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue;
/**
 实例化(随机颜色)
 
 @return UIColor
 */
+ (instancetype)yx_colorRandom;
/**
 实例化(可调节亮度)
 
 @param color 颜色
 @param delta 亮度
 @return UIColor
 */
+ (UIColor *)yx_colorRGBonvertToHSB:(UIColor *)color withBrighnessDelta:(CGFloat)delta;
/**
 实例化(可调节透明度)
 
 @param color 颜色
 @param delta 透明度
 @return UIColor
 */
+ (UIColor *)yx_colorRGBonvertToHSB:(UIColor *)color withAlphaDelta:(CGFloat)delta;


/// 设置随机颜色
/// @param size 控件size
/// @param direction 颜色渐变方向
/// @param startcolor 开始颜色
/// @param endColor 结束颜色
+ (instancetype)bm_colorGradientChangeWithSize:(CGSize)size
                                     direction:(FXGradientChangeDirection)direction
                                    startColor:(UIColor *)startcolor
                                      endColor:(UIColor *)endColor ;


/// 设置随机颜色
/// @param size 控件size
/// @param direction 颜色渐变方向
/// @param colors 颜色数组，格式：(__bridge id)RGB_COLOR(@"#399BEE", 1).CGColor
+ (instancetype)bm_colorGradientChangeWithSize:(CGSize)size
                                     direction:(FXGradientChangeDirection)direction colors:(NSArray *)colors;

//16进制转换
+ (UIColor *) colorWithHexString: (NSString *)color;
@end

#pragma mark - 分类
#pragma mark -
@interface UIColor (YX_UIColorCategory)

@end
NS_ASSUME_NONNULL_END
