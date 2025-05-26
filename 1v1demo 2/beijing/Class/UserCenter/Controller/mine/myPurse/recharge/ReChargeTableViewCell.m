//
//  ReChargeTableViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2019/6/18.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "ReChargeTableViewCell.h"
#import "UIManager.h"

@implementation ReChargeTableViewCell
{
    UIButton *morePayButton;
    UIButton *aliButton;
    UIButton *weButton;
    UIView *wepayView;
    UIView *weLine;
}

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
        // height 150  210
        self.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    UILabel *titelLabel = [UIManager initWithLabel:CGRectMake(15, 0, 100, 30) text:@"选择支付方式" font:15 textColor:XZRGB(0x999999)];
    [self.contentView addSubview:titelLabel];
    
    UIView *line_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 29, App_Frame_Width, 1)];
    line_1.backgroundColor = XZRGB(0xf2f2f2);
    [self.contentView addSubview:line_1];
    
    UIView *alipayView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, App_Frame_Width, 60)];
    alipayView.backgroundColor = UIColor.whiteColor;
    alipayView.tag = 1111;
    [self.contentView addSubview:alipayView];
    UITapGestureRecognizer *aliTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payTypeChanged:)];
    [alipayView addGestureRecognizer:aliTap];
    
    UIImageView *aliImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
    aliImageView.image = [UIImage imageNamed:@"vip_apliy"];
    [alipayView addSubview:aliImageView];
    
    UILabel *aliLabel = [UIManager initWithLabel:CGRectMake(70, 8, 150, 22) text:@"支付宝支付" font:17 textColor:UIColor.blackColor];
    aliLabel.textAlignment = NSTextAlignmentLeft;
    [alipayView addSubview:aliLabel];
    
    UILabel *aliContentLabel = [UIManager initWithLabel:CGRectMake(70, 30, App_Frame_Width-130, 20) text:@"推荐使用支付宝支付获取更多优惠" font:13 textColor:XZRGB(0x999999)];
    aliContentLabel.textAlignment = NSTextAlignmentLeft;
    [alipayView addSubview:aliContentLabel];
    
    aliButton = [UIManager initWithButton:CGRectMake(App_Frame_Width-45, 15, 30, 30) text:@"" font:1 textColor:UIColor.whiteColor normalImg:@"vip_pay_unsel" highImg:nil selectedImg:@"vip_pay_sel"];
    aliButton.selected = YES;
    aliButton.userInteractionEnabled = NO;
    [alipayView addSubview:aliButton];
    
    UIView *aliLine = [[UIView alloc] initWithFrame:CGRectMake(0, 59, App_Frame_Width, 1)];
    aliLine.backgroundColor = XZRGB(0xf2f2f2);
    [alipayView addSubview:aliLine];
    
    morePayButton = [UIManager initWithButton:CGRectMake(15, 90, 90, 30) text:@"更多支付方式" font:15 textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
    morePayButton.selected = NO;
    [morePayButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:morePayButton];
    
    wepayView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, App_Frame_Width, 60)];
    wepayView.backgroundColor = UIColor.whiteColor;
    wepayView.tag = 2222;
    wepayView.hidden = YES;
    [self.contentView addSubview:wepayView];
    UITapGestureRecognizer *weTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payTypeChanged:)];
    [wepayView addGestureRecognizer:weTap];
    
    UIImageView *weImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
    weImageView.image = [UIImage imageNamed:@"vip_wechat"];
    [wepayView addSubview:weImageView];
    
    UILabel *weLabel = [UIManager initWithLabel:CGRectMake(70, 8, 150, 22) text:@"微信支付" font:17 textColor:UIColor.blackColor];
    weLabel.textAlignment = NSTextAlignmentLeft;
    [wepayView addSubview:weLabel];
    
    UILabel *weContentLabel = [UIManager initWithLabel:CGRectMake(70, 30, App_Frame_Width-130, 20) text:@"推荐已安装微信的用户使用" font:13 textColor:XZRGB(0x999999)];
    weContentLabel.textAlignment = NSTextAlignmentLeft;
    [wepayView addSubview:weContentLabel];
    
    weButton = [UIManager initWithButton:CGRectMake(App_Frame_Width-45, 15, 30, 30) text:@"" font:1 textColor:UIColor.whiteColor normalImg:@"vip_pay_unsel" highImg:nil selectedImg:@"vip_pay_sel"];
    [wepayView addSubview:weButton];
    weButton.userInteractionEnabled = NO;
    [self.contentView sendSubviewToBack:wepayView];
    
    weLine = [[UIView alloc] initWithFrame:CGRectMake(0, 120, App_Frame_Width, 4)];
    weLine.backgroundColor = XZRGB(0xf2f2f2);
    [self.contentView addSubview:weLine];
}

- (void)setIsChoosedMore:(BOOL)isChoosedMore {
    if (isChoosedMore == YES) {
        morePayButton.selected = YES;
        wepayView.hidden = NO;
        weLine.frame = CGRectMake(0, 180, App_Frame_Width, 4);
    }
}

- (void)moreButtonClick {
    if (morePayButton.selected == YES) {
        return;
    }
    morePayButton.selected = YES;
    if (self.moPayType) {
        self.moPayType();
    }
}

- (void)payTypeChanged:(UITapGestureRecognizer *)tap {
    NSInteger tag = tap.view.tag;
    if (tag == 1111) {
        // 支付宝
        if (aliButton.selected == YES) {
            return;
        }
        if (self.payTypeChanged) {
            self.payTypeChanged(0);
        }
        aliButton.selected = YES;
        weButton.selected = NO;
    } else if (tag == 2222) {
        //微信
        if (weButton.selected == YES) {
            return;
        }
        if (self.payTypeChanged) {
            self.payTypeChanged(1);
        }
        aliButton.selected = NO;
        weButton.selected = YES;
    }
}


@end
