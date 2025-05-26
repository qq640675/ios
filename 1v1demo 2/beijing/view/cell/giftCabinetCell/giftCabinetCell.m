//
//  giftCabinetCell.m
//  beijing
//
//  Created by zhou last on 2018/10/26.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "giftCabinetCell.h"
#import "DefineConstants.h"

@implementation giftCabinetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.giftBorderView.layer setCornerRadius:5.];
    [self.giftBorderView setClipsToBounds:YES];
    [self.giftBorderView.layer setBorderWidth:1.];
    [self.giftBorderView.layer setBorderColor:XZRGB(0xebebeb).CGColor];
}

@end
