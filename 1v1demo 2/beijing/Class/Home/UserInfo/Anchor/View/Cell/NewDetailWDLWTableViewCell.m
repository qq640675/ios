//
//  NewDetailWDLWTableViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2020/4/14.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "NewDetailWDLWTableViewCell.h"
#import "BaseView.h"

@implementation NewDetailWDLWTableViewCell
{
    UILabel *nodataL;
    UILabel *titleL;
}

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
    
    titleL = [UIManager initWithLabel:CGRectMake(32, 10, 150, 20) text:@"TA的礼物" font:16 textColor:XZRGB(0x333333)];
    titleL.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleL];
    
    CGFloat gap = (App_Frame_Width-15-30-240)/6;
    for (int i = 0; i < 6; i ++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15+(40+gap)*i, 45, 40, 40)];
        imageV.image = [UIImage imageNamed:@"loading"];
        imageV.tag = 700+i;
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.hidden = YES;
        [self.contentView addSubview:imageV];
    }
    
    UIImageView *rightV = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width-25, 45+13, 8, 14)];
    rightV.image = [UIImage imageNamed:@"accessory"];
    [self.contentView addSubview:rightV];
    
    nodataL = [UIManager initWithLabel:CGRectMake(32, 50, 150, 30) text:@"暂无礼物" font:14 textColor:XZRGB(0x999999)];
    nodataL.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nodataL];
}

- (void)setCellTitle:(NSString *)cellTitle {
    titleL.text = cellTitle;
}

- (void)setGiftArray:(NSArray *)giftArray {
    [self setDefault];
    NSInteger num = giftArray.count;
    if (num > 0) {
        nodataL.hidden = YES;
    }
    if (num > 6) {
        num = 6;
    }
    for (int i = 0; i < num; i ++) {
        UIImageView *imageV = [self.contentView viewWithTag:700+i];
        imageV.hidden = NO;
        NSDictionary *dic = giftArray[i];
        NSString *t_gift_still_url = [NSString stringWithFormat:@"%@", dic[@"t_gift_still_url"]];
        if (t_gift_still_url.length > 0 && ![t_gift_still_url containsString:@"null"]) {
            [imageV sd_setImageWithURL:[NSURL URLWithString:t_gift_still_url] placeholderImage:[UIImage imageNamed:@"default"]];
        } else {
            imageV.image = [UIImage imageNamed:@"default"];
        }
    }
}

- (void)setDefault {
    for (int i = 0; i < 6; i ++) {
        UIImageView *imageV = [self.contentView viewWithTag:700+i];
        imageV.hidden = YES;
    }
    nodataL.hidden = NO;
}

@end
