//
//  MansionJoinedTableViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/6.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MansionJoinedTableViewCell.h"

@implementation MansionJoinedTableViewCell
{
    UIImageView *bgImageView;
    UILabel *titleLabel;
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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubViews];
    }
    return self;
}

#pragma mark - subViews
- (void)setSubViews {
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, App_Frame_Width-24, (App_Frame_Width-24)*0.4)];
    bgImageView.image = [UIImage imageNamed:@"loading"];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.layer.masksToBounds = YES;
    bgImageView.layer.cornerRadius = 8;
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:bgImageView];
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgImageView.width, bgImageView.height)];
    blackView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.12];
    [bgImageView addSubview:blackView];
    
    UIButton *deleteBtn = [UIManager initWithButton:CGRectMake(bgImageView.width-40, 0, 40, 40) text:@"" font:1 textColor:nil normalImg:@"news_Popupwindowclosed" highImg:nil selectedImg:nil];
    [deleteBtn addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:deleteBtn];
    
    titleLabel = [UIManager initWithLabel:CGRectMake(10, 72, bgImageView.width-20, 25) text:@"我加入的府邸" font:19 textColor:UIColor.whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:19];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [bgImageView addSubview:titleLabel];
    
    for (int i = 0; i < 4; i ++) {
        UIImageView *bigHead = [[UIImageView alloc] initWithFrame:CGRectMake(8+37*i, 18, 42, 42)];
        bigHead.layer.masksToBounds = YES;
        bigHead.layer.cornerRadius = 21;
        bigHead.layer.borderWidth = 1;
        bigHead.layer.borderColor = UIColor.whiteColor.CGColor;
        bigHead.tag = 100+i;
        bigHead.hidden = YES;
        bigHead.image = [UIImage imageNamed:@"loading"];
        [bgImageView addSubview:bigHead];
    }
    
    for (int i = 4; i < 16; i ++) {
        CGFloat x = (bgImageView.width-8-22)-19*(i-4);
        UIImageView *smallHead = [[UIImageView alloc] initWithFrame:CGRectMake(x, bgImageView.height-36, 22, 22)];
        smallHead.layer.masksToBounds = YES;
        smallHead.layer.cornerRadius = 11;
        smallHead.layer.borderWidth = 1;
        smallHead.layer.borderColor = UIColor.whiteColor.CGColor;
        smallHead.tag = 100+i;
        smallHead.hidden = YES;
        smallHead.image = [UIImage imageNamed:@"loading"];
        [bgImageView addSubview:smallHead];
    }
}

#pragma mark - data
- (void)setJoinedModel:(MansionJoinedModel *)joinedModel {
    [bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", joinedModel.t_mansion_house_coverImg]] placeholderImage:[UIImage imageNamed:@"loading"]];
    titleLabel.text = joinedModel.t_mansion_house_name;
    if ([joinedModel.anchorList isKindOfClass:[NSArray class]]) {
        [self setAnchors:joinedModel.anchorList];
    }
}

- (void)setAnchors:(NSArray *)array {
    NSInteger num = array.count;
    if (num > 16) {
        num = 16;
    }
    for (int i = 0; i < 16; i ++) {
        UIImageView *head = [bgImageView viewWithTag:100+i];
        head.hidden = YES;
    }
    for (int i = 0; i < num; i ++) {
        NSDictionary *dic = array[i];
        UIImageView *head = [bgImageView viewWithTag:100+i];
        [head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", dic[@"t_handImg"]]]];
        head.hidden = NO;
    }
}

#pragma mark - func
- (void)deleteButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    if (self.deleteButtonClickBlock) {
        self.deleteButtonClickBlock();
    }
}



@end
