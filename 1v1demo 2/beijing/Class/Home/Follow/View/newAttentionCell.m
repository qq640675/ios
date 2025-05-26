//
//  newAttentionCell.m
//  beijing
//
//  Created by zhou last on 2018/10/28.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "newAttentionCell.h"
#import "DefineConstants.h"

@implementation newAttentionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headImgView.layer setCornerRadius:30.0f];
    self.headImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headImgView setClipsToBounds:YES];

    [self.statusView.layer setCornerRadius:10.0f];
    [self.statusView.layer setBorderWidth:1.];
    [self.statusView setClipsToBounds:YES];
    
    [self.circleView.layer setCornerRadius:2.5];
    [self.circleView setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
