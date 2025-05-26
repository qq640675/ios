//
//  newBalanceView.h
//  beijing
//
//  Created by zhou last on 2018/10/25.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface newBalanceView : UIView

//日期选择
@property (weak, nonatomic) IBOutlet UIView *dateSelView;
//年
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
//月
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
//剩余金币
@property (weak, nonatomic) IBOutlet UILabel *coinsLabel;
//收入
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UIView *incomeBgView;

//支出
@property (weak, nonatomic) IBOutlet UILabel *withdrawLabel;
@property (weak, nonatomic) IBOutlet UIView *withdrawBgView;

@end

NS_ASSUME_NONNULL_END
