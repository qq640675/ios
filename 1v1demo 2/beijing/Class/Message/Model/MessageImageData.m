//
//  MessageImageData.m
//  beijing
//
//  Created by 黎 涛 on 2020/1/14.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MessageImageData.h"
#import "SDWebImage.h"

@implementation MessageImageData

- (CGSize)contentSize {
    CGSize size = CGSizeMake(160, 190);
    if (self.size.width > 0) {
        size = self.size;
    }
    return size;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    if (self.size.width > 0) {
        return;
    }
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]];
    UIImage *image = [UIImage imageWithData:data];
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat imageWidth;
    CGFloat imageHeight;
    if (width/height > 8.0/9) {
        imageWidth = 160;
        imageHeight = 160*height/width + 10;
    } else {
        imageHeight = 180 + 10;
        imageWidth = 180*width/height;
    }
    if (imageWidth < 80) {
        imageWidth = 80;
        imageHeight = 180 + 10;
    }
    if (imageHeight < 80) {
        imageHeight = 80 + 10;
        imageWidth = 160;
    }
    self.size = CGSizeMake(imageWidth, imageHeight);
    [self contentSize];
}

//- (void)setImageUrl:(NSString *)imageUrl {
//    _imageUrl = imageUrl;
//    UIImageView *imageView = [[UIImageView alloc]init];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        CGFloat width = image.size.width;
//        CGFloat height = image.size.height;
//        CGFloat imageWidth;
//        CGFloat imageHeight;
//        if (width/height > 8.0/9) {
//            imageWidth = 160;
//            imageHeight = 160*height/width + 10;
//        } else {
//            imageHeight = 180 + 10;
//            imageWidth = 180*width/height;
//        }
//        self.size = CGSizeMake(imageWidth, imageHeight);
//        [self contentSize];
//    }];
//}

@end
