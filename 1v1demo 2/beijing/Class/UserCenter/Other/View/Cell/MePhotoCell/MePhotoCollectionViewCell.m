//
//  MePhotoCollectionViewCell.m
//  beijing
//
//  Created by yiliaogao on 2019/3/26.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "MePhotoCollectionViewCell.h"
#import "BaseView.h"

@implementation MePhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.backgroundColor = XZRGB(0xebebeb);
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.equalTo(self.contentView).offset(0);
    }];
    
    self.layerView = [[UIView alloc] initWithFrame:CGRectZero];
    _layerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
    [self.contentView addSubview:_layerView];
    [_layerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.equalTo(self.contentView).offset(0);
    }];
    
//    self.lockImageView = [[UIImageView alloc] initWithImage:IChatUImage(@"PersonCenter_photo_lock")];
//    [self.contentView addSubview:_lockImageView];
//    [_lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(self.width-20);
//        make.top.equalTo(self.contentView).offset(10);
//    }];
    _deleteBtn = [UIManager initWithButton:CGRectMake(self.width-30, 0, 30, 30) text:@"" font:1 textColor:nil normalImg:@"Dynamic_release_delete" highImg:nil selectedImg:nil];
    [_deleteBtn addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
    
    self.playerImageView = [[UIImageView alloc] initWithImage:IChatUImage(@"PersonCenter_photo_player")];
    [self.contentView addSubview:_playerImageView];
    [_playerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    self.tempLb = [UIManager initWithLabel:CGRectMake(0, 0, 100, 20) text:@"审核中" font:14.0f textColor:[UIColor whiteColor]];
    _tempLb.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_tempLb];
    
    _coverBtn = [UIManager initWithButton:CGRectMake(0, self.height-24, self.width, 24) text:@"" font:14 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    _coverBtn.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    _coverBtn.enabled = NO;
    _coverBtn.hidden = YES;
    [_coverBtn addTarget:self action:@selector(coverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_coverBtn];
}

- (void)deleteButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    int albumId = self.albumId;
    if (self.deleteButtonClickBlock) {
        self.deleteButtonClickBlock(albumId);
    }
}

- (void)coverButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    int albumId = self.albumId;
    if (self.coverButtonClickBlock) {
        self.coverButtonClickBlock(albumId);
    }
}

- (void)initWithData:(newAlbumHandle *)model {
    _albumId = model.t_id;
    if (model.t_file_type == 0) {
        //图片
        _playerImageView.hidden = YES;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.t_addres_url] placeholderImage:nil];
    } else {
        //视频
        _playerImageView.hidden = NO;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.t_video_img] placeholderImage:nil];
    }
    
    if (model.t_auditing_type == 1) {
        if (model.t_is_first == 1) {
            _tempLb.hidden = NO;
            _tempLb.text = @"封面视频";
        } else {
            _tempLb.hidden = YES;
        }
    } else {
        _tempLb.hidden = NO;
        _tempLb.text = @"未审核";
    }
    
    _coverBtn.hidden = YES;
    _coverBtn.enabled = NO;
    if (model.t_money > 0) {
        _layerView.hidden     = NO;
        _coverBtn.hidden = NO;
        [_coverBtn setTitle:[NSString stringWithFormat:@"%d金币", model.t_money] forState:0];
    } else {
        _layerView.hidden     = YES;
        if ([YLUserDefault userDefault].t_role == 1 && model.t_auditing_type == 1 && model.t_is_first != 1 && model.t_file_type == 1) {
            _coverBtn.hidden = NO;
            _coverBtn.enabled = YES;
            [_coverBtn setTitle:@"设为视频封面" forState:0];
        }
    }
}

@end
