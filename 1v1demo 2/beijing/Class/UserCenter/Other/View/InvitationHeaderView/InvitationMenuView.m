//
//  InvitationMenuView.m
//  beijing
//
//  Created by yiliaogao on 2019/3/23.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "InvitationMenuView.h"

@implementation InvitationMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    
    self.sonBtnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height/2, App_Frame_Width, self.height/2)];
    [self addSubview:_sonBtnBgView];
    
    self.backgroundColor = [UIColor whiteColor];
    NSArray *titles = @[@"奖励排行",@"人数排行",@"首冲排行",@"我的邀请"];
    NSArray *sonTitles = @[@"日榜",@"周榜",@"月榜",@"总榜"];
    for (int i = 0; i < [titles count]; i ++) {
        CGFloat width = self.width/titles.count;
        UIButton *btn = [UIManager initWithButton:CGRectMake(width*i, 0, width, self.height/2) text:titles[i] font:15.0f textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [btn setTitleColor:XZRGB(0xAE4FFD) forState:UIControlStateSelected];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        
        
        UIButton *sonBtn = [UIManager initWithButton:CGRectMake(width*i, 0, width, self.height/2) text:sonTitles[i] font:14.0f textColor:XZRGB(0x333333) normalImg:nil highImg:nil selectedImg:nil];
        [sonBtn setTitleColor:XZRGB(0xAE4FFD) forState:UIControlStateSelected];
        sonBtn.tag = i+100;
        [sonBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_sonBtnBgView addSubview:sonBtn];
        
        
        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
            
            sonBtn.selected = YES;
            self.selectedSonBtn = sonBtn;
            
            self.selectedView = [[UIView alloc] initWithFrame:CGRectZero];
            _selectedView.backgroundColor = XZRGB(0xAE4FFD);
            _selectedView.clipsToBounds = YES;
            _selectedView.layer.cornerRadius = 1.5f;
            [self addSubview:_selectedView];
            [_selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(45);
                make.centerX.equalTo(self.selectedBtn.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(20, 3));
            }];
            
        }
    }
}

- (void)clickedBtn:(UIButton *)btn {
    
    if (btn.tag == 3) {
        _sonBtnBgView.hidden = YES;
    } else {
        _sonBtnBgView.hidden = NO;
    }
    
    if (btn.tag > 99) {
        if (btn.tag != _selectedSonBtn.tag) {
            _selectedSonBtn.selected = NO;
            btn.selected = YES;
            _selectedSonBtn = btn;
            
            if (_delegate && [_delegate respondsToSelector:@selector(didSelectInvitationMenuViewWithBtn:)]) {
                [_delegate didSelectInvitationMenuViewWithBtn:_selectedBtn];
            }
        }
    } else {
        if (btn.tag != _selectedBtn.tag) {
            CGFloat width = App_Frame_Width/4;
            [UIView animateWithDuration:.2 animations:^{
                self.selectedBtn.selected = NO;
                btn.selected = YES;
                self.selectedBtn = btn;
                self.selectedView.y = 45;
                self.selectedView.x = width*btn.tag+(width-20)/2;
            }];
            
            if (_delegate && [_delegate respondsToSelector:@selector(didSelectInvitationMenuViewWithBtn:)]) {
                [_delegate didSelectInvitationMenuViewWithBtn:btn];
            }
        }
    }
}

@end
