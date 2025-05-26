//
//  YLApplyCertiView.h
//  beijing
//
//  Created by zhou last on 2018/6/19.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLApplyCertiView : UIView

//上传形象图片
@property (weak, nonatomic) IBOutlet UIButton *uploadPhotoButton;
//上传视频
@property (weak, nonatomic) IBOutlet UIButton *uploadVideoButton;
//真实姓名
@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
//身份证号
@property (weak, nonatomic) IBOutlet UITextField *idcardTextField;

@property (weak, nonatomic) IBOutlet UIButton *admitButton;
//协议书
@property (weak, nonatomic) IBOutlet UILabel *agreementLabel;


@end
