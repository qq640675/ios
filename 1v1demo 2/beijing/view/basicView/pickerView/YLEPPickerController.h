//
//  YLEPPickerController.h
//  pickerViewDemo
//
//  Created by zhou last on 2018/7/4.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    YLEditPersonalTypeHeight = 0, //身高 100-199 default:160
    YLEditPersonalTypeWeight, //体重30-80kg default:40kg
    YLEditPersonalTypeAge, //年龄20-50岁 defaul: 25岁
//    YLEditPersonalTypeXingZuo, //星座
    YLEditPersonalTypeHunyin,
    YLEditPersonalTypeCity,  //城市 地级市 default:中国北京
    YLEditPersonalTypeImageLabel,//形象标签 随机默认两个
    YLEditPersonalTypeProfession,//职业
    YLEditPersonalTypeVideo, //视频聊天
    YLEditPersonalTypeText, //文字聊天
    YLEditPersonalTypePhone, //查看手机号
    YLEditPersonalTypeWeiXin, //查看微信号
    YLEditPersonalTypeCPS, //CPS
}YLEditPersonalType;


@interface YLEPPickerController : UIViewController

typedef void(^YLPickerFinish)(NSString *tittle);


+ (id)shareInstance;

- (void)customUI;

- (void)cpsMethodList:(NSMutableArray *)listArray;

- (void)reloadPickerViewData:(YLEditPersonalType)Etype block:(YLPickerFinish)block;

@end
