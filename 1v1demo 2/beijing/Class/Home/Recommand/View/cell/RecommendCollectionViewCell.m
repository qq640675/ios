//
//  RecommendCollectionViewCell.m
//  beijing
//
//  Created by yiliaogao on 2019/3/6.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "RecommendCollectionViewCell.h"
#import "ToolManager.h"

@implementation RecommendCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _imageView.backgroundColor = XZRGB(0xebebeb);
    _imageView.clipsToBounds = YES;
    _imageView.layer.cornerRadius = 6;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_imageView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _imageView.width, 40)];
    [ToolManager mutableColor:[UIColor.blackColor colorWithAlphaComponent:0.5] end:[UIColor.blackColor colorWithAlphaComponent:0.01] isH:NO view:view];
    [_imageView addSubview:view];
    
    self.pointView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
    _pointView.backgroundColor = XZRGB(0x52ff52);
    _pointView.clipsToBounds = YES;
    _pointView.layer.cornerRadius = 5;
    _pointView.layer.borderWidth = 1;
    _pointView.layer.borderColor = UIColor.whiteColor.CGColor;
    [view addSubview:_pointView];
    
    self.cityLabel = [UIManager initWithLabel:CGRectMake(23, 5, view.width-30, 20) text:@"" font:13 textColor:UIColor.whiteColor];
    self.cityLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:self.cityLabel];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(self.width-50);
    }];
    
    UIImageView *adressLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 15, 15)];
    adressLogo.image = [UIImage imageNamed:@"white_loc"];
    [view addSubview:adressLogo];
    [adressLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cityLabel.mas_left).offset(-3);
        make.centerY.mas_equalTo(self.cityLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-50, self.width, 50)];
    [ToolManager mutableColor:[UIColor.blackColor colorWithAlphaComponent:0.01] end:[UIColor.blackColor colorWithAlphaComponent:0.6] isH:NO view:bgView];
    [_imageView addSubview:bgView];
    
    self.nickNameLb = [UIManager initWithLabel:CGRectMake(5, 20, bgView.width-60, 30) text:@"昵称" font:13 textColor:[UIColor whiteColor]];
    _nickNameLb.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:_nickNameLb];
//    [_nickNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(bgView).offset(5);
//        make.bottom.equalTo(bgView);
//        make.height.offset(30);
//        make.width.mas_lessThanOrEqualTo(self.width-80);
//    }];

//    self.coinsLb = [UIManager initWithLabel:CGRectMake(self.width-75, bgView.height-30, 70, 30) text:@"10金币/分钟" font:11 textColor:[UIColor whiteColor]];
//    self.coinsLb.adjustsFontSizeToFitWidth = YES;
//    self.coinsLb.textAlignment = NSTextAlignmentRight;
//    [bgView addSubview:_coinsLb];
    
    self.ageLb = [UIManager initWithLabel:CGRectMake(self.width-55, 20, 45, 30) text:@"" font:11 textColor:UIColor.whiteColor];
    self.ageLb.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:self.ageLb];
    
}

- (void)initWithData:(homePageListHandle *)handle {
    [_imageView sd_setImageWithURL:[NSURL URLWithString:handle.t_cover_img] placeholderImage:IChatUImage(@"loading")];
//    _coinsLb.text = [NSString stringWithFormat:@"%d金币/分钟",handle.t_video_gold];
    _nickNameLb.text = handle.t_nickName;
    _cityLabel.text = handle.t_city;
    _ageLb.text = [NSString stringWithFormat:@"%@岁", handle.t_age];
    
//    0.在线1.在聊2.离线
    if ([handle.t_state integerValue] == 0) {
        _pointView.backgroundColor = XZRGB(0x52ff52);
//        _onLineLb.textColor = [UIColor whiteColor];
//        _onLineLb.text = @"在线";
    } else if ([handle.t_state integerValue] == 1) {
        _pointView.backgroundColor = XZRGB(0xfe2947);
//        _onLineLb.textColor = [UIColor whiteColor];
//        _onLineLb.text = @"在聊";
    } else {
        _pointView.backgroundColor = XZRGB(0xbcbcbc);
//        _onLineLb.textColor = XZRGB(0xbcbcbc);
//        _onLineLb.text = @"离线";
    }
}

@end
