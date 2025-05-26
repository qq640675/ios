//
//  NewDetailYHYXTableViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2021/4/12.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "NewDetailYHYXTableViewCell.h"

@implementation NewDetailYHYXTableViewCell
{
    UILabel *scoreL;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma makr - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        [self setSubViews];
    }
    return self;
}

#pragma mark - set data
- (void)setStarNumber:(NSString *)score {
    scoreL.text = @"5.0";
    for (int i = 0; i < 5; i ++) {
        UIImageView *star = [self.contentView viewWithTag:1234+i];
        star.image = [UIImage imageNamed:@"info_star_l_sel"];
    }
    if (score.length == 0 && ![score containsString:@"null"]) return;
    
    scoreL.text = score;
    for (int i = 0; i < 5; i ++) {
        UIImageView *star = [self.contentView viewWithTag:1234+i];
        star.image = [UIImage imageNamed:@"info_star_l"];
    }
    int num = [score intValue];
    for (int i = 0; i < num; i ++) {
        UIImageView *star = [self.contentView viewWithTag:1234+i];
        star.image = [UIImage imageNamed:@"info_star_l_sel"];
    }
}

- (void)setDataWithArray:(NSArray *)dataArr {
    for (int i = 0; i < 3; i ++) {
        UILabel *label = [self.contentView viewWithTag:2345+i];
        label.hidden = YES;
    }
    
    if (dataArr.count == 0) return;
    
    NSInteger num = dataArr.count;
    if (num > 3) {
        num = 3;
    }
    for (int i = 0; i < num; i ++) {
        NSDictionary *dic = dataArr[i];
        UILabel *label = [self.contentView viewWithTag:2345+i];
        label.hidden = NO;
        label.text = [NSString stringWithFormat:@"%@(%@)", dic[@"t_label_name"], dic[@"evaluationCount"]];
    }
}

#pragma mark - subViews
- (void)setSubViews {
    UIView *point = [[UIView alloc] initWithFrame:CGRectMake(15, 17, 6, 6)];
    point.backgroundColor = UIColor.blackColor;
    point.layer.masksToBounds = YES;
    point.layer.cornerRadius = 3;
    [self.contentView addSubview:point];
    
    UILabel *titleL = [UIManager initWithLabel:CGRectMake(32, 10, 150, 20) text:@"用户印象" font:16 textColor:XZRGB(0x333333)];
    titleL.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleL];
    
    for (int i = 0; i < 5; i ++) {
        UIImageView *star = [[UIImageView alloc] initWithFrame:CGRectMake(10+25*i, 45, 25, 25)];
        star.image = [UIImage imageNamed:@"info_star_l_sel"];
        star.contentMode = UIViewContentModeCenter;
        star.tag = 1234+i;
        [self.contentView addSubview:star];
    }
    
    scoreL = [UIManager initWithLabel:CGRectMake(140, 45, 100, 25) text:@"5.0" font:14 textColor:XZRGB(0x333333)];
    scoreL.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:scoreL];
    
    for (int i = 0; i < 3; i ++) {
        UILabel *label = [UIManager initWithLabel:CGRectMake(15+110*i, 80, 100, 30) text:@"颜值超高(50)" font:13 textColor:XZRGB(0x868686)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 6;
        label.layer.borderWidth = 1;
        label.layer.borderColor = XZRGB(0xf1f1f1).CGColor;
        label.tag = 2345+i;
        label.hidden = YES;
        [self.contentView addSubview:label];
    }
    
    UIImageView *rightV = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width-25, 80+(30-14)/2, 8, 14)];
    rightV.image = [UIImage imageNamed:@"accessory"];
    [self.contentView addSubview:rightV];
}


@end
