//
//  NSString+Util.m
//  CQTNews
//
//  Created by ANine on 6/8/16.
//  Copyright © 2016 zzh. All rights reserved.
//

#import "NSString+Util.h"
#import <CoreText/CoreText.h>
#import "CommonCrypto/CommonDigest.h"

//获取IP地址的时候用
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <SVProgressHUD.h>

@implementation NSString (Util)

- (NSString *)getMd5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)self.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}


+ (BOOL) isNullOrEmpty:(NSString *)string{
    return string == nil
    || [string isEqual: (id)[NSNull null]]
    || [string isKindOfClass:[NSString class]] == NO
    || [@"" isEqualToString:string]
    || [@"<null>" isEqualToString:string]
    || [@"(null)" isEqualToString:string]
    || [[string stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0
    || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}


+ (NSMutableData *)encodeSocket:(NSString *)conent
{
    Byte foreByte[]={0,-86,-69,-52};
    Byte backByte[]={0,-86,-69,-52};
    
    NSMutableData *mudata = [NSMutableData data];
    [mudata appendBytes:foreByte length:4];
    
    NSInteger contentLength = conent.length;
    
    Byte lenByte[] = {0,0,0,conent.length};
    
    lenByte[0] =(Byte) ((contentLength & 0x000000FF) <<24);
    lenByte[1] =(Byte) ((contentLength & 0x000000FF) <<16);
    lenByte[2] =(Byte) ((contentLength & 0x000000FF) <<8);
    
    [mudata appendBytes:lenByte length:4];
    
    NSData* contentData = [conent dataUsingEncoding:NSUTF8StringEncoding];
    [mudata appendData:contentData];
    
    [mudata appendBytes:backByte length:4];
    
    return mudata;
}

+ (void)adjustScrollView:(UIScrollView *)scrollView VC:(const  UIViewController *)vc nav:(float)nav tabbar:(int)tabbar
{
    vc.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        vc.automaticallyAdjustsScrollViewInsets = NO;
    }
    // 设置tableView的内边距(能够显示出导航栏和tabBar下覆盖的内容)
    scrollView.contentInset = UIEdgeInsetsMake(nav, 0, tabbar, 0);
}


+ (NSString *)deviceIPAdress {
    
    NSString *address = @"an error occurred when obtaining ip address";
    
    struct ifaddrs *interfaces = NULL;
    
    struct ifaddrs *temp_addr = NULL;
    
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        
        while (temp_addr != NULL) {
            
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                
                // Check if interface is en0 which is the wifi connection on the iPhone
                
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    
                    // Get NSString from C String
                    
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in  *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
            
        }
        
    }
    
    freeifaddrs(interfaces);
    
    return address;
    
}


+(NSString *)getWANIP
{
    //通过淘宝的服务来定位WAN的IP，否则获取路由IP没什么用
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    //判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        //对字符串进行处理，然后进行json解析
        //删除字符串多余字符串
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        //将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
        return dict[@"cip"] ? dict[@"cip"] : @"0.0.0.0";
    }
    return @"0.0.0.0";
}

+ (NSString *)defaultUserAgentString

