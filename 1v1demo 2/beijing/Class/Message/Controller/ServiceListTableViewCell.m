//
//  ServiceListTableViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2020/8/3.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "ServiceListTableViewCell.h"


@implementation ServiceListTableViewCell
{
    UIImageView *headImageView;
    UILabel *nameLabel;
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
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 25;
    headImageView.image = [UIImage imageNamed:@"loading"];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:headImageView];
    
    nameLabel = [UIManager initWithLabel:CGRectMake(75, 20, App_Frame_Width-180, 30) text:@"在线客服" font:15 textColor:XZRGB(0x333333)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
}

- (void)setData:(NSDictionary *)dataDic {
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", dataDic[@"t_handImg"]]] placeholderImage:[UIImage imageNamed:@"loading"]];
    nameLabel.text = [NSString stringWithFormat:@"%@", dataDic[@"t_nickName"]];
}

@end
