//
//  NewDetailPJTableViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2020/4/15.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "NewDetailPJTableViewCell.h"
#import "BaseView.h"

@implementation NewDetailPJTableViewCell
{
    UIImageView *headimageV;
    UILabel *nameL;
    UILabel *pjleftL;
    UILabel *pjrightL;
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
    
    headimageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
    headimageV.image = [UIImage imageNamed:@"default"];
    headimageV.layer.masksToBounds = YES;
    headimageV.layer.cornerRadius = 15;
    [self.contentView addSubview:headimageV];
    
    nameL = [UIManager initWithLabel:CGRectMake(55, 10, App_Frame_Width-220, 30) text:@"昵称" font:13 textColor:XZRGB(0x666666)];
    nameL.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameL];
    
    pjrightL = [UIManager initWithLabel:CGRectMake(App_Frame_Width-80, 15, 65, 20) text:@"评价2" font:13 textColor:UIColor.whiteColor];
    pjrightL.backgroundColor = [SLHelper randomColor];;
    pjrightL.layer.masksToBounds = YES;
    pjrightL.layer.cornerRadius = 10;
    pjrightL.hidden = YES;
    [self.contentView addSubview:pjrightL];
    
    pjleftL = [UIManager initWithLabel:CGRectMake(App_Frame_Width-150, 15, 65, 20) text:@"评价1" font:13 textColor:UIColor.whiteColor];
    pjleftL.backgroundColor = [SLHelper randomColor];;
    pjleftL.layer.masksToBounds = YES;
    pjleftL.layer.cornerRadius = 10;
    pjleftL.hidden = YES;
    [self.contentView addSubview:pjleftL];
}

- (void)setCommentHandle:(userCommentHandle *)commentHandle {
    if (![NSString isNullOrEmpty:commentHandle.t_user_hand]) {
        [headimageV sd_setImageWithURL:[NSURL URLWithString:commentHandle.t_user_hand] placeholderImage:[UIImage imageNamed:@"default"]];
    }else{
        headimageV.image = [UIImage imageNamed:@"default"];
    }
    
    if (![NSString isNullOrEmpty:commentHandle.t_user_nick]) {
        nameL.text = commentHandle.t_user_nick;
    }else{
        nameL.text = [NSString stringWithFormat:@"聊友:%d",commentHandle.t_user_id];
    }
    
    NSArray *array = [commentHandle.t_label_name componentsSeparatedByString:@","];
    if (array.count > 0) {
        pjrightL.hidden = NO;
        pjrightL.text = array[0];
    } else {
        pjrightL.hidden = YES;
        pjleftL.hidden = YES;
    }
    if (array.count > 1) {
        pjleftL.hidden = NO;
        pjleftL.text = array[1];
    } else {
        pjleftL.hidden = YES;
    }
}

@end
