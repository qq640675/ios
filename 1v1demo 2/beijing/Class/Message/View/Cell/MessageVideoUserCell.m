//
//  MessageVideoUserCell.m
//  beijing
//
//  Created by 黎 涛 on 2020/1/8.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MessageVideoUserCell.h"
#import "SDWebImage.h"
#import "BaseView.h"
#import "UIView+MMLayout.h"
#import "SLHelper.h"

@implementation MessageVideoUserCell

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
        [self setSubViews];
        
    }
    return self;
}

- (void)setSubViews {
    self.videoBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 48)];
    self.videoBGView.backgroundColor = UIColor.whiteColor;
    self.videoBGView.layer.masksToBounds = YES;
    self.videoBGView.layer.cornerRadius = 5;
    [self.container addSubview:self.videoBGView];
    
    self.videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(64, 11, 26, 26)];
    self.videoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.videoImageView.image = [UIImage imageNamed:@"message_video_red"];
    self.videoImageView.clipsToBounds = YES;
    [self.videoBGView addSubview:self.videoImageView];
    
    self.contentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 44, 28)];
    self.contentTextLabel.font = [UIFont systemFontOfSize:14];
    self.contentTextLabel.textAlignment = NSTextAlignmentCenter;
    self.contentTextLabel.text = @"未接听";
    [self.videoBGView addSubview:self.contentTextLabel];
}

- (void)fillWithData:(MessageVideoUserCellData *)data {
    [super fillWithData:data];

    if (data.headImage) {
        self.avatarView.image = data.headImage;
    } else {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:data.avaterImageUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    }
    
    if (data.isSelf == YES) {
        self.videoImageView.x = 64;
        self.contentTextLabel.x = 10;
        self.contentTextLabel.textColor = XZRGB(0xae4ffd);
        if ([data.callType isEqualToString:@"voice"]) {
            self.videoImageView.image = [UIImage imageNamed:@"message_voice_red"];
        } else {
            self.videoImageView.image = [UIImage imageNamed:@"message_video_red"];
        }
        
    } else {
        self.videoImageView.x = 10;
        self.contentTextLabel.x = 46;
        self.contentTextLabel.textColor = XZRGB(0x333333);
        if ([data.callType isEqualToString:@"voice"]) {
            self.videoImageView.image = [UIImage imageNamed:@"message_voice_black"];
        } else {
            self.videoImageView.image = [UIImage imageNamed:@"message_video_black"];
        }
    }
}

@end
