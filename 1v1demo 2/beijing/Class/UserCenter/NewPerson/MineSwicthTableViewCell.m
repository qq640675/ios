//
//  MineSwicthTableViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2021/3/10.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "MineSwicthTableViewCell.h"

@implementation MineSwicthTableViewCell

#pragma makr - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.clipsToBounds = YES;
        [self setSubViews];
    }
    return self;
}

#pragma mark - subViews
- (void)setSubViews {
    self.titleL = [UIManager initWithLabel:CGRectMake(14, 0, 70, self.height) text:@"" font:14 textColor:XZRGB(0x333333)];
    self.titleL.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleL];
    
    self.cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, (self.height-30)/2, 60, 30)];
//    self.cellSwitch.onTintColor = XZRGB(0xAE4FFD);
    self.cellSwitch.onTintColor = XZRGB(0x0bceb0);
    [self.cellSwitch addTarget:self action:@selector(videoSwitchClick:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.cellSwitch];
    
    self.statusL = [UIManager initWithLabel:CGRectMake(150, 0, App_Frame_Width-164, self.height) text:@"" font:12 textColor:XZRGB(0x868686)];
    self.statusL.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.statusL];
}

- (void)videoSwitchClick:(UISwitch *)sender {
    int isOn = sender.isOn;
    NSString *tip = @"";
    if (self.cellType == SwitchCellTypeVideo) {
        tip = @"关闭视频聊天后,您将收不到视频邀请";
    } else if (self.cellType == SwitchCellTypeChat) {
        tip = @"关闭私信聊天后,您将收不到私信消息";
    }
    [self switchButtonClick:isOn tip:tip type:(int)self.cellType];
}

- (void)switchButtonClick:(int)isOn tip:(NSString *)tip type:(int)type{
    [SVProgressHUD show];
    [YLNetworkInterface setUpChatSwitchType:type switchType:isOn block:^(BOOL isSuccess) {
        if (isSuccess) {
            [SVProgressHUD dismiss];
            if (isOn == NO) {
                if (self.cellType == SwitchCellTypeVideo || self.cellType == SwitchCellTypeChat) {
                    [SVProgressHUD showInfoWithStatus:tip];
                }
            } else {
                [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            }
            
        } else {
            [self.cellSwitch setOn:!isOn];
        }
        [self setStatusWithType:self.cellType isOn:self.cellSwitch.isOn];
    }];
}

- (void)setType:(SwitchCellType)cellType {
    _cellType = cellType;
    
    if (cellType == SwitchCellTypeVideo) {
        self.titleL.text = @"视频聊天";
    } else if (cellType == SwitchCellTypeChat) {
        self.titleL.text = @"文字聊天";
    } else if (cellType == SwitchCellTypePP) {
        self.titleL.text = @"屏蔽飘窗";
    } else if (cellType == SwitchCellTypeRank) {
        self.titleL.text = @"屏蔽榜单";
    }
}

- (void)setHandle:(personalCenterHandle *)handle {
    _personHandle = handle;
    if (_cellType == SwitchCellTypeVideo) {
        [self.cellSwitch setOn:handle.t_is_not_disturb];
    } else if (_cellType == SwitchCellTypeChat) {
        [self.cellSwitch setOn:handle.t_text_switch];
    } else if (_cellType == SwitchCellTypePP) {
        [self.cellSwitch setOn:handle.t_float_switch];
    } else if (_cellType == SwitchCellTypeRank) {
        [self.cellSwitch setOn:handle.t_rank_switch];
    }
    [self setStatusWithType:_cellType isOn:self.cellSwitch.isOn];
}

- (void)setStatusWithType:(SwitchCellType)cellType isOn:(BOOL)isOn {
    NSString *statusStr;
    NSString *typeStr;
    if (isOn) {
        statusStr = @"已开启";
    } else {
        statusStr = @"已关闭";
    }
    if (cellType == SwitchCellTypeVideo) {
        typeStr = @"视频聊天";
    } else if (cellType == SwitchCellTypeChat) {
        typeStr = @"文字聊天";
    } else if (cellType == SwitchCellTypePP) {
        typeStr = @"屏蔽飘窗";
    } else if (cellType == SwitchCellTypeRank) {
        typeStr = @"屏蔽榜单";
    }
    self.statusL.text = [NSString stringWithFormat:@"%@%@", statusStr, typeStr];
}

@end
