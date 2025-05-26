//
//  unionCell.m
//  beijing
//
//  Created by zhou last on 2018/9/11.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "unionCell.h"

@implementation unionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.headImgView.layer setCornerRadius:25.];
    [self.headImgView setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
