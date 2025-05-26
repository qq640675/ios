//
//  AnchorVideoView.m
//  beijing
//
//  Created by yiliaogao on 2019/3/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "AnchorVideoView.h"

@implementation AnchorVideoView
{
    UIImageView *videoImageLogo;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _imageView.backgroundColor = XZRGB(0xebebeb);
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    
    videoImageLogo = [[UIImageView alloc] initWithFrame:CGRectMake((_imageView.width-40)/2, (_imageView.height-40)/2, 40, 40)];
    videoImageLogo.image = [UIImage imageNamed:@"AnthorDetail_dynamic_video"];
    videoImageLogo.hidden = YES;
    [_imageView addSubview:videoImageLogo];
    
    self.lockView = [[SLPhotoLockView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:_lockView];
    
    UIImageView *lockImageView = [_lockView viewWithTag:10];
    lockImageView.image = [UIImage imageNamed:@"Dynamic_list_lock_big"];
    
    self.titleLb = [UIManager initWithLabel:CGRectMake(10, self.height-40, self.width-75, 20) text:@"" font:12.0f textColor:[UIColor whiteColor]];
    _titleLb.font = [UIFont boldSystemFontOfSize:12.0f];
    _titleLb.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLb];
    
    self.moneyLb = [UIManager initWithLabel:CGRectMake(self.width-55, self.height-40+3, 45, 14) text:@"0金币" font:11 textColor:[UIColor whiteColor]];
    _moneyLb.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
    _moneyLb.clipsToBounds = YES;
    _moneyLb.layer.cornerRadius = 2;
    [self addSubview:_moneyLb];
    
    self.desLb = [UIManager initWithLabel:CGRectMake(10, self.height-20, self.width, 20) text:@"" font:12.0f textColor:[UIColor whiteColor]];
    _desLb.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_desLb];
    
    [self addSubview:self.videoTempImageView];
    [_videoTempImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 11));
        make.left.equalTo(self).offset(self.width-25);
        make.top.equalTo(self).offset(10);
    }];
    
}

- (void)setHandle:(videoPictureHandle *)handle {
    
    _videoTempImageView.hidden = YES;
    if (_isAnchorDetail) {
        _titleLb.hidden = YES;
    } else {
        _titleLb.hidden = NO;
    }
    if (handle.t_is_private == 0 || handle.is_see == 1) {
        //公开
        _moneyLb.hidden  = YES;
        _lockView.hidden = YES;
    } else {
        //私密
        _moneyLb.hidden = NO;
        _lockView.hidden = NO;
    }
    if (handle.t_file_type == 0) {
        //图片
        videoImageLogo.hidden = YES;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:handle.t_addres_url] placeholderImage:IChatUImage(@"loading")];
    } else {
        videoImageLogo.hidden = NO;
        //视频
        if (_isAnchorDetail) {
            _videoTempImageView.hidden = NO;
        }
        [_imageView sd_setImageWithURL:[NSURL URLWithString:handle.t_video_img] placeholderImage:IChatUImage(@"loading")];
    }
    _titleLb.text = handle.t_nickName;
    _desLb.text   = handle.t_title;
    _moneyLb.text = [NSString stringWithFormat:@"%@金币",handle.t_money];
    
}


- (UIImageView *)videoTempImageView {
    if (!_videoTempImageView) {
        _videoTempImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _videoTempImageView.image = [UIImage imageNamed:@"Dynamic_msg_video"];
    }
    return _videoTempImageView;
}

@end
