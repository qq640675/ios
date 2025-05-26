//
//  YLBasicView.h
//  beijing
//
//  Created by zhou last on 2018/6/26.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface YLBasicView : NSObject


/**
 三个地方圆角，一个直角(聊天专用)
 //UIRectCornerBottomLeft
 @param view 需要设置的视图
 */
+ (void)topAngleCorner:(UIView *)view firstCorner:(UIRectCorner)firstCorner secondCorner:(UIRectCorner)secondCorner thirdCorner:(UIRectCorner)thirdCorner radius:(float)radius;

//下面部分圆角,上面直角
+ (void)topRightAngleBottomCorner:(UIView *)view firstCorner:(UIRectCorner)firstCorner secondCorner:(UIRectCorner)secondCorner radius:(float)radius;

+ (void)angleCorner:(UIView *)view firstCorner:(UIRectCorner)firstCorner radius:(float)radius;

//创建label
+ (UILabel *)createLabeltext:(NSString *)content size:(UIFont *)size color:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment;

//创建一个uiimageView
+ (UIImageView *)createImgView:(UIImage *)image;

+ (UIImageView *)createImgView:(UIImage *)image cornerRadius:(float)cornerRadius color:(UIColor *)color;

//黑色遮罩层
+ (UIView *)blackView;

//collectView
+ (UICollectionView *)createCollectView:(float)headerheight;

//创建一个UIView
+ (UIView *)createView:(UIColor *)color alpha:(float)alpha;

//创建一个button
+ (UIButton *)createButton:(UIColor *)textColor text:(NSString *)text backColor:(UIColor *)backColor cordius:(float)cordius font:(UIFont *)font;

+ (UIButton *)createButtonBackImg:(UIImage *)bgImg text:(NSString *)text textColor:(UIColor *)textColor btnImg:(UIImage *)btnImg;

//等比例压缩图片
+ (UIImage *) imageCompressFitSizeScale:(UIImage *)sourceImage targetSize:(CGSize)size;

@end
