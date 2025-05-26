//
//  HeaderCollectionViewCell.h
//  beijing
//
//  Created by 黎 涛 on 2020/11/26.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HeaderCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *bannerImageV;

- (void)setBannnerData:(NSDictionary *)dataDic;

@end

NS_ASSUME_NONNULL_END
