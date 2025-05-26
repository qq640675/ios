//
//  NewDetailTDSHTableViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2021/3/11.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "NewDetailTDSHTableViewCell.h"

@implementation NewDetailTDSHTableViewCell
{
    UILabel *nodataL;
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
- (void)setContentWithArr:(NSArray *)arr {
    [self setDefault];
    
    if (arr.count == 0 || arr == nil) return;
        
    nodataL.hidden = YES;
    
    NSInteger num = arr.count;
    if (num > 6) {
        num = 6;
    }
    
    for (int i = 0; i < num; i ++) {
        NSDictionary *dic = arr[i];
        UIView *view = [self.contentView viewWithTag:1000+i];
        view.hidden = NO;
        UIImageView *headIV = [view viewWithTag:2000+i];
        [headIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", dic[@"t_handImg"]]] placeholderImage:[UIImage imageNamed:@"default"]];
    }
}

- (void)setDefault {
    for (int i = 0; i < 6; i ++) {
        UIView *view = [self.contentView viewWithTag:1000+i];
        view.hidden = YES;
    }
    nodataL.hidden = NO;
}

#pragma mark - subViews
- (void)setSubViews {
    UIView *point = [[UIView alloc] initWithFrame:CGRectMake(15, 17, 6, 6)];
    point.backgroundColor = UIColor.blackColor;
    point.layer.masksToBounds = YES;
    point.layer.cornerRadius = 3;
    [self.contentView addSubview:point];
    
    UILabel *titleL = [UIManager initWithLabel:CGRectMake(32, 10, 150, 20) text:@"TA的守护" font:16 textColor:XZRGB(0x333333)];
    titleL.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleL];
    
    for (int i = 0; i < 6; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5+55*i, 50, 55, 60)];
        view.tag = 1000+i;
        view.hidden = YES;
        [self.contentView addSubview:view];
        
        UIImageView *headIV = [[UIImageView alloc] initWithFrame:CGRectMake(8.5, 16, 38, 38)];
        headIV.layer.masksToBounds = YES;
        headIV.layer.cornerRadius = headIV.height/2;
        headIV.contentMode = UIViewContentModeScaleAspectFill;
        headIV.image = [UIImage imageNamed:@"default"];
        headIV.tag = 2000+i;
        [view addSubview:headIV];
        if (i < 3) {
            UIImageView *rankLogo = [[UIImageView alloc] initWithFrame:CGRectMake(7, 0, 41, 54.5)];
            rankLogo.image = [UIImage imageNamed:[NSString stringWithFormat:@"info_rank_%d", i+1]];
            [view addSubview:rankLogo];
        }
    }
    
    UIImageView *rightV = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width-25, 67+12, 8, 14)];
    rightV.image = [UIImage imageNamed:@"accessory"];
    [self.contentView addSubview:rightV];
    
    nodataL = [UIManager initWithLabel:CGRectMake(32, 50, 150, 60) text:@"暂无守护" font:14 textColor:XZRGB(0x999999)];
    nodataL.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nodataL];
}


@end