{
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    // Attempt to find a name for this application
    
    NSString *appName = [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    if (!appName) {
        
        appName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
        
    }
    
    NSData *latin1Data = [appName dataUsingEncoding:NSUTF8StringEncoding];
    
    appName = [[NSString alloc] initWithData:latin1Data encoding:NSISOLatin1StringEncoding];
    
    // If we couldn't find one, we'll give up (and ASIHTTPRequest will use the standard CFNetwork user agent)
    
    if (!appName) {
        
        return nil;
        
    }
    
    NSString *appVersion = nil;
    
    NSString *marketingVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString *developmentVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    if (marketingVersionNumber && developmentVersionNumber) {
        
        if ([marketingVersionNumber isEqualToString:developmentVersionNumber]) {
            
            appVersion = marketingVersionNumber;
            
        } else {
            
            appVersion = [NSString stringWithFormat:@"%@ rv:%@",marketingVersionNumber,developmentVersionNumber];
            
        }
        
    } else {
        
        appVersion = (marketingVersionNumber ? marketingVersionNumber : developmentVersionNumber);
        
    }
    
    NSString *deviceName;
    
    NSString *OSName;
    
    NSString *OSVersion;
    
    //    NSString *locale = [[NSLocale currentLocale] localeIdentifier];
    
#if TARGET_OS_IPHONE
    
    UIDevice *device = [UIDevice currentDevice];
    
    deviceName = [device model];
    
    OSName = [device systemName];
    
    OSVersion = [device systemVersion];
    #else
    
    deviceName = @"Macintosh";
    
    OSName = @"Mac OS X";
    
    // From http://www.cocoadev.com/index.pl?DeterminingOSVersion
    
    // We won't bother to check for systems prior to 10.4, since ASIHTTPRequest only works on 10.5+
    
    OSErr err;
    
    SInt32 versionMajor, versionMinor, versionBugFix;
    
    err = Gestalt(gestaltSystemVersionMajor, &versionMajor);
    
    if (err != noErr) return nil;
    
    err = Gestalt(gestaltSystemVersionMinor, &versionMinor);
    
    if (err != noErr) return nil;
    
    err = Gestalt(gestaltSystemVersionBugFix, &versionBugFix);
    
    if (err != noErr) return nil;
    
    //    NSLog(@"_________________%@ %@ %@",versionMajor,versionMinor,versionBugFix);
    
    OSVersion = [NSString stringWithFormat:@"%u_%u_%u", versionMajor, versionMinor, versionBugFix];
    
#endif
    
    
    OSVersion =  [OSVersion stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    
    
    // Takes the form "My Application 1.0 (Macintosh; Mac OS X 10.5.7; en_GB)"
//    if ([OSVersion floatValue] < 10.0) {
//        NSLog(@"______OSVersion:%@",[NSString stringWithFormat:@"iPhone OS %@ |",OSVersion]);
//
//        return [NSString stringWithFormat:@"iPhone OS %@ |",OSVersion];
//    }else{
        NSLog(@"______OSVersion:%@",[NSString stringWithFormat:@"iPhone OS %@",OSVersion]);

        return [NSString stringWithFormat:@"iPhone OS %@",OSVersion];
//    }
}

+ (BOOL)getIsIpad

{
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    
    
    if([deviceType isEqualToString:@"iPhone"]) {
        
        //iPhone
        
        return NO;
        
    }
    
    else if([deviceType isEqualToString:@"iPod touch"]) {
        
        //iPod Touch
        
        return NO;
        
    }
    
    else if([deviceType isEqualToString:@"iPad"]) {
        
        //iPad
        
        return YES;
        
    }
    
    return NO;
    
}

+ (NSString *)getStringWithEmpty:(NSString *)string{
    return [NSString isNullOrEmpty:string] ? @"" : string;
}
- (NSString *)noWhiteSpaceString {
    NSString *newString = self;
    //去除掉首尾的空白字符和换行字符
    newString = [newString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    newString = [newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符使用
    newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    可以去掉空格，注意此时生成的strUrl是autorelease属性的，所以不必对strUrl进行release操作！
    return newString;
}



+ (void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    if (@available(iOS 10.0, *)) {
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            NSLog(@"<Open> %@: %d",scheme,success);
        }];
    } else {
        // Fallback on earlier versions
        BOOL success = [application openURL:URL];

        NSLog(@"<Open> %@: %d",scheme,success);
    }
}

- (NSString *)proccessNilString {
    return self == nil ? @"暂无信息" : self;
}

+ (BOOL)isVersion:(NSString*)versionA biggerThanVersion:(NSString*)versionB {
    NSArray *arrayNow = [versionB componentsSeparatedByString:@"."];
    NSArray *arrayNew = [versionA componentsSeparatedByString:@"."];
    BOOL isBigger = NO;
    NSInteger i = arrayNew.count > arrayNow.count? arrayNow.count : arrayNew.count;
    NSInteger j = 0;
    BOOL hasResult = NO;
    for (j = 0; j < i; j ++) {
        NSString* strNew = [arrayNew objectAtIndex:j];
        NSString* strNow = [arrayNow objectAtIndex:j];
        if ([strNew integerValue] > [strNow integerValue]) {
            hasResult = YES;
            isBigger = YES;
            break;
        }
        if ([strNew integerValue] < [strNow integerValue]) {
            hasResult = YES;
            isBigger = NO;
            break;
        }
    }
    if (!hasResult) {
        if (arrayNew.count > arrayNow.count) {
            NSInteger nTmp = 0;
            NSInteger k = 0;
            for (k = arrayNow.count; k < arrayNew.count; k++) { 
                nTmp += [[arrayNew objectAtIndex:k]integerValue]; 
            } 
            if (nTmp > 0) { 
                isBigger = YES; 
            } 
        } 
    } 
    return isBigger; 
}

+ (NSInteger)getLinesArrayOfStringInLabel:(UILabel *)label {
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName((CFStringRef)font.fontName,
                                            font.pointSize,
                                            NULL);
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
//    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
//    for (id line in lines)
//    {
//        CTLineRef lineRef = (__bridge CTLineRef )line;
//        CFRange lineRange = CTLineGetStringRange(lineRef);
//        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
//        
//        NSString *lineString = [text substringWithRange:range];
//        [linesArray addObject:lineString];
//    }
    
    return lines.count;
}

+ (NSString*)encodeString:(NSString*)unencodedString {
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
//    NSString *encodedString = (NSString *)
//    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                              (CFStringRef)unencodedString,
//                                                              NULL,
//                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                              kCFStringEncodingUTF8));

    NSString*escapedUrlString= (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)unencodedString,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    escapedUrlString = [escapedUrlString stringByAddingPercentEscapesUsingEncoding:kCFStringEncodingUTF8];
    return escapedUrlString;
}

+ (BOOL)hasContainsOrginString:(NSString *)string checkString:(NSString *)checkSatring {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
    NSRange containsStringRange = [string rangeOfString:checkSatring];
    if (containsStringRange.length > 0) {
        return YES;
    } else {
        return NO;
    }
#else
    if ([string containsString:checkSatring]) {
        return YES;
    } else {
        return NO;
    }
#endif
    return NO;
}

//授权相机
+ (void)checkVideoAuthStatus:(YLPrivilegyBlock)block
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        NSLog(@"%@",granted ? @"相机准许":@"相机不准许");
        if (!granted) {
            [SVProgressHUD showInfoWithStatus:@"请到系统设置开启相机权限"];
        }

        block(granted);
    }];
}

//检查麦克风权限
+ (void) checkAudioStatus:(YLPrivilegyBlock)block{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            //没有询问是否开启麦克风
            block(YES);
            break;
        case AVAuthorizationStatusRestricted:
            //未授权，家长限制
            [SVProgressHUD showInfoWithStatus:@"请到系统设置开启麦克风权限"];

            block(NO);
//            self.audioStatus = @"AVAuthorizationStatusRestricted";
            break;
        case AVAuthorizationStatusDenied:
            //玩家未授权
            [SVProgressHUD showInfoWithStatus:@"请到系统设置开启麦克风权限"];

            block(NO);
//            self.audioStatus = @"AVAuthorizationStatusDenied";
            break;
        case AVAuthorizationStatusAuthorized:
            //玩家授权
            block(YES);
//            self.audioStatus = @"AVAuthorizationStatusAuthorized";
            break;
        default:
            [SVProgressHUD showInfoWithStatus:@"请到系统设置开启麦克风权限"];

            block(NO);
            break;
    }
}


@end
