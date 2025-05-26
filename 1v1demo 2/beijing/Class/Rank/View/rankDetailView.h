//
//  rankDetailView.h
//  beijing
//
//  Created by zhou last on 2018/10/6.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface rankDetailView : UIView

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
//新游山号
@property (weak, nonatomic) IBOutlet UILabel *ylnumberLabel;
//浅蓝色背景
@property (weak, nonatomic) IBOutlet UIView *blueBgView;
//白色背景
@property (weak, nonatomic) IBOutlet UIView *whiteBgView;


//文字聊天
@property (weak, nonatomic) IBOutlet UILabel *textchatLabel;
//视频通话
@property (weak, nonatomic) IBOutlet UILabel *videoChatLabel;
//私聊照片
@property (weak, nonatomic) IBOutlet UILabel *privatePictureLabel;
//私聊视频
@property (weak, nonatomic) IBOutlet UILabel *privateVideoLabel;
//手机号
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

//微信号
@property (weak, nonatomic) IBOutlet UILabel *wechatNumberLabel;


- (void)cordius;

@end

NS_ASSUME_NONNULL_END
