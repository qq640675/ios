//
//  newWithDrawView.h
//  beijing
//
//  Created by zhou last on 2018/11/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface newWithDrawView : UIView


//tip1-支付密码
@property (weak, nonatomic) IBOutlet UILabel *tip1Label;

@property (weak, nonatomic) IBOutlet UITextField *paypassField;

//tip2-请选择提现方式
@property (weak, nonatomic) IBOutlet UILabel *tip2Label;

//可提现金币
@property (weak, nonatomic) IBOutlet UILabel *myWithdrawCoinLabel;

//提现方式背景
@property (weak, nonatomic) IBOutlet UIView *withdrawMethodView;

//支付宝
@property (weak, nonatomic) IBOutlet UIButton *apliyBtn;
//微信
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;

//帐号
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

//立即绑定
@property (weak, nonatomic) IBOutlet UIButton *bangBtn;


@end

NS_ASSUME_NONNULL_END
