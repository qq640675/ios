//
//  searchListCell.h
//  beijing
//
//  Created by zhou last on 2018/8/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchListCell : UITableViewCell

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
//直播状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

//名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//粉丝
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
//认证状态
@property (weak, nonatomic) IBOutlet UIImageView *authImgView;
//关注
@property (weak, nonatomic) IBOutlet UIView *attentionView;
//视频聊天
@property (weak, nonatomic) IBOutlet UIView *videoChatView;
//关注label
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;

@end
