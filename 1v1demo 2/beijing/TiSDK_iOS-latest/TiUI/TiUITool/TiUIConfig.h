//
//  TiUIConfig.h
//  TiFancy
//
//  Created by Itachi Uchiha on 2021/8/11.
//  Copyright © 2021 Tillusory Tech. All rights reserved.
//

#import <TiSDK/TiSDKInterface.h>
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "TiMenuPlistManager.h"

#import "TiUIAdapter.h"
#import "TiUIManager.h"

// UI版本号
#define TiUICurrentVersion @"1.7"

#ifndef TI_UI_CONFIG_H
#define TI_UI_CONFIG_H

// 屏幕宽高
#define TiUIScreenWidth [[UIScreen mainScreen] bounds].size.width
#define TiUIScreenHeight [[UIScreen mainScreen] bounds].size.height

// 点击子菜单总开关按钮发出的通知
#define NotificationCenterSubMenuOnTotalSwitch @"NotificationCenterSubMenuOnTotalSwitch"

#define WeakSelf __weak typeof(self) weakSelf = self;

#define getSafeBottomHeight ([[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom)

// 短视频录制相关
#define RecordLimitTime 15.0           //最长录制时间
#define TimerInterval 0.01         //计时器刷新频率
#define TiVideoFolder @"videoFolder" //视频录制存放文件夹

// 英文字体
#define TiFontHelvetica(s) [UIFont fontWithName:@"Helvetica" size:s]
#define TiFontHelveticaSmall [UIFont fontWithName:@"Helvetica" size:10]
#define TiFontHelveticaMedium [UIFont fontWithName:@"Helvetica" size:12]
#define TiFontHelveticaBig [UIFont fontWithName:@"Helvetica" size:14]
// 中文字体
#define TiFontRegular(s) [UIFont fontWithName:@"PingFang-SC-Regular" size:s]
#define TiFontMedium(s) [UIFont fontWithName:@"PingFang-SC-Medium" size:s]

// 颜色
#define TiColor(r,g,b,a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
#define TiColors(s,a) [UIColor colorWithRed:((s) / 255.0) green:((s) / 255.0) blue:((s) / 255.0) alpha:(a)]

// 不同比例对应的背景高度
#define TiPhotoSize11Height TiUIScreenWidth
#define TiPhotoSize34Height (TiUIScreenWidth*4/3)
#define TiPhotoSizeFullHeight TiUIScreenHeight

#define navigationView11Height ([[TiUIAdapter shareInstance] heightAfterAdaptionByRawHeight:107] + [[TiUIAdapter shareInstance] statusBarHeightAfterAdaption])
#define navigationView34Height ([[TiUIAdapter shareInstance] heightAfterAdaptionByRawHeight:50] + [[TiUIAdapter shareInstance] statusBarHeightAfterAdaption])
#define navigationViewFullHeight 0

#define bottomView11Height (TiUIScreenHeight - navigationView11Height - TiPhotoSize11Height)
#define bottomView34Height (TiUIScreenHeight - navigationView34Height - TiPhotoSize34Height)
#define bottomViewFullHeight 0

// MARK: --默认按钮的宽度(以拍照按钮为基准) TiUIDefaultButtonView--
#define TiDefaultButtonWidth TiUIScreenWidth/4

// MARK:  滑动条View --TiUISliderRelatedView--
#define TiUISliderRelatedViewHeight [[TiUIAdapter shareInstance] heightAfterAdaptionByRawHeight:64]
// MARK:  菜单View高度
#define TiUIMenuViewHeight [[TiUIAdapter shareInstance] heightAfterAdaptionByRawHeight:40]
// MARK:  右边返回按钮View宽度
#define TiUIBackViewWidth [[TiUIAdapter shareInstance] widthAfterAdaptionByRawWidth:55]
// MARK: --美颜弹框视图总高度 TiUIManager--
#define TiUIViewBoxTotalHeight ([[TiUIAdapter shareInstance] heightAfterAdaptionByRawHeight:224] + TiUISliderRelatedViewHeight)

// MARK:  滑块View --TiUISliderView--
#define TiUISlideBarHeight [[TiUIAdapter shareInstance] widthAfterAdaptionByRawWidth:3]

#define TiUISliderViewWidth [[TiUIAdapter shareInstance] widthAfterAdaptionByRawWidth:33]
#define TiUISliderViewHeight [[TiUIAdapter shareInstance] widthAfterAdaptionByRawWidth:41]

#define TiUISliderSize [[TiUIAdapter shareInstance] widthAfterAdaptionByRawWidth:20]
#define TiUISplitPointSize [[TiUIAdapter shareInstance] widthAfterAdaptionByRawWidth:7]


