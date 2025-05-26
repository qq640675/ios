//
//  RecommendCollectionViewCell.h
//  beijing
//
//  Created by yiliaogao on 2019/3/6.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "homePageListHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView   *imageView;

@property (nonatomic, strong) UIView        *pointView;
//@property (nonatomic, strong) UILabel       *onLineLb;
@property (nonatomic, strong) UILabel       *cityLabel;

//@property (nonatomic, strong) UILabel       *coinsLb;

@property (nonatomic, strong) UILabel       *nickNameLb;

@property (nonatomic, strong) UILabel       *ageLb;

//@property (nonatomic, strong) UILabel       *occupationLb;

//@property (nonatomic, strong) UILabel       *autographLb;
//@property (nonatomic, strong) UIView *onLineBgView;

- (void)initWithData:(homePageListHandle *)handle;


@end

NS_ASSUME_NONNULL_END
