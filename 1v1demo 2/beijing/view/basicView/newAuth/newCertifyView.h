//
//  newCertifyView.h
//  beijing
//
//  Created by zhou last on 2018/10/28.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface newCertifyView : UIView

//身份证
@property (weak, nonatomic) IBOutlet UIImageView *idcardImgView;

//正面照片
@property (weak, nonatomic) IBOutlet UIImageView *pictureImgView;

//立即认证
@property (weak, nonatomic) IBOutlet UIButton *certiNowBtn;

//相遇协议书
@property (weak, nonatomic) IBOutlet UILabel *agreementLabel;
@property (weak, nonatomic) IBOutlet UITextField *wechatTF;

- (void)cordius;

@end

NS_ASSUME_NONNULL_END
