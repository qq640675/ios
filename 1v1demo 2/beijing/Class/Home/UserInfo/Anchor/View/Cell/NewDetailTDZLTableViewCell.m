//
//  NewDetailTDZLTableViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2020/4/14.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "NewDetailTDZLTableViewCell.h"
#import "BaseView.h"

@implementation NewDetailTDZLTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - init
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

#pragma mark - UI
- (void)setSubViews {
    UIView *point = [[UIView alloc] initWithFrame:CGRectMake(15, 17, 6, 6)];
    point.backgroundColor = UIColor.blackColor;
    point.layer.masksToBounds = YES;
    point.layer.cornerRadius = 3;
    [self.contentView addSubview:point];
    
    UILabel *titleL = [UIManager initWithLabel:CGRectMake(32, 10, 150, 20) text:@"TA的资料" font:16 textColor:XZRGB(0x333333)];
    titleL.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleL];
    
    NSArray *defaultValueArr = @[@"身高：", @"体重：", @"婚姻：", @"职业：", @""];
    for (int i = 0; i < defaultValueArr.count ; i ++) {
        UILabel *label = [UIManager initWithLabel:CGRectZero text:defaultValueArr[i] font:14 textColor:XZRGB(0x333333)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 15;
        label.backgroundColor = XZRGB(0xf5f5f5);
        label.tag = 500+i;
        [self.contentView addSubview:label];
        if (i == 0) {
            label.frame = CGRectMake(15, 45, 110, 30);
        } else if (i == 1) {
            label.frame = CGRectMake(140, 45, 100, 30);
        } else if (i == 2) {
            label.frame = CGRectMake(255, 45, 100, 30);
        } else if (i == 3) {
            label.frame = CGRectMake(15, 100, 110, 30);
        } else if (i == 4) {
            label.frame = CGRectMake(140, 100, 170, 30);
        }
    }
}

- (void)setInfoHandle:(godnessInfoHandle *)infoHandle {
    UILabel *sgL = [self.contentView viewWithTag:500];
    UILabel *tzL = [self.contentView viewWithTag:501];
    UILabel *hyL = [self.contentView viewWithTag:502];
    UILabel *zyL = [self.contentView viewWithTag:503];
    UILabel *timeL = [self.contentView viewWithTag:504];
    if (infoHandle.t_height.length > 0 && ![infoHandle.t_height containsString:@"null"]) {
        sgL.text = [NSString stringWithFormat:@"身高：%@cm", infoHandle.t_height];
    } else {
        sgL.text = @"身高：";
    }
    if (infoHandle.t_weight.length > 0 && ![infoHandle.t_weight containsString:@"null"]) {
        tzL.text = [NSString stringWithFormat:@"体重：%@kg", infoHandle.t_weight];
    } else {
        tzL.text = @"体重：";
    }
    if (infoHandle.t_marriage.length > 0 && ![infoHandle.t_marriage containsString:@"null"]) {
        hyL.text = [NSString stringWithFormat:@"婚姻：%@", infoHandle.t_marriage];
    } else {
        hyL.text = @"婚姻：保密";
    }
    if (infoHandle.t_vocation.length > 0 && ![infoHandle.t_vocation containsString:@"null"]) {
        zyL.text = [NSString stringWithFormat:@"职业：%@", infoHandle.t_vocation];
    } else {
        zyL.text = @"职业：";
    }
    if (infoHandle.t_login_time.length > 0 && ![infoHandle.t_login_time containsString:@"null"]) {
        timeL.text = infoHandle.t_login_time;
        timeL.hidden = NO;
    } else {
        timeL.hidden = YES;
    }
}


@end
