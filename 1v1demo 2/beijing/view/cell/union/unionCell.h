//
//  unionCell.h
//  beijing
//
//  Created by zhou last on 2018/9/11.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unionCell : UITableViewCell

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
//贡献金币
@property (weak, nonatomic) IBOutlet UILabel *coinsLabel;


@end
