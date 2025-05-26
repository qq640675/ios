//
//  closeListCell.h
//  beijing
//
//  Created by zhou last on 2018/10/26.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface closeListCell : UITableViewCell

//排名度
@property (weak, nonatomic) IBOutlet UILabel *rankNumLabel;
//排名图标
@property (weak, nonatomic) IBOutlet UIImageView *rankImgView;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
//亲密度
@property (weak, nonatomic) IBOutlet UILabel *intimacyLabel;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
//lv等级
@property (weak, nonatomic) IBOutlet UIImageView *lvImgView;


//昵称宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidthConstraint;

@end

NS_ASSUME_NONNULL_END
