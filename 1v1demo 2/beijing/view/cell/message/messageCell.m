//
//  messageCell.m
//  beijing
//
//  Created by zhou last on 2018/6/25.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "messageCell.h"
#import "DefineConstants.h"

@implementation messageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [self.unreadNumLabel.layer setCornerRadius:10.];
    [self.unreadNumLabel setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
