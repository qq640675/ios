//
//  SLAlertController.h
//  beijing
//
//  Created by yiliaogao on 2018/12/29.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertControllerAlertSureActionBlock)(void);
typedef void(^AlertControllerAlertCancelActionBlock)(void);
typedef void(^AlertControllerSheetActionBlock)(UIAlertAction *didSelectAction);

@interface SLAlertController : UIViewController

/**
 系统提示弹窗

 @param style 样式
 @param controller 显示的控制器
 @param title 标题
 @param message 摘要
 @param actionTitles 操作按钮标题数组(UIAlertControllerStyleActionSheet)
 @param sureTitle 确定标题 (UIAlertControllerStyleAlert)
 @param cancelTitle 取消标题
 @param sheetBlock 操作回调
 @param sureBlock 确定回调
 @param cancelBlock 取消回调
 */
+ (void)alertControllerWithStyle:(UIAlertControllerStyle)style
                      controller:(UIViewController *)controller
            alertControllerTitle:(NSString *)title
          alertControllerMessage:(NSString *)message
alertControllerSheetActionTitles:(NSArray *)actionTitles
  alertControllerSureActionTitle:(NSString *)sureTitle
alertControllerCancelActionTitle:(NSString *)cancelTitle
 alertControllerSheetActionBlock:(AlertControllerSheetActionBlock)sheetBlock
alertControllerAlertSureActionBlock:(AlertControllerAlertSureActionBlock)sureBlock
alertControllerAlertCancelActionBlock:(AlertControllerAlertCancelActionBlock)cancelBlock;

@end

