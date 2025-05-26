//
//  MansionSendGiftView.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/13.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MansionSendGiftView : BaseView<UIScrollViewDelegate>

@property (nonatomic, copy) void (^ sendGiftIMMessageSeccess)(NSDictionary *param);
@property (nonatomic, copy) void (^ playGiftGif)(NSString *gifUrl);
@property (nonatomic, copy) void (^ videoChatSendGiftSuccess)(NSDictionary *dataDic);

+ (instancetype)shareView;
- (void)dismiss;
// 数组为赠送礼物对象的数组 只有一个对象可只需要ID 两个以上则需要头像和ID字段
- (void)showWithUserArray:(NSArray *)userArray isShowHead:(BOOL)isShowHead;
// 发送成功之后需要发送自定义IM消息
- (void)showWithUserArray:(NSArray *)userArray isShowHead:(BOOL)isShowHead conversasion:(TIMConversation *)conv;
// 送一个人礼物  是否需要播放gif
- (void)showWithUserId:(NSInteger)userId isPlayGif:(BOOL)isPlayGif;

@end

NS_ASSUME_NONNULL_END