// MARK:  子菜单状态1View --TiUISubMenuOneView--
#define TiUISubMenuOneViewTiButtonWidth [[TiUIAdapter shareInstance] widthAfterAdaptionByRawWidth:46]
#define TiUISubMenuOneViewTiButtonHeight [[TiUIAdapter shareInstance] widthAfterAdaptionByRawWidth:66]

#define TiUISubMenuTwoViewTiButtonWidth [[TiUIAdapter shareInstance] widthAfterAdaptionByRawWidth:60]
#define TiUISubMenuTwoViewTiButtonHeight [[TiUIAdapter shareInstance] widthAfterAdaptionByRawWidth:76]

#define TiUISubMenuThreeViewTiButtonWidth [[TiUIAdapter shareInstance] widthAfterAdaptionByRawWidth:62]
#define TiUISubMenuThreeViewTiButtonHeight [[TiUIAdapter shareInstance] widthAfterAdaptionByRawWidth:62]

#define TiUISubMenuMakeUpViewTiButtonWidth [[TiUIAdapter shareInstance] widthAfterAdaptionByRawWidth:62]
#define TiUISubMenuMakeUpViewTiButtonHeight [[TiUIAdapter shareInstance] widthAfterAdaptionByRawWidth:70]

// MARK: -- 与一键美颜中“标准” 类型参数一致
#define SkinWhiteningValue 70 // 美白滑动条默认参数
#define SkinBlemishRemovalValue 70 // 磨皮滑动条默认参数
#define SkinTendernessValue 40 // 粉嫩滑动条默认参数
#define SkinBrightValue 60 // 清晰滑动条默认参数
#define SkinBrightnessValue 0 // 亮度滑动条默认参数，0表示无亮度效果，[-50, 0]表示降低亮度，[0, 50]表示提升亮度

#define SkinPreciseBeautyValue 0 // 精细磨皮滑动条默认参数
#define SkinPreciseTendernessValue 0 // 精细粉嫩滑动条默认参数
#define SkinHighlightValue 0 // 立体滑动条默认参数
#define SkinDarkCircleValue 0 // 黑眼圈滑动条默认参数
#define SkinCrowsFeetValue 0 // 鱼尾纹滑动条默认参数
#define SkinNasolabialFoldValue 0 // 法令纹滑动条默认参数

#define EyeMagnifyingValue 60 // 大眼滑动条默认参数
#define ChinSlimmingValue 60 // 瘦脸滑动条默认参数
//脸部
#define FaceNarrowingValue 15 // 窄脸滑动条默认参数
#define JawTransformingValue 0 // 下巴滑动条默认参数
#define ForeheadTransformingValue 0 // 额头滑动条默认参数
#define CheekboneSlimmingValue 0 // 瘦颧骨滑动条默认参数
#define JawboneSlimmingValue 0 // 瘦下颌滑动条默认参数
#define JawSlimmingValue 0 // 削下巴滑动条默认参数
//眼部
#define EyeInnerCornersValue 0 // 内眼角滑动条默认参数
#define EyeOuterCornersValue 0 // 外眼尾滑动条默认参数
#define EyeSpacingValue 0 // 眼间距滑动条默认参数
#define EyeCornersValue 0 // 倾斜滑动条默认参数
//鼻子
#define NoseMinifyingValue 0 // 瘦鼻滑动条默认参数
#define NoseElongatingValue 0 // 长鼻滑动条默认参数
//嘴巴
#define MouthTransformingValue 0 // 嘴型滑动条默认参数
#define MouthHeightValue 0 // 嘴高低滑动条默认参数
#define MouthLipSizeValue 0 // 唇厚薄滑动条默认参数
#define MouthSmilingValue 0 // 扬嘴角滑动条默认参数
//眉毛
#define BrowHeightValue 0 // 眉高低滑动条默认参数
#define BrowLengthValue 0 // 眉长短滑动条默认参数
#define BrowSpaceValue 0 // 眉间距滑动条默认参数
#define BrowSizeValue 0 // 眉粗细滑动条默认参数
#define BrowCornerValue 0 // 提眉峰滑动条默认参数

#define FilterValue 100 // 滤镜滑动条默认参数

#define OnewKeyBeautyValue 100 // 一键美颜
#define FaceShapeBeautyValue 100 // 脸型

#define SimilarityValue 0 //相似度滑动条默认参数
#define SmoothnessValue 0 //平滑度滑动条默认参数
#define AlphaValue 0 //透明度滑动条默认参数

#define CheekRedValue 100 //腮红默认参数
//#define EyelashValue 100 //睫毛默认参数
#define EyebrowsValue 100 //眉毛默认参数
#define EyeshadowValue 100 //眼影默认参数
//#define EyelineValue 100 //眼线默认参数
#define LipGlossValue 100 //唇彩默认参数

#define HairdressValue 100 //美发滑动条默认参数

#endif /* TI_UI_CONFIG_H */
