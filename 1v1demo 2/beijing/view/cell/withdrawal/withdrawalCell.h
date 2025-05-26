//
//  withdrawalCell.h
//  beijing
//
//  Created by zhou last on 2018/6/21.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface withdrawalCell : UITableViewCell

//日期
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//金额
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
//状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
//查看原因
@property (weak, nonatomic) IBOutlet UIButton *seeReasonButton;


@end
