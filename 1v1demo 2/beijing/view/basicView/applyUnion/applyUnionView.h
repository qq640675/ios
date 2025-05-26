//
//  applyUnionView.h
//  beijing
//
//  Created by zhou last on 2018/9/14.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface applyUnionView : UIView

//申请者姓名
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
//身份证号码
@property (weak, nonatomic) IBOutlet UITextField *idcardTextField;
//联系方式
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
//公会名称
@property (weak, nonatomic) IBOutlet UITextField *unionNameTextField;
//主播人数
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;


//上传照片按钮
@property (weak, nonatomic) IBOutlet UIButton *uploadImageBtn;
//新游山公会协议书
@property (weak, nonatomic) IBOutlet UILabel *unionAgreenmentLabel;
//同意或不同意协议图标
@property (weak, nonatomic) IBOutlet UIImageView *selImgView;
//确定申请
@property (weak, nonatomic) IBOutlet UIButton *applyOkBtn;

//认证使用，（不会公开）需改变颜色
@property (weak, nonatomic) IBOutlet UILabel *privateLabel;

//协议背景
@property (weak, nonatomic) IBOutlet UIView *agreementBgView;



//view 仅改变圆角和边框使用
@property (weak, nonatomic) IBOutlet UIView *nameBgView;
@property (weak, nonatomic) IBOutlet UIView *idcardBgView;
@property (weak, nonatomic) IBOutlet UIView *mobileBgView;
@property (weak, nonatomic) IBOutlet UIView *unionNameBgView;
@property (weak, nonatomic) IBOutlet UIView *numberBgView;

//方法
- (void)unionCordius;

@end
