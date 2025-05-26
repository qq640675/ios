//
//  AnchorPhotoCollectionViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2020/4/15.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "AnchorPhotoCollectionViewCell.h"
#import "BaseView.h"

@implementation AnchorPhotoCollectionViewCell
{
    UIImageView *coverImageView;
    UIVisualEffectView *effectView;
    UIImageView *videoImageLogo;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    coverImageView.clipsToBounds = YES;
    coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    coverImageView.image = [UIImage imageNamed:@"loading"];
    [self.contentView addSubview:coverImageView];
    
    effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.frame = CGRectMake(0, 0, coverImageView.width, coverImageView.height);
    effectView.hidden = YES;
    effectView.alpha = 0.9;
    [coverImageView addSubview:effectView];
    
    UIImageView *lock = [[UIImageView alloc] initWithFrame:CGRectMake(effectView.width-25, 8, 17, 26)];
    lock.image = [UIImage imageNamed:@"newdetail_img_lock"];
    [effectView.contentView addSubview:lock];
    
    videoImageLogo = [[UIImageView alloc] initWithFrame:CGRectMake((coverImageView.width-40)/2, (coverImageView.height-40)/2, 40, 40)];
    videoImageLogo.image = [UIImage imageNamed:@"AnthorDetail_dynamic_video"];
    videoImageLogo.hidden = YES;
    [coverImageView addSubview:videoImageLogo];
}

- (void)setHandle:(videoPictureHandle *)handle {
    if (handle.t_file_type == 0) {
        [coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", handle.t_addres_url]] placeholderImage:[UIImage imageNamed:@"loading"]];
        videoImageLogo.hidden = YES;
    } else {
        [coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", handle.t_video_img]] placeholderImage:[UIImage imageNamed:@"loading"]];
        videoImageLogo.hidden = NO;
    }
    
    effectView.hidden = YES;
    if (handle.t_is_private == 1) {
        effectView.hidden = NO;
    }
}

@end
