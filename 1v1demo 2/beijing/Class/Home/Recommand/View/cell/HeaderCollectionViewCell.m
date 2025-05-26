//
//  HeaderCollectionViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2020/11/26.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "HeaderCollectionViewCell.h"

@implementation HeaderCollectionViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.bannerImageV = [[UIImageView alloc] initWithFrame:self.bounds];
        _bannerImageV.contentMode = UIViewContentModeScaleAspectFill;
        _bannerImageV.layer.masksToBounds = YES;
        _bannerImageV.layer.cornerRadius = 5;
        [self.contentView addSubview:_bannerImageV];
    }
    return self;
}

- (void)setBannnerData:(NSDictionary *)dataDic {
    [self.bannerImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", dataDic[@"t_img_url"]]]];
}

@end
