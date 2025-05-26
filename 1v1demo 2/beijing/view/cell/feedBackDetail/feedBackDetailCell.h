//
//  feedBackDetailCell.h
//  beijing
//
//  Created by zhou last on 2018/7/24.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface feedBackDetailCell : UITableViewCell

//反馈内容或反馈结果
@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;
//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//图片背景框
@property (weak, nonatomic) IBOutlet UIView *ImgBackView;

//需要判断反馈结果有没有图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageConstraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeight;

@end

