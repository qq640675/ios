//
//  ToolManager.m
//  beijing
//
//  Created by 黎 涛 on 2019/7/13.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "ToolManager.h"
#import "DefineConstants.h"

@implementation ToolManager

#pragma mark - 将时间戳转换成字符串
+ (NSString *)getTimeFromTimestamp:(NSInteger)time formatStr:(NSString *)formatString {
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

#pragma mark - 获取当前时间戳
+ (NSString *)getNowTimeTimestamp3 {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
}

#pragma mark - 获取字符串的宽度
+ (CGFloat)getWidthWithText:(NSString *)text font:(UIFont *)font {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return size.width;
}

//高度
+ (CGFloat)getHeightWithText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    CGSize size = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return size.height;
}

#pragma mark - 获取一个imageView上面的内容并生成一个image
+ (UIImage *)imageWithView:(UIImageView *)imageView {
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, imageView.opaque, [[UIScreen mainScreen] scale]);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - 生成二维码
+ (UIImage *)createQRCodeWithString:(NSString *)codeStr size:(CGFloat)size {
    //1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];//重绘二维码,使其显示清晰
    return image;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - 生成毛玻璃效果
+ (UIImage *)blurImageWithImage:(UIImage *)image {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return returnImage;
}

#pragma mark - 设置渐变色
+ (void)mutableColor:(UIColor *)startColor end:(UIColor *)endColor isH:(BOOL)isH view:(UIView *)view {
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,(__bridge id)endColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    if (isH == YES) {
        gradientLayer.endPoint = CGPointMake(1.0, 0);
    } else {
        gradientLayer.endPoint = CGPointMake(0, 1.0);
    }
    gradientLayer.locations = @[@0,@1];
    [view.layer addSublayer:gradientLayer];
}

+ (UIButton *)mutableColorButtonWithFrame:(CGRect)frame
                                    title:(NSString *)title
                                     font:(UIFont *)font
                               titleColor:(UIColor *)titleColor
                               startColor:(UIColor *)startColor
                                 endColor:(UIColor *)endColor
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = btn.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)startColor.CGColor,(id)endColor.CGColor]];//渐变数组
    [btn.layer addSublayer:gradientLayer];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    return btn;
}

+ (UIButton *)defaultMutableColorButtonWithFrame:(CGRect)frame title:(NSString *)title isCycle:(BOOL)isCycle {
    UIButton *btn = [self mutableColorButtonWithFrame:frame title:title font:[UIFont systemFontOfSize:16] titleColor:UIColor.whiteColor startColor:XZRGB(0x23a9fe) endColor:XZRGB(0xe84cde)];
    if (isCycle == YES) {
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = frame.size.height/2;
    }
    return btn;
}


#pragma mark - 字典转JSON字符串
+ (NSString *)dictionaryToString:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

@end
