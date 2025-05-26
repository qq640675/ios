//
//  GuardView.m
//  beijing
//
//  Created by 黎 涛 on 2021/4/12.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "GuardView.h"

@implementation GuardView
{
    NSInteger anchorId;
    NSArray *numberArr;
    
    NSDictionary *guardDic;
    NSDictionary *selectedDic;
}

#pragma mark - init
- (instancetype)initWithId:(NSInteger)userId {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        anchorId = userId;
    }
    return self;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (void)remove {
    [self removeFromSuperview];
}

#pragma mark - subViews
- (void)setSubViews {
    CGFloat height = 125+110 + (numberArr.count+2)/3*37 + ((numberArr.count+2)/3-1)*23;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((App_Frame_Width-310)/2, (APP_Frame_Height-height)/2, 310, height)];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    [self addSubview:bgView];
    
    UIImageView *titleIV = [[UIImageView alloc] initWithFrame:CGRectMake((App_Frame_Width-310)/2, bgView.y-26, 310, 106)];
    titleIV.image = [UIImage imageNamed:@"guard_title_img"];
    [self addSubview:titleIV];
    
    UILabel *coinL = [UIManager initWithLabel:CGRectMake(0, 80, bgView.width, 30) text:[NSString stringWithFormat:@"花费%@个金币守护她", guardDic[@"t_gift_gold"]] font:18 textColor:XZRGB(0x333333)];
    coinL.font = [UIFont boldSystemFontOfSize:18];
    [bgView addSubview:coinL];
    
    CGFloat left = (bgView.width-65*3-32*2)/2;
    for (int i = 0; i < numberArr.count; i ++) {
        NSDictionary *dic = numberArr[i];
        UIButton *btn = [UIManager initWithButton:CGRectMake(left+(65+32)*(i%3), 125+(37+23)*(i/3), 65, 37) text:[NSString stringWithFormat:@"%@个", dic[@"t_two_gift_number"]] font:16 textColor:XZRGB(0x868686) normalImg:nil highImg:nil selectedImg:nil];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        btn.backgroundColor = XZRGB(0xf2f3f7);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.tag = 3456+i;
        [btn addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        if (i == 0) {
            btn.selected = YES;
            btn.backgroundColor = XZRGB(0xFC6EF1);
            selectedDic = dic;
        }
    }
    
    int giftCount = [[NSString stringWithFormat:@"%@", guardDic[@"giftCount"]] intValue];
    if (giftCount > 0) {
        NSString *str = [NSString stringWithFormat:@"* 我距离上一名排名还差%@个守护", guardDic[@"giftCount"]];
        UILabel *rankL = [UIManager initWithLabel:CGRectMake(0, bgView.height-110, bgView.width, 40) text:@"" font:12 textColor:XZRGB(0x666666)];
        [bgView addSubview:rankL];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
        [att addAttribute:NSForegroundColorAttributeName value:XZRGB(0xfe2947) range:NSMakeRange(0, 1)];
        rankL.attributedText = att;
    }
    
    UIButton *guardBtn = [UIManager initWithButton:CGRectMake((bgView.width-90)/2, bgView.height-55, 90, 35) text:@"守护TA" font:18 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    guardBtn.backgroundColor = XZRGB(0xC580FE);
    guardBtn.layer.masksToBounds = YES;
    guardBtn.layer.cornerRadius = guardBtn.height/2;
    [guardBtn addTarget:self action:@selector(guardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:guardBtn];
    
    UIButton *closeB = [UIManager initWithButton:CGRectMake((App_Frame_Width-50)/2, CGRectGetMaxY(bgView.frame)+10, 50, 50) text:@"" font:1 textColor:nil normalImg:@"mansion_room_delete" highImg:nil selectedImg:nil];
    [closeB addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeB];
}

#pragma mark - data
- (void)showWithDataDic:(NSDictionary *)dataDic {
    guardDic = dataDic;
    if ([dataDic[@"twoGiftList"] isKindOfClass:[NSArray class]]) {
        numberArr = dataDic[@"twoGiftList"];
        [self setSubViews];
        [self show];
    } else {
        [SVProgressHUD showErrorWithStatus:@"守护列表获取失败"];
        [self remove];
    }
}

#pragma mark - func
- (void)itemButtonClick:(UIButton *)sender {
    for (int i = 0 ; i < numberArr.count; i ++) {
        UIButton *btn = [self viewWithTag:3456+i];
        btn.selected = NO;
        btn.backgroundColor = XZRGB(0xf2f3f7);
    }
    sender.selected = YES;
    sender.backgroundColor = XZRGB(0xFC6EF1);
    
    NSInteger index = sender.tag-3456;
    selectedDic = numberArr[index];
}

- (void)guardButtonClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    [SVProgressHUD show];
    [YLNetworkInterface userGiveGiftCoverConsumeUserIds:[NSString stringWithFormat:@"%ld", (long)anchorId] giftId:[[NSString stringWithFormat:@"%@", selectedDic[@"t_gift_id"]] intValue] giftNum:[[NSString stringWithFormat:@"%@", selectedDic[@"t_two_gift_number"]] intValue] block:^(BOOL isSuccess) {
        [self remove];
        if (isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"守护成功"];
            if (self.sendGuardSuccess) {
                self.sendGuardSuccess();
            }
        }else{
            //余额不足
            [[YLInsufficientManager shareInstance] insufficientShow];
        }
    }];
}



@end
