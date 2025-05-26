//
//  SLHelper.m
//  beijing
//
//  Created by yiliaogao on 2019/1/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLHelper.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "DefineConstants.h"
#import <CoreLocation/CLLocationManager.h>
#import "SLDefaultsHelper.h"
#import "YLJsonExtension.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "JChatConstants.h"
#import "AppDelegate.h"
#import "LXTAlertView.h"
#import <SVProgressHUD.h>
#import <AFHTTPSessionManager.h>
#import "RSA.h"
#import "WelcomeViewController.h"

@implementation SLHelper

+ (CGFloat)labelHeight:(NSString *)str font:(UIFont *)font labelWidth:(CGFloat)width {
    
    CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height;
    
}

+ (CGFloat)labelWidth:(NSString *)str font:(UIFont *)font labelHeight:(CGFloat)height {
    CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];
    return size.width;
}

+ (NSString *)updateTimeForRow:(NSInteger)createTimeInt {
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = createTimeInt;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    NSInteger sec = time/60;
    if (sec < 2) {
        return @"刚刚";
    }
    if (sec<60) {
        return [NSString stringWithFormat:@"%ld分钟前",sec];
    }
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",months];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",years];
}

+ (NSString *)getHHMMSSFromSS:(NSString *)totalTime {
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}

+ (NSString *)getNowTimeTimestamp {
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

+ (NSString *)tempVideoFilePathWithExtension {
    NSString *fileName = [NSString stringWithFormat:@"%@.mp4",[NSUUID UUID].UUIDString];
    NSString *path = NSTemporaryDirectory();
    path = [path stringByAppendingPathComponent:fileName];
    return path;
}

+ (NSString *)tempImageFilePathWithExtension:(UIImage *)image {
    
    NSString *path     = NSTemporaryDirectory();
    NSString *fileName = [NSString stringWithFormat:@"%@.png",[NSUUID UUID].UUIDString];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    [UIImageJPEGRepresentation(image,1.0) writeToFile:filePath  atomically:YES];
    
    return filePath;
}

+ (void)convertVideoQuailtyWithInputURL:(NSURL*)inputURL outputURL:(NSURL*)outputURL completeHandler:(void (^)(AVAssetExportSession*))handler {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 NSLog(@"AVAssetExportSessionStatusCompleted");
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
     }];
}

+ (UIColor *)randomColor {
    NSArray *colorArray = @[XZRGB(0xbe8aff),XZRGB(0x333333),XZRGB(0x62f2fb),XZRGB(0xffe477),XZRGB(0xfea4ff)];
    return colorArray[arc4random_uniform((int)colorArray.count)];
}

+ (NSString *)getMMSSFromSS:(NSString *)totalTime {
    NSInteger seconds = [totalTime integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    if ([str_minute integerValue] < 10) {
        str_minute = [NSString stringWithFormat:@"0%@",str_minute];
    }
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    if ([str_second integerValue] < 10) {
        str_second = [NSString stringWithFormat:@"0%@",str_second];
    }
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    return format_time;
    
}

+ (BOOL)isAppLocationOpen {
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        return YES;
    }
    return NO;
}

+ (UIViewController *)getCurrentVC {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    //获取根控制器
    UIViewController* currentViewController = window.rootViewController;
    
    //获取当前页面控制器
    
    BOOL runLoopFind = YES;
    
    while (runLoopFind){
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]){
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                currentViewController = currentViewController.childViewControllers.lastObject;
                return currentViewController;
            } else {
                return currentViewController;
            }
        }
        
    }
    return currentViewController;
}

+ (UIViewController *)getPresentedViewController {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

+ (BOOL)isUserNotificationEnable {
    // 判断用户是否允许接收通知
    BOOL isEnable = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) { // iOS版本 >=8.0 处理逻辑
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
    } else { // iOS版本 <8.0 处理逻辑
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        isEnable = (UIRemoteNotificationTypeNone == type) ? NO : YES;
    }
    return isEnable;
}

+ (void)savePasteboardString {
    //获取粘贴板上的邀请码
    NSString *shareCode = [UIPasteboard generalPasteboard].string;
    NSString *strNumber = @"0";
    if ([shareCode hasPrefix:@"chat:userId="]) {
        NSArray *array = [shareCode componentsSeparatedByString:@"="];
        strNumber  = [array lastObject];
        [SLDefaultsHelper saveSLDefaults:strNumber key:@"share_code"];
        [UIPasteboard generalPasteboard].string = @"";
    }
}

//TODO, ipcodehandle - start
+ (NSString *)getPasteboardString {
    NSString *str = (NSString *)[SLDefaultsHelper getSLDefaults:@"share_code"];
    return str;
}
//TODO, ipcodehandle - end

+ (NSInteger)getPasteboardCode {
    NSString *str = (NSString *)[SLDefaultsHelper getSLDefaults:@"share_code"];
    return [str integerValue];
}

