//
//  UIAlertCon+Extension.m
//  NewChatDemoTest
//
//  Created by Mac on 2018/5/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "UIAlertCon+Extension.h"
#import "DefineConstants.h"


@interface UIAlertCon_Extension ()

@end

@implementation UIAlertCon_Extension

//登录
+ (void)login:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC share:(okSel)okAction
{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:style];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //取消
    }];
    
    UIAlertAction *loginOKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //分享按钮
        okAction(action);
    }];
    
    [alertControl addAction:cancelAction];//cancel
    [alertControl addAction:loginOKAction];//ok
    //    [alertControl addAction:cancelAction];//cancel
    
    //显示警报框
    [VC presentViewController:alertControl animated:YES completion:nil];
}


//拉黑
+ (void)pullblackMessage:(NSString *)msg style:(UIAlertControllerStyle)style controller:(UIViewController *)VC Pullblack:(okSel)pullblack
{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:style];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //取消
    }];
    
    UIAlertAction *pullblackAction = [UIAlertAction actionWithTitle:@"拉黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //分享按钮
        pullblack(action);
    }];
    
    [alertControl addAction:cancelAction];//cancel
    [alertControl addAction:pullblackAction];//ok
    //    [alertControl addAction:cancelAction];//cancel
    
    //显示警报框
    [VC presentViewController:alertControl animated:YES completion:nil];
}

//拉黑 举报
+ (void)reportType:(UIAlertControllerStyle)style controller:(UIViewController *)VC report:(okSel)reportSel Pullblack:(okSel)pullblack pullTitle:(NSString *)pullTittle
{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:style];
    
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //举报按钮
        reportSel(action);
    }];
    
    UIAlertAction *pullblackAction = [UIAlertAction actionWithTitle:pullTittle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //拉黑按钮
        pullblack(action);
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //拉黑按钮
    }];
    
    [alertControl addAction:reportAction];//举报
    [alertControl addAction:pullblackAction];//拉黑
    [alertControl addAction:cancelAction];//cancel

    //    [alertControl addAction:cancelAction];//cancel
    
    //显示警报框
    [VC presentViewController:alertControl animated:YES completion:nil];
}

//公会
+ (void)unionAlertMsg:(NSString *)msg Type:(UIAlertControllerStyle)style controller:(UIViewController *)VC refuse:(okSel)refuseSel accpet:(okSel)accpetSel
{
    //UIAlertControllerStyleAlert
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:style];
    
    UIAlertAction *refuseAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //充值按钮
        refuseSel(action);
    }];
    
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:@"接受" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //分享按钮
        accpetSel(action);
    }];
    
//    NSString *cancelTittle = @"看看再说";
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTittle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        //普通按钮
//    }];
    //    [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    
    //添加按钮（按钮的排列与添加顺序一样，唯独取消按钮会一直在最下面）
    [alertControl addAction:refuseAction];//cancel
    [alertControl addAction:acceptAction];//ok
//    [alertControl addAction:cancelAction];//cancel
    
    //显示警报框
    [VC presentViewController:alertControl animated:YES completion:nil];
//
//    [refuseAction setValue:XZRGB(0x999999) forKey:@"_titleTextColor"];
//    [acceptAction setValue:XZRGB(0xfd49aa) forKey:@"_titleTextColor"];
}


//余额不足
+ (void)fenghao:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC share:(okSel)okAction
{
    //UIAlertControllerStyleAlert
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:style];
    
    UIAlertAction *reAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //充值按钮
        okAction(action);
    }];
    
    
    //添加按钮（按钮的排列与添加顺序一样，唯独取消按钮会一直在最下面）
    [alertControl addAction:reAction];//cancel
    
    //显示警报框
    [VC presentViewController:alertControl animated:YES completion:nil];
}

//余额不足
+ (void)balanceLess:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC recharge:(okSel)rechrgeAciton share:(okSel)shareAction
{
    //UIAlertControllerStyleAlert
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:style];
    
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:msg];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:KBLACKCOLOR range:NSMakeRange(0, msg.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, msg.length)];
    [alertControl setValue:alertControllerStr forKey:@"attributedMessage"];
    
    UIAlertAction *reAction = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //充值按钮
        rechrgeAciton(action);
    }];
    
    UIAlertAction *shareAct = [UIAlertAction actionWithTitle:@"分享赚钱" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //分享按钮
        shareAction(action);
    }];
    

    NSString *cancelTittle = @"看看再说";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTittle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //普通按钮
    }];
    
    //添加按钮（按钮的排列与添加顺序一样，唯独取消按钮会一直在最下面）
    [alertControl addAction:reAction];//cancel
    [alertControl addAction:shareAct];//ok
    [alertControl addAction:cancelAction];//cancel

    //显示警报框
    [VC presentViewController:alertControl animated:YES completion:nil];
//    [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
}

#pragma mark ---- 删除
+ (void)alertViewDel:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC delSel:(okSel)delAction
{
    //UIAlertControllerStyleAlert
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:style];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消按钮
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"personSetDelContactNotification" object:@"0"];
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //普通按钮
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"personSetDelContactNotification" object:@"1"];
        delAction(action);
    }];
    
    
    [alertControl addAction:cancelAction];//cancel
    //添加按钮（按钮的排列与添加顺序一样，唯独取消按钮会一直在最下面）
    [alertControl addAction:okAction];//ok
    
    //显示警报框
    [VC presentViewController:alertControl animated:YES completion:nil];
}

