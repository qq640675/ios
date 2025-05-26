//
//  newAttentionCell.h
//  beijing
//
//  Created by zhou last on 2018/10/28.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface newAttentionCell : UITableViewCell
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
//个性签名
@property (weak, nonatomic) IBOutlet UILabel *autographLabel;

//状态
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;




@end

NS_ASSUME_NONNULL_END
