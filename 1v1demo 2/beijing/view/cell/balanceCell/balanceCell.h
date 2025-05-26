//
//  balanceCell.h
//  beijing
//
//  Created by zhou last on 2018/10/25.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface balanceCell : UITableViewCell

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
//名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//金币
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;


@end

NS_ASSUME_NONNULL_END