+ (NSString *)getIPaddress {
    NSString *ipAdrress = nil;
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    NSString *str = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    //var returnCitySN = {"cip": "125.80.129.205", "cid": "500103", "cname": "重庆市渝中区"};
    if (str.length > 0) {
        NSArray *arr = [str componentsSeparatedByString:@"="];
        NSString *json = [arr lastObject];
        
        NSRange startRange = [json rangeOfString:@"{"];
        
        NSRange endRange = [json rangeOfString:@"}"];
        
        NSRange range = NSMakeRange(startRange.location + startRange.length-1, endRange.location - startRange.location - startRange.length+2);
        
        NSString *result = [json substringWithRange:range];
        
        NSDictionary *dic = [YLJsonExtension dictionaryWithJsonString:result];
        ipAdrress = dic[@"cip"];
    }
    
    if (ipAdrress.length == 0) {
        ipAdrress = @"0.0.0.0";
    }
    return ipAdrress;
}

+ (UIImage *)getErweimaImageWithSize:(CGFloat)size link:(NSString *)link {
    // 1.创建过滤器 -- 苹果没有将这个字符封装成常量
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.过滤器恢复默认设置
    [filter setDefaults];
    
    // 3.给过滤器添加数据(正则表达式/帐号和密码) -- 通过KVC设置过滤器,只能设置NSData类型
    NSData *data = [link dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.显示二维码
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];
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

+ (UIImage *)imageWithView:(UIImageView *)imageView {
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, imageView.opaque, [[UIScreen mainScreen] scale]);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error)
    {
        return nil;
    }
    return dic;
}

//+ (void)TIMLoginSuccess:(void(^)(void))success fail:(void (^)(void))fail {
//    [SVProgressHUD show];
//    [YLNetworkInterface getDataWithUserImSig:[YLUserDefault userDefault].t_id block:^(NSString *token) {
//        if (token.length > 0) {
//            //登录腾讯云IM
//
//            TIMLoginParam *loginParam = [[TIMLoginParam alloc] init];
//            NSString *strId = [NSString stringWithFormat:@"%d",[YLUserDefault userDefault].t_id+10000];
//            loginParam.identifier = strId;
//            loginParam.userSig = token;
//            loginParam.appidAt3rd = bascicTecentCloudIMAppId;
//            [[TIMManager sharedInstance] login:loginParam succ:^(){
//                [SVProgressHUD dismiss];
//
//                if (success) {
//                    success();
//                }
//
//                TIMTokenParam *param = [[TIMTokenParam alloc] init];
//            #if DEBUG
//                //开发
//                param.busiId = basicIMPushId_dev;
//            #else
//                //生产
//                param.busiId = basicIMPushId;
//            #endif
//                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                [param setToken:appDelegate.deviceToken];
//                [[TIMManager sharedInstance] setToken:param succ:^{
//                    //更新IM头像和昵称
//
//                    NSString *nickName = (NSString *)[SLDefaultsHelper getSLDefaults:@"user_nick_name"];
//                    NSString *headImage = (NSString *)[SLDefaultsHelper getSLDefaults:@"user_head_image"];
//
//                    [[TIMFriendshipManager sharedInstance] modifySelfProfile:@{TIMProfileTypeKey_Nick:nickName,TIMProfileTypeKey_FaceUrl:headImage} succ:nil fail:nil];
//
//                } fail:nil];
//            } fail:^(int code, NSString * err) {
//                [SVProgressHUD dismiss];
//                if (fail) {
//                    fail();
//                }
//                [LXTAlertView alertViewDefaultOnlySureWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"出错了->code:%d,msg:%@",code,err]];
//            }];
//        }
//    }];
//
//}

+ (void)TIMLoginSuccess:(void(^)(void))success fail:(void (^)(void))fail {
    [SVProgressHUD show];
    [YLNetworkInterface getDataWithUserImSig:[YLUserDefault userDefault].t_id block:^(NSString *token) {
        if (token.length > 0) {
            //登录腾讯云IM
            
            TIMLoginParam *loginParam = [[TIMLoginParam alloc] init];
            NSString *strId = [NSString stringWithFormat:@"%d",[YLUserDefault userDefault].t_id+10000];
            loginParam.identifier = strId;
            loginParam.userSig = token;
            loginParam.appidAt3rd = bascicTecentCloudIMAppId;
            [[TIMManager sharedInstance] login:loginParam succ:^(){
                [SVProgressHUD dismiss];
                
                if (success) {
                    success();
                }
                
                TIMTokenParam *param = [[TIMTokenParam alloc] init];
            #if DEBUG
                //开发
                param.busiId = basicIMPushId_dev;
            #else
                //生产
                param.busiId = basicIMPushId;
            #endif
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [param setToken:appDelegate.deviceToken];
                [[TIMManager sharedInstance] setToken:param succ:^{
                    //更新IM头像和昵称
                    
                    NSString *nickName = (NSString *)[SLDefaultsHelper getSLDefaults:@"user_nick_name"];
                    NSString *headImage = (NSString *)[SLDefaultsHelper getSLDefaults:@"user_head_image"];
                    
                    [[TIMFriendshipManager sharedInstance] modifySelfProfile:@{TIMProfileTypeKey_Nick:nickName,TIMProfileTypeKey_FaceUrl:headImage} succ:nil fail:nil];
                    
                } fail:nil];
            } fail:^(int code, NSString * err) {
                [SVProgressHUD dismiss];
                if (fail) {
                    fail();
                }
//                [LXTAlertView alertViewDefaultOnlySureWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"出错了->code:%d,msg:%@",code,err]];
            }];
        }
    }];
    
}



@end
