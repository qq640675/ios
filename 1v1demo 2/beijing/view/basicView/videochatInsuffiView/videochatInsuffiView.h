//
//  videochatInsuffiView.h
//  beijing
//
//  Created by zhou last on 2018/12/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface videochatInsuffiView : UIView

//关闭
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
//余额通话时间
@property (weak, nonatomic) IBOutlet UILabel *suffiTimeLabel;
//继续呼叫
@property (weak, nonatomic) IBOutlet UIButton *callingNowBtn;
//充值
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;

@property (weak, nonatomic) IBOutlet UIView *whiteBgView;

- (void)suffiCordius;

@end

NS_ASSUME_NONNULL_END
