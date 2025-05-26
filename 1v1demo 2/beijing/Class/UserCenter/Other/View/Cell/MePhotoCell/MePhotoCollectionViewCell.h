//
//  MePhotoCollectionViewCell.h
//  beijing
//
//  Created by yiliaogao on 2019/3/26.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newAlbumHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface MePhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView   *imageView;
//@property (nonatomic, strong) UIImageView   *lockImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIImageView   *playerImageView;
@property (nonatomic, strong) UIView        *layerView;
@property (nonatomic, strong) UILabel       *tempLb;
@property (nonatomic, strong) UIButton *coverBtn;
@property (nonatomic, copy) void (^deleteButtonClickBlock)(int albumId);
@property (nonatomic, copy) void (^coverButtonClickBlock)(int albumId);
@property (nonatomic, assign) int albumId;


- (void)initWithData:(newAlbumHandle *)model;

@end

NS_ASSUME_NONNULL_END
