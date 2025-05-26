//
//  conversationHistoryCell.h
//  beijing
//
//  Created by zhou last on 2018/10/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface conversationHistoryCell : UITableViewCell

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
//通话时间
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;
//通话结束时间
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
//类型
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;


@end

NS_ASSUME_NONNULL_END