#pragma mark ---- 查看微信号，手机号
+ (void)seeWeixinOrPhone:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC delSel:(okSel)delAction oktittle:(NSString *)oktittle
{
    //UIAlertControllerStyleAlert
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:style];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消按钮
    }];
    
    //_titleTextColor attributedMessage
//    NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:msg];
//    [messageAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, msg.length)];
//    [messageAtt addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(0, msg.length)];

    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:oktittle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //普通按钮
        delAction(action);
    }];
    
    //添加按钮（按钮的排列与添加顺序一样，唯独取消按钮会一直在最下面）
    [alertControl addAction:cancelAction];//cancel
    [alertControl addAction:okAction];//ok
    
    //显示警报框
    [VC presentViewController:alertControl animated:YES completion:nil];
//    [cancelAction setValue:[UIColor lightGrayColor] forKey:@"_titleTextColor"];
}

#pragma mark ---- 封号
+ (void)fenghaoAlert:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC delSel:(okSel)delAction oktittle:(NSString *)oktittle ruleAction:(ruleSel)ruleAction
{
    //UIAlertControllerStyleAlert
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:style];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消按钮
        delAction(action);
    }];
    
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:oktittle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //普通按钮
        ruleAction(action);
    }];
    
    //添加按钮（按钮的排列与添加顺序一样，唯独取消按钮会一直在最下面）
    [alertControl addAction:cancelAction];//cancel
    [alertControl addAction:okAction];//ok
    
    //显示警报框
    [VC presentViewController:alertControl animated:YES completion:nil];
    //    [cancelAction setValue:[UIColor lightGrayColor] forKey:@"_titleTextColor"];
}


#pragma mark ---- 拍照或选择照片弹框
+ (void)alertViewChoosePictureOrCamera:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC choosePicture:(okSel)choosePictureAction camera:(okSel)cameraAction
{
    //UIAlertControllerStyleAlert
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:style];
    
    
    UIAlertAction *cPicturection = [UIAlertAction actionWithTitle:@"图片选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //普通按钮
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"personSetDelContactNotification" object:@"1"];
        choosePictureAction(action);
    }];
    
    
    UIAlertAction *pzAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //取消按钮
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"personSetDelContactNotification" object:@"0"];
        cameraAction(action);
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消按钮
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"personSetDelContactNotification" object:@"0"];
    }];
    
    
    //添加按钮（按钮的排列与添加顺序一样，唯独取消按钮会一直在最下面）
    [alertControl addAction:cPicturection];//选择照片
    [alertControl addAction:pzAction];//拍照
    [alertControl addAction:cancelAction]; //取消
    
    //显示警报框
    [VC presentViewController:alertControl animated:YES completion:nil];
//    [cancelAction setValue:[UIColor lightGrayColor] forKey:@"_titleTextColor"];
}

#pragma mark ---- 设为封面/删除封面
+ (void)setorDelCover:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC choosePicture:(okSel)pictureAciton camera:(okSel)videoAction
{
    //UIAlertControllerStyleAlert
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:style];
    
    UIAlertAction *cPicturection = [UIAlertAction actionWithTitle:@"设为封面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //普通按钮
        pictureAciton(action);
    }];
    
    UIAlertAction *pzAction = [UIAlertAction actionWithTitle:@"删除封面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //取消按钮
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"personSetDelContactNotification" object:@"0"];
        videoAction(action);
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消按钮
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"personSetDelContactNotification" object:@"0"];
    }];
    
    //添加按钮（按钮的排列与添加顺序一样，唯独取消按钮会一直在最下面）
    [alertControl addAction:cPicturection];//选择照片
    [alertControl addAction:pzAction];//拍照
    [alertControl addAction:cancelAction]; //取消
    
    //显示警报框
    [VC presentViewController:alertControl animated:YES completion:nil];
}

#pragma mark ---- 照片/视频
+ (void)alertViewPictureOrVideo:(NSString *)msg type:(UIAlertControllerStyle)style controller:(UIViewController *)VC choosePicture:(okSel)pictureAciton camera:(okSel)videoAction
{
    //UIAlertControllerStyleAlert
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:style];
    
    
    UIAlertAction *cPicturection = [UIAlertAction actionWithTitle:@"图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //普通按钮
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"personSetDelContactNotification" object:@"1"];
        pictureAciton(action);
    }];
    
    
    UIAlertAction *pzAction = [UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //取消按钮
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"personSetDelContactNotification" object:@"0"];
        videoAction(action);
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消按钮
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"personSetDelContactNotification" object:@"0"];
    }];
    
    
    //添加按钮（按钮的排列与添加顺序一样，唯独取消按钮会一直在最下面）
    [alertControl addAction:cPicturection];//选择照片
    [alertControl addAction:pzAction];//拍照
    [alertControl addAction:cancelAction]; //取消
    
    //显示警报框
    [VC presentViewController:alertControl animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
