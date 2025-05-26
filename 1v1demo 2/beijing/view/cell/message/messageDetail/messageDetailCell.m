//
//  messageDetailCell.m
//  beijing
//
//  Created by zhou last on 2018/6/25.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "messageDetailCell.h"
#import "DefineConstants.h"
#import <Masonry.h>
#import "NSString+Extension.h"

@interface messageDetailCell ()

//时间
@property (nonatomic ,strong) UILabel *timeLabel;
//白色背景框
@property (nonatomic ,strong) UIView *whiteBgView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic ,strong) UILabel *tittleLabel;
@property (nonatomic ,strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView   *bgImgView;

@property (nonatomic, strong) UIImageView *messageIV;

@end


@implementation messageDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 42, 42)];
    _iconImageView.image = [UIImage imageNamed:@"message_top_systrm"];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(42, 42));
    }];
    
    
    [self.contentView addSubview:self.tittleLabel];
    [_tittleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.iconImageView.mas_top).offset(2);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(15);
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tittleLabel.mas_left);
        make.top.mas_equalTo(self.tittleLabel.mas_bottom).offset(3);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(15);
    }];
    
    [self.contentView addSubview:self.whiteBgView];
    [_whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        make.bottom.right.mas_equalTo(-20);
    }];
    
    [_whiteBgView addSubview:self.bgImgView];
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    _messageIV = [[UIImageView alloc] init];
    _messageIV.contentMode = UIViewContentModeScaleAspectFit;
    _messageIV.clipsToBounds = YES;
    [_whiteBgView addSubview:_messageIV];
    [_messageIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(0);
    }];
    
    [_whiteBgView addSubview:self.contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.messageIV.mas_bottom).offset(10);
//        make.top.mas_equalTo(20);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)msgDetailModel:(NSString *)time
                tittle:(NSString *)tittle
               content:(NSString *)content
                 image:(NSString *)image {
    self.timeLabel.text = time;
    self.tittleLabel.text = tittle;
    self.contentLabel.text = content;
    if (image.length > 0 && ![image containsString:@"null"]) {
        //有图片
        CGFloat maxW = App_Frame_Width-107;
        CGFloat maxH = 500;
        [_messageIV sd_setImageWithURL:[NSURL URLWithString:image] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            CGFloat height = image.size.height*maxW/image.size.width;
            if (height > maxH) {
                height = maxH;
            }
            NSLog(@"______imageSize:%@  height:%f", NSStringFromCGSize(image.size), height);
            [self.messageIV mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(height);
            }];
        }];
    } else {
        [_messageIV mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
        }];
    }
}

- (void)setInviteModel:(MansionInviteListModel *)inviteModel {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", inviteModel.t_handImg]]];
    self.tittleLabel.text = inviteModel.t_nickName;
    self.timeLabel.text = [ToolManager getTimeFromTimestamp:inviteModel.t_create_time/1000 formatStr:@"YYYY-MM-dd HH:mm:ss"];
    self.contentLabel.text = @"邀请你加入他的府邸";
}

+ (float)getCellHeight:(NSString *)tittle content:(NSString *)content {
    CGSize contentSize = [content sizeWithMaxWidth:App_Frame_Width - 100 andFont:PingFangSCFont(15)];
    
    float contentHeight = contentSize.height;
    if (contentHeight < 16) {
        contentHeight = 16;
    }
    
    return 112 + contentSize.height;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [UILabel new];
        _timeLabel.font = PingFangSCFont(13);
        _timeLabel.textColor = XZRGB(0x868686);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return _timeLabel;
}

- (UIView *)whiteBgView
{
    if (_whiteBgView == nil) {
        _whiteBgView = [UIView new];
        _whiteBgView.backgroundColor = [UIColor clearColor];
        _whiteBgView.frame = CGRectZero;
    }
    
    return _whiteBgView;
}

- (UILabel *)tittleLabel
{
    if (_tittleLabel == nil) {
        _tittleLabel = [UILabel new];
        _tittleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15.0f];
        _tittleLabel.textColor = XZRGB(0x333333);
        _tittleLabel.textAlignment = NSTextAlignmentLeft;
        _tittleLabel.frame = CGRectZero;
        _tittleLabel.numberOfLines = 0;
    }
    
    return _tittleLabel;
}

- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [UILabel new];
        _contentLabel.font = PingFangSCFont(15);
        _contentLabel.textColor = XZRGB(0x333333);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.frame = CGRectZero;
    }
    
    return _contentLabel;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        CGFloat top     = 25; // 顶端盖高度
        CGFloat bottom  = 10; // 底端盖高度
        CGFloat left    = 40; // 左端盖宽度
        CGFloat right   = 10; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        UIImage *img = [UIImage imageNamed:@"System_msg_bg"];
        _bgImgView.image = [img resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    }
    return _bgImgView;
}

@end
