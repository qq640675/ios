//
//  newConvertView.h
//  beijing
//
//  Created by zhou last on 2018/11/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface newConvertView : UIView

//所需金币
@property (weak, nonatomic) IBOutlet UILabel *canCoinsLabel;
//立即提现
@property (weak, nonatomic) IBOutlet UIButton *withdrawNowBtn;
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;



@end

NS_ASSUME_NONNULL_END
