//
//  DefineConstants.h
//  NewChatDemoTest
//
//  Created by Mac on 2018/5/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#ifndef DefineConstants_h
#define DefineConstants_h

#define WEAKSELF __weak __typeof(self)weakSelf = self;
#define STRONGSELF __strong __typeof(weakSelf)strongSelf = weakSelf;

#define APP_Frame_Height   [[UIScreen mainScreen] bounds].size.height
#define App_Frame_Width    [[UIScreen mainScreen] bounds].size.width

#define APP_FRAME_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define APP_FRAME_WIDTH    [[UIScreen mainScreen] bounds].size.width

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
// iPhone4S
#define IS_iPhone_4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
// iPhone5 iPhone5s iPhoneSE
#define IS_iPhone_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// iPhone6 7 8
#define IS_iPhone_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)
// iPhone6plus  iPhone7plus iPhone8plus
#define IS_iPhone6_Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
// iPhoneX
#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define IOS11_OR_LATER_SPACE(par) \
({\
float space = 0.0;\
if (@available(iOS 11.0, *))\
space = par;\
(space);\
})

#define JF_KEY_WINDOW [UIApplication sharedApplication].keyWindow
#define JF_TOP_SPACE IOS11_OR_LATER_SPACE(JF_KEY_WINDOW.safeAreaInsets.top)
#define JF_TOP_ACTIVE_SPACE IOS11_OR_LATER_SPACE(MAX(0, JF_KEY_WINDOW.safeAreaInsets.top-20))
#define JF_BOTTOM_SPACE IOS11_OR_LATER_SPACE(JF_KEY_WINDOW.safeAreaInsets.bottom)

#define SLImageName(image) [UIImage imageNamed:(image)]
#define IChatUImage(image) [UIImage imageNamed:(image)]
#define IChatBackGImage(faceBtn) [faceBtn currentBackgroundImage]
#define IChatSetBackColor(view,image) [view setBackgroundColor:[UIColor colorWithPatternImage:image]]
#define IChatSetBackGImage(Button,image) [Button setBackgroundImage:IChatUImage(image) forState:UIControlStateNormal];
#define IChatSetBackSelectedGImage(Button,image) [Button setBackgroundImage:IChatUImage(image) forState:UIControlStateSelected];
#define IColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define XZRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

//Notification
#define kAlertToSendImage @"AlertToSendImage"
#define kDeleteMessage @"DeleteMessage"

//默认选中颜色
#define KDEFAULTCOLOR XZRGB(0xAE4FFD)
//默认黑色颜色
#define KDEFAULTBLACKCOLOR XZRGB(0x333333)
//白色
#define KWHITECOLOR [UIColor whiteColor]
//黑色
#define KBLACKCOLOR [UIColor blackColor]
//在线状态
#define KONLINECOLOR XZRGB(0x06bf06)
//离线状态
#define KOFFLINECOLOR XZRGB(0x353553)
//透明颜色
#define KCLEARCOLOR [UIColor clearColor]

//NavigationBar
#define kGoBackBtnImageOffset UIEdgeInsetsMake(0, 0, 0, 15)
#define kNavigationLeftButtonRect CGRectMake(0, 0, 30, 30)

//window
#define YLAppWindow [UIApplication sharedApplication].keyWindow

#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define SafeAreaTopHeight (IPHONE_X ? 88 : 64)
#define NAVIGATIONBAR_HEIGHT (IPHONE_X ? 88 : 64)

#define SafeAreaBottomHeight (IPHONE_X ? (49 + 34) : 49)

#define PingFangSCFont(FONTSIZE) (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)? [UIFont fontWithName:@"PingFangSC-Regular" size:FONTSIZE]:[UIFont fontWithName:@"Arial" size:FONTSIZE])

#endif /* DefineConstants_h */

#define APP_version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_create_version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]






// -----------------------
// 获取临时访问地址的ip  在现有域名访问失效时 替换使用临时地址访问
#define get_temporary_socket [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"get_temporary_socket"]]
#define get_temporary_ip [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"get_temporary_ip"]]
// ------------------------


//- - - - - 上线打包 务必注释此行代码 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//#define is_debug 1  //- - - - - 上线打包 务必注释此行代码 - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//- - - - - 上线打包 务必注释此行代码 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// xiugai
//#ifdef is_debug
//
//#define SOCKETIP           @"mina.cbczose.cn"
//#define INTERFACEADDRESS   @"https://app.cbczose.cn/"
//#define IPCODEURL   @"https://yao.cbczose.cn/"
//
//#else
//
//
//#define SOCKETIP           @"mina.cbczose.cn"
//#define INTERFACEADDRESS   @"https://app.cbczose.cn/"
//#define IPCODEURL   @"https://yao.cbczose.cn/"
//
//#endif


#ifdef is_debug

//#buildConfigField "String", "socketIp", "\"mina.cazim.cn\""
//#buildConfigField "String", "hostAddress", "\"https://api.cazim.cn/\""
//#buildConfigField "String", "ipcodeurl", "\"http://yao.afxa.cn/\""

//#define SOCKETIP           @"mina.cazim.cn"
//#define INTERFACEADDRESS   @"https://api.cazim.cn/"
//#define IPCODEURL   @"http://yao.afxa.cn/"

#else


#define SOCKETIP           @"ysws.xiwenwangluo.cn"
#define INTERFACEADDRESS   @"https://ysws.xiwenwangluo.cn/chatApp"
#define IPCODEURL   @"http://yswsshare.xiwenwangluo.cn"

#endif
