//
//  UIAlertCon+Extension.h
//  NewChatDemoTest
//
//  Created by Mac on 2018/5/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^okSel)(UIAlertAction *okSel);
typedef void(^ruleSel)(UIAlertAction *ruleSel);

@interface UIAlertCon_Extension : UIViewController


//登录
+ (void)login:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC share:(okSel)okAction;

//拉黑
+ (void)pullblackMessage:(NSString *)msg style:(UIAlertControllerStyle)style controller:(UIViewController *)VC Pullblack:(okSel)pullblack;

//举报
+ (void)reportType:(UIAlertControllerStyle)style controller:(UIViewController *)VC report:(okSel)reportSel Pullblack:(okSel)pullblack pullTitle:(NSString *)pullTittle;

//公会
+ (void)unionAlertMsg:(NSString *)msg Type:(UIAlertControllerStyle)style controller:(UIViewController *)VC refuse:(okSel)refuseSel accpet:(okSel)accpetSel;

//封号
+ (void)fenghao:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC share:(okSel)okAction;

//封号处理
+ (void)fenghaoAlert:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC delSel:(okSel)delAction oktittle:(NSString *)oktittle ruleAction:(ruleSel)ruleAction;

//余额不足
+ (void)balanceLess:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC recharge:(okSel)rechrgeAciton share:(okSel)shareAction;

//删除
+ (void)alertViewDel:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC delSel:(okSel)delAction;

//查看微信或电话
+ (void)seeWeixinOrPhone:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC delSel:(okSel)delAction  oktittle:(NSString *)oktittle;

//设为封面/删除封面
+ (void)setorDelCover:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC choosePicture:(okSel)pictureAciton camera:(okSel)videoAction;

//照片选择
+ (void)alertViewChoosePictureOrCamera:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC choosePicture:(okSel)choosePictureAction camera:(okSel)cameraAction;

//照片/视频
+ (void)alertViewPictureOrVideo:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC choosePicture:(okSel)pictureAciton camera:(okSel)videoAction;

@end
