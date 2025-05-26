//
//  detailHistoryCell.h
//  beijing
//
//  Created by zhou last on 2018/6/21.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailHistoryCell : UITableViewCell

//类型 如：发红包
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
//日期 如2018-06-10
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//金额 如 -28.8
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;


@end
