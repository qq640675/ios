//
//  giftCabinetCell.h
//  beijing
//
//  Created by zhou last on 2018/10/26.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface giftCabinetCell : UICollectionViewCell

//礼物边框
@property (weak, nonatomic) IBOutlet UIView *giftBorderView;
//礼物图
@property (weak, nonatomic) IBOutlet UIImageView *giftImgView;

//礼物名字
@property (weak, nonatomic) IBOutlet UILabel *giftNameLabel;
//价格
@property (weak, nonatomic) IBOutlet UILabel *giftPriceLabel;


@end

NS_ASSUME_NONNULL_END
