//
//  messageCell.h
//  beijing
//
//  Created by zhou last on 2018/6/25.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface messageCell : UITableViewCell

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;
//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentConstraint;
//im消息时间
@property (weak, nonatomic) IBOutlet UILabel *imsgTimeLabel;
//未读消息个数
@property (weak, nonatomic) IBOutlet UILabel *unreadNumLabel;

//我的通话
@property (weak, nonatomic) IBOutlet UILabel *mycallingLabel;
//官方
@property (weak, nonatomic) IBOutlet UILabel *guanfanglabel;

@end
