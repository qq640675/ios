//
//  SLAlertController.m
//  beijing
//
//  Created by yiliaogao on 2018/12/29.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "SLAlertController.h"

@interface SLAlertController ()

@end

@implementation SLAlertController

+ (void)alertControllerWithStyle:(UIAlertControllerStyle)style
                      controller:(UIViewController *)controller
            alertControllerTitle:(NSString *)title
          alertControllerMessage:(NSString *)message
alertControllerSheetActionTitles:(NSArray *)actionTitles
  alertControllerSureActionTitle:(NSString *)sureTitle
alertControllerCancelActionTitle:(NSString *)cancelTitle
 alertControllerSheetActionBlock:(AlertControllerSheetActionBlock)sheetBlock
alertControllerAlertSureActionBlock:(AlertControllerAlertSureActionBlock)sureBlock
alertControllerAlertCancelActionBlock:(AlertControllerAlertCancelActionBlock)cancelBlock {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    if (style == UIAlertControllerStyleActionSheet) {
        for (int i = 0; i < [actionTitles count]; i++) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (sheetBlock) {
                    sheetBlock(actionTitles[i]);
                }
            }];
            [alertController addAction:action];
        }
    } else {
        if (sureTitle.length > 0) {
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (sureBlock) {
                    sureBlock();
                }
            }];
            [alertController addAction:sureAction];
        }
    }
    
    UIAlertActionStyle cancelStyle = UIAlertActionStyleDefault;
    if (style == UIAlertControllerStyleActionSheet) {
        cancelStyle = UIAlertActionStyleCancel;
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:cancelStyle handler:^(UIAlertAction * _Nonnull action) {
        if (cancelBlock) {
            cancelBlock();
        }
    }];
    [alertController addAction:cancelAction];
    
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [controller presentViewController:alertController animated:YES completion:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
