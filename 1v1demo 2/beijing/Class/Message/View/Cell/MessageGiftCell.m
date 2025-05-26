//
//  MessageGiftCell.m
//  beijing
//
//  Created by 黎 涛 on 2020/1/7.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MessageGiftCell.h"
#import "SDWebImage.h"
#import "BaseView.h"
#import "UIView+MMLayout.h"
#import "SLHelper.h"

@implementation MessageGiftCell

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
    self.giftBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 80)];
    self.giftBGView.backgroundColor = UIColor.whiteColor;
    self.giftBGView.layer.masksToBounds = YES;
    self.giftBGView.layer.cornerRadius = 8;
    [self.container addSubview:self.giftBGView];
    
    self.giftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    self.giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.giftImageView.clipsToBounds = YES;
    [self.giftBGView addSubview:self.giftImageView];
    
    self.contentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 130, 50)];
    self.contentTextLabel.numberOfLines = 2;
    self.contentTextLabel.font = [UIFont systemFontOfSize:14];
    [self.giftBGView addSubview:self.contentTextLabel];
}

- (void)fillWithData:(MessageGiftCellData *)data {
    [super fillWithData:data];
    
    if (data.headImage) {
        self.avatarView.image = data.headImage;
    } else {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:data.avaterImageUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    }
    
    NSString *jsonStr  = [[NSString alloc] initWithData:data.giftData encoding:NSUTF8StringEncoding];
    if ([jsonStr hasPrefix:@"serverSend&&"]) {
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"serverSend&&" withString:@"{"];
    }

    NSDictionary *dic = [SLHelper dictionaryWithJsonString:jsonStr];
    
    NSInteger type = [dic[@"type"] integerValue];
    NSString *num = @"1";
    NSString *gift_number = [NSString stringWithFormat:@"%@", dic[@"gift_number"]];
    if (gift_number.length > 0 && ![gift_number containsString:@"null"]) {
        num = gift_number;
    }
    if (type == 0) {
        //金币
        _giftImageView.image = IChatUImage(@"gift_coin");
        _contentTextLabel.text = [NSString stringWithFormat:@"%@金币  %@ x%@",dic[@"gold_number"],@"红包", num];
    } else {
        //礼物
        [_giftImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"gift_still_url"]]];
        _contentTextLabel.text = [NSString stringWithFormat:@"%@金币  %@ x%@",dic[@"gold_number"],dic[@"gift_name"], num];
    }

    if (data.isSelf == YES) {
        self.giftImageView.x = 10;
        self.contentTextLabel.x = 80;
        self.contentTextLabel.textAlignment = NSTextAlignmentLeft;
        self.contentTextLabel.textColor = XZRGB(0xae4ffd);
    } else {
        self.giftImageView.x = self.giftBGView.width-70;
        self.contentTextLabel.x = 10;
        self.contentTextLabel.textAlignment = NSTextAlignmentRight;
        self.contentTextLabel.textColor = XZRGB(0x333333);
    }
}


@end
