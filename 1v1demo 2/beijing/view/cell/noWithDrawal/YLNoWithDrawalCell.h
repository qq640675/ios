//
//  YLNoWithDrawalCell.h
//  beijing
//
//  Created by zhou last on 2018/6/21.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLNoWithDrawalCell : UITableViewCell

//日期
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//金额
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
//查看详情
@property (weak, nonatomic) IBOutlet UIButton *seeDetailButton;


@end
