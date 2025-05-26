//
//  MansionMyAnchorView.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/6.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MansionMyAnchorView.h"

@implementation MansionMyAnchorView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame isAdd:(BOOL)isAdd {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.clipsToBounds = YES;
        [self setSubViewsIsAdd:isAdd];
    }
    return self;
}

- (void)setSubViewsIsAdd:(BOOL)isAdd {
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-65)/2, 15, 65, 65)];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 32.5;
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_headImageView];
    
    _nameLabel = [UIManager initWithLabel:CGRectMake(5, CGRectGetMaxY(_headImageView.frame), self.width-10, 30) text:@"昵称" font:12 textColor:XZRGB(0x333333)];
    [self addSubview:_nameLabel];
    
    if (isAdd == YES) {
        _headImageView.image = [UIImage imageNamed:@"mansion_btn_invite"];
        _headImageView.contentMode = UIViewContentModeScaleToFill;
        _nameLabel.textColor = XZRGB(0x999999);
        _nameLabel.text = @"点击邀请";
    } else {
        _statusLabel = [UIManager initWithLabel:CGRectMake((_headImageView.width-32)/2, _headImageView.height-14, 32, 14) text:@"离线" font:10 textColor:UIColor.whiteColor];
        _statusLabel.backgroundColor = XZRGB(0xbcbcbc);
        _statusLabel.layer.masksToBounds = YES;
        _statusLabel.layer.cornerRadius = 7;
        [_headImageView addSubview:_statusLabel];
        
        _deleteBtn = [UIManager initWithButton:CGRectMake(_headImageView.x+_headImageView.width-30, _headImageView.y-10, 40, 40) text:@"" font:1 textColor:nil normalImg:@"mansion_btn_delete" highImg:nil selectedImg:nil];
        _deleteBtn.hidden = YES;
        [_deleteBtn addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
    }
}

#pragma mark - data
- (void)setAnchorModel:(MansionAnchorModel *)anchorModel {
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", anchorModel.t_handImg]] placeholderImage:[UIImage imageNamed:@"loading"]];
    _nameLabel.text = anchorModel.t_nickName;
    [self setStatus:anchorModel.t_onLine];
}

- (void)setStatus:(int)status {
    if (status == 0) {
        // 在线
        _statusLabel.text = @"在线";
        _statusLabel.backgroundColor = XZRGB(0x1dec1d);
    } else if (status == 1) {
        // 在聊
        _statusLabel.text = @"在聊";
        _statusLabel.backgroundColor = XZRGB(0xfe2947);
    } else {
        // 离线
        _statusLabel.text = @"离线";
        _statusLabel.backgroundColor = XZRGB(0xbcbcbc);
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
