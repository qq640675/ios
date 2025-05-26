//
//  MessageVideoAnchorCell.m
//  beijing
//
//  Created by 黎 涛 on 2020/1/8.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MessageVideoAnchorCell.h"
#import "SDWebImage.h"
#import "BaseView.h"
#import "UIView+MMLayout.h"
#import "SLHelper.h"
#import "ChatLiveManager.h"

@implementation MessageVideoAnchorCell

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
    self.videoBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 155, 84)];
    self.videoBGView.backgroundColor = UIColor.whiteColor;
    self.videoBGView.layer.masksToBounds = YES;
    self.videoBGView.layer.cornerRadius = 8;
    [self.container addSubview:self.videoBGView];
    
    UIView *topBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 42)];
    topBGView.backgroundColor = UIColor.whiteColor;
    [self.videoBGView addSubview:topBGView];
    
    self.videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
    self.videoImageView.contentMode = UIViewContentModeCenter;
    self.videoImageView.image = [UIImage imageNamed:@"message_video_red"];
    [topBGView addSubview:self.videoImageView];
    
    self.contentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 110, 42)];
    self.contentTextLabel.font = [UIFont systemFontOfSize:12];
    self.contentTextLabel.textColor = XZRGB(0x333333);
    self.contentTextLabel.text = @"发来一个视频邀请";
    [topBGView addSubview:self.contentTextLabel];
    
//    self.videoPriceLabel = [UIManager initWithLabel:CGRectMake(10, 50, 130, 20) text:@"视频通话：金币/分钟" font:10 textColor:XZRGB(0x33b6ec)];
//    self.videoPriceLabel.textAlignment = NSTextAlignmentLeft;
//    self.videoPriceLabel.font = [UIFont boldSystemFontOfSize:10];
//    [self.videoBGView addSubview:self.videoPriceLabel];
//
//    self.voicePriceLabel = [UIManager initWithLabel:CGRectMake(10, 70, 130, 20) text:@"语音通话：金币/分钟" font:10 textColor:XZRGB(0x33b6ec)];
//    self.voicePriceLabel.textAlignment = NSTextAlignmentLeft;
//    self.voicePriceLabel.font = [UIFont boldSystemFontOfSize:10];
//    [self.videoBGView addSubview:self.voicePriceLabel];
    
    self.callButton = [UIManager initWithButton:CGRectMake(0, 42, 155, 42) text:@"立即回拨" font:14 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
    self.callButton.backgroundColor = [XZRGB(0xAE4FFD) colorWithAlphaComponent:0.72];
    [self.callButton addTarget:self action:@selector(callBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoBGView addSubview:self.callButton];
    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(140, 40, 0.8, 60)];
//    line.backgroundColor = XZRGB(0xebebeb);
//    [self.videoBGView addSubview:line];
}

- (void)fillWithData:(MessageVideoAnchorCellData *)data {
    [super fillWithData:data];

    if (data.headImage) {
        self.avatarView.image = data.headImage;
    } else {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:data.avaterImageUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    }

    NSString *jsonStr  = [[NSString alloc] initWithData:data.videoData encoding:NSUTF8StringEncoding];
    if ([jsonStr hasPrefix:@"serverSend&&"]) {
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"serverSend&&" withString:@"{"];
    }
    NSDictionary *dic = [SLHelper dictionaryWithJsonString:jsonStr];
    
    NSString *callType = dic[@"call_type"];
    if ([callType isEqualToString:@"video"]) {
        self.contentTextLabel.text = @"发来一个视频邀请";
        self.videoImageView.image = [UIImage imageNamed:@"message_video_red"];
    } else if ([callType isEqualToString:@"voice"]) {
        self.contentTextLabel.text = @"发来一个语音邀请";
        self.videoImageView.image = [UIImage imageNamed:@"message_voice_red"];
    }
    
//    self.videoPriceLabel.text = [NSString stringWithFormat:@"视频通话：%@金币/分钟", dic[@"video_price"]];
//    self.voicePriceLabel.text = [NSString stringWithFormat:@"语音通话：%@金币/分钟", dic[@"voice_price"]];
    
    self.anchorId = [dic[@"anchor_id"] intValue];
    self.callType = callType;
}

- (void)callBackButtonClick {
    [[ChatLiveManager shareInstance] getVideoChatAutographWithOtherId:self.anchorId type:1 fail:nil];
}



@end
