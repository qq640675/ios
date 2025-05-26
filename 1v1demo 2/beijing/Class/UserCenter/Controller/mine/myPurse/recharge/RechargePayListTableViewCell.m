//
//  RechargePayListTableViewCell.m
//  beijing
//
//  Created by yiliaogao on 2019/7/3.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "RechargePayListTableViewCell.h"
#import "BaseView.h"

@implementation RechargePayListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *titelLabel = [UIManager initWithLabel:CGRectMake(13, 0, 100, 30) text:@"选择支付方式" font:15 textColor:XZRGB(0x999999)];
    [self.contentView addSubview:titelLabel];
    
    UIView *line_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 29, App_Frame_Width, 1)];
    line_1.backgroundColor = XZRGB(0xf2f2f2);
    [self.contentView addSubview:line_1];
    
}

- (void)initWithData:(RechargePayListModel *)model {
    
    for (UIView *view in self.contentView.subviews) {
        if (view.tag > 100) {
            [view removeFromSuperview];
        }
    }
    
    self.listModel = model;
    NSArray *list = model.listArray;
    CGFloat viewHeight = 60;
    NSInteger count = 1;
    if (model.isOpenMorePay) {
        count = list.count;
    }
    for (int i = 0; i < count; i ++) {
        NSDictionary *dict = list[i];
        UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, 30+viewHeight*i, App_Frame_Width, viewHeight)];
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"payIcon"]]];
        [payView addSubview:iconImageView];
        
        
        UILabel *nameLb = [UIManager initWithLabel:CGRectMake(70, 0, 200, 60) text:dict[@"payName"] font:17 textColor:UIColor.blackColor];
        nameLb.textAlignment = NSTextAlignmentLeft;
        nameLb.numberOfLines = 2;
        [payView addSubview:nameLb];
        
        UIButton *selectBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-45, 15, 30, 30) text:@"" font:1 textColor:UIColor.whiteColor normalImg:@"vip_pay_unsel" highImg:nil selectedImg:@"vip_pay_sel"];
        selectBtn.userInteractionEnabled = NO;
        if (i == model.selectIndex) {
            selectBtn.selected = YES;
        }
        [payView addSubview:selectBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, App_Frame_Width, 1)];
        line.backgroundColor = XZRGB(0xf2f2f2);
        [payView addSubview:line];
        
        payView.tag = 102+i;
        
        UITapGestureRecognizer *aliTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedPayView:)];
        [payView addGestureRecognizer:aliTap];
        
        [self.contentView addSubview:payView];
        
        if (i == 0 && list.count > 1) {
            //更多支付方式
            UIButton *moreBtn = [UIManager initWithButton:CGRectMake(15, 90, App_Frame_Width-15, 30) text:@"更多支付方式" font:15 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
            moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            moreBtn.tag = 101;
            [moreBtn addTarget:self action:@selector(clickedMoreBtn) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:moreBtn];
        
        }
        
        if (model.isOpenMorePay && i > 0) {
            payView.y += 30;
        }
    }
}

- (void)clickedMoreBtn {
    if (!_listModel.isOpenMorePay) {
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectRechargePayListTableViewCellWithBtn:)]) {
            [_delegate didSelectRechargePayListTableViewCellWithBtn:101];
        }
    }
}

- (void)clickedPayView:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectRechargePayListTableViewCellWithBtn:)]) {
        [_delegate didSelectRechargePayListTableViewCellWithBtn:tap.view.tag];
    }
}

@end
