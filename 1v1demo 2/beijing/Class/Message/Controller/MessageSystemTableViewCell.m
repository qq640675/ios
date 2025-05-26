//
//  MessageSystemTableViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2021/3/30.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "MessageSystemTableViewCell.h"

@implementation MessageSystemTableViewCell
{
    UIImageView *logoIV;
    UILabel *titelL;
    UILabel *contentL;
    UILabel *numL;
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

#pragma mark - subViews
- (void)setSubViews {
    logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
    logoIV.clipsToBounds = YES;
    logoIV.layer.cornerRadius = 25.0f;
    [self.contentView addSubview:logoIV];
    
    titelL = [UIManager initWithLabel:CGRectZero text:@"" font:14 textColor:UIColor.blackColor];
    titelL.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titelL];
    [titelL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->logoIV.mas_right).offset(10);
        make.top.equalTo(self->logoIV.mas_top).offset(5);
        make.width.mas_equalTo(App_Frame_Width-130);
        make.height.mas_equalTo(20);
    }];
    
    contentL = [UIManager initWithLabel:CGRectZero text:@"" font:14 textColor:XZRGB(0x868686)];
    contentL.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:contentL];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->logoIV.mas_right).offset(10);
        make.bottom.equalTo(self->logoIV.mas_bottom).offset(-5);
        make.width.mas_equalTo(App_Frame_Width-130);
        make.height.mas_equalTo(20);
    }];
    
    numL = [UIManager initWithLabel:CGRectMake(App_Frame_Width-35, 25, 20, 20) text:@"99+" font:10 textColor:UIColor.whiteColor];
    numL.backgroundColor = XZRGB(0xfe2947);
    numL.layer.masksToBounds = YES;
    numL.layer.cornerRadius = numL.width/2;
    numL.hidden = YES;
    [self.contentView addSubview:numL];
    [numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self->contentL.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

#pragma mark - set data
- (void)setLogo:(NSString *)logoName title:(NSString *)title {
    logoIV.image = [UIImage imageNamed:logoName];
    titelL.text = title;
    if ([title isEqualToString:@"在线客服"]) {
        contentL.textColor = XZRGB(0xfe2947);
    } else {
        contentL.textColor = XZRGB(0x868686);
    }
}

- (void)setContent:(NSString *)content {
    contentL.text = content;
}

- (void)setCellNubmer:(int)num {
    if (num == 0) {
        numL.hidden = YES;
    } else {
        numL.hidden = NO;
        if (num > 99) {
            numL.text = @"99+";
        } else {
            numL.text = [NSString stringWithFormat:@"%d", num];
        }
    }
}



@end
