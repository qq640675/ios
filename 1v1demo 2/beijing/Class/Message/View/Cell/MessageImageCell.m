//
//  MessageImageCell.m
//  beijing
//
//  Created by 黎 涛 on 2020/1/14.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MessageImageCell.h"
#import "SDWebImage.h"

@implementation MessageImageCell

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
    self.contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 180)];
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImageView.layer.masksToBounds = YES;
    self.contentImageView.layer.cornerRadius = 6;
    [self.container addSubview:self.contentImageView];
}

- (void)fillWithData:(MessageImageData *)data {

    [super fillWithData:data];

    if (data.headImage) {
        self.avatarView.image = data.headImage;
    } else {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:data.avaterImageUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    }
    if (data.defaultImage) {
        self.contentImageView.image = data.defaultImage;
    } else {
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:data.imageUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
    }
    
    if (data.size.width > 0) {
        self.contentImageView.width = data.size.width;
        self.contentImageView.height = data.size.height-10;
    }
}

@end
