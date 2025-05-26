//
//  VipRechargeTypeAlertView.m
//  beijing
//
//  Created by 黎 涛 on 2019/10/12.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "VipRechargeTypeAlertView.h"

@implementation VipRechargeTypeAlertView
{
    NSArray *vipTypeArray;
    UIScrollView *scrollView;
    NSInteger selectedPayId;
    NSInteger selectedType;
}

#pragma mark - init
- (instancetype)initWithTypeArray:(NSArray *)typeArray {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        vipTypeArray = typeArray;
        selectedPayId = 6986786;
        [self setSubViews];
    }
    return self;
}

#pragma mark - UI
- (void)setSubViews {
    NSInteger lineNum = vipTypeArray.count;
    if (vipTypeArray.count > 4) {
        lineNum = 4;
    }
    CGFloat height = 130+60*lineNum;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(40, (self.height-height)/2, App_Frame_Width-80, height)];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 8;
    [self addSubview:bgView];
    
    UILabel *titleL = [UIManager initWithLabel:CGRectMake(30, 0, bgView.width-60, 45) text:@"选择支付方式" font:16 textColor:XZRGB(0x333333)];
    [bgView addSubview:titleL];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 45, bgView.width, 1)];
    line.backgroundColor = XZRGB(0xeeeeee);
    [bgView addSubview:line];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, bgView.width, 60*lineNum)];
    [bgView addSubview:scrollView];
    
    UIView *lineH = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.height-45, bgView.width, 1)];
    lineH.backgroundColor = XZRGB(0xeeeeee);
    [bgView addSubview:lineH];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(bgView.width/2-0.5, bgView.height-45, 1, 45)];
    lineV.backgroundColor = XZRGB(0xeeeeee);
    [bgView addSubview:lineV];
    
    UIButton *cancleBtn = [UIManager initWithButton:CGRectMake(0, bgView.height-45, bgView.width/2, 45) text:@"取消" font:15 textColor:XZRGB(0x666666) normalImg:nil highImg:nil selectedImg:nil];
    [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancleBtn];
    
    UIButton *sureBtn = [UIManager initWithButton:CGRectMake(bgView.width/2, bgView.height-45, bgView.width/2, 45) text:@"确定" font:15 textColor:XZRGB(0xed3e50) normalImg:nil highImg:nil selectedImg:nil];
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sureBtn];
    
    [self setPayTypeList];
}

- (void)setPayTypeList {
    for (int i = 0; i < vipTypeArray.count; i ++) {
        NSDictionary *dict = vipTypeArray[i];
        UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, 60*i, scrollView.width, 60)];
        payView.tag = 100+i;
        [scrollView addSubview:payView];
        UITapGestureRecognizer *aliTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedPayView:)];
        [payView addGestureRecognizer:aliTap];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        NSString *icon = dict[@"payIcon"];
        if (icon.length > 0) {
            [iconImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"payIcon"]]];
        } else {
            NSString *payName = dict[@"payName"];
            if ([payName containsString:@"支付宝"]) {
                iconImageView.image = IChatUImage(@"nwithDraw_apliy_sel");
            } else if ([payName containsString:@"微信"]){
                iconImageView.image = IChatUImage(@"nwithDraw_wechat_sel");
            }
        }
        [payView addSubview:iconImageView];
        
        UILabel *nameLb = [UIManager initWithLabel:CGRectMake(70, 0, 150, 60) text:dict[@"payName"] font:16 textColor:XZRGB(0x333333)];
        nameLb.textAlignment = NSTextAlignmentLeft;
        [payView addSubview:nameLb];
        
        int isdefault = [dict[@"isdefault"] intValue];
        UIButton *selectBtn = [UIManager initWithButton:CGRectMake(scrollView.width-45, 15, 30, 30) text:@"" font:1 textColor:UIColor.whiteColor normalImg:@"vip_pay_unsel" highImg:nil selectedImg:@"vip_pay_sel"];
        selectBtn.userInteractionEnabled = NO;
        
        if (isdefault == 1) {
            selectBtn.selected = YES;
            selectedPayId = [dict[@"t_id"] integerValue];
            selectedType = [dict[@"payType"] integerValue];
        }
        selectBtn.tag = 500+i;
        [payView addSubview:selectBtn];
    
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, App_Frame_Width, 1)];
//        line.backgroundColor = XZRGB(0xf2f2f2);
//        [payView addSubview:line];
    }
}

#pragma mark - func
- (void)cancle {
    [self removeFromSuperview];
}

- (void)sure {
    if (selectedPayId == 6986786) {
        [SVProgressHUD showInfoWithStatus:@"请选择支付方式"];
        return;
    }
    if (self.didSelectedType) {
        self.didSelectedType(selectedPayId, selectedType);
    }
    [self cancle];
}

- (void)clickedPayView:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - 100;
    for (int i = 0; i < vipTypeArray.count; i ++) {
        UIButton *btn = [scrollView viewWithTag:500+i];
        btn.selected = NO;
    }
    UIButton *btn = [scrollView viewWithTag:500+index];
    btn.selected = YES;
    
    if (vipTypeArray.count > index) {
        NSDictionary *dict = vipTypeArray[index];
        selectedPayId = [dict[@"t_id"] integerValue];
        selectedType = [dict[@"payType"] integerValue];
    }
}




@end
