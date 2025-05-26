//
//  liveSuffiView.h
//  beijing
//
//  Created by zhou last on 2018/12/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface liveSuffiView : UIView

//透明
@property (weak, nonatomic) IBOutlet UIView *alphaView;
//余额框
@property (weak, nonatomic) IBOutlet UIView *insuffBgView;
//提示
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
//忽略
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
//充值
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;

- (void)cordius;

@end

NS_ASSUME_NONNULL_END
