//
//  searchListCell.m
//  beijing
//
//  Created by zhou last on 2018/8/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "searchListCell.h"
#import "DefineConstants.h"

@implementation searchListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.attentionView.layer setCornerRadius:12.5];
    [self.attentionView.layer setBorderWidth:1.];
    [self.attentionView.layer setBorderColor:XZRGB(0xfac00b).CGColor];
    [self.attentionView setClipsToBounds:YES];
    
    
    [self.videoChatView.layer setCornerRadius:12.5];
    [self.videoChatView.layer setBorderWidth:1.];
    [self.videoChatView.layer setBorderColor:XZRGB(0xfd49aa).CGColor];
    [self.videoChatView setClipsToBounds:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
