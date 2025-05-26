//
//  YLBasicView.m
//  beijing
//
//  Created by zhou last on 2018/6/26.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLBasicView.h"
#import "DefineConstants.h"
@implementation YLBasicView



/**
 三个地方圆角，一个直角(聊天专用)
 //UIRectCornerBottomLeft
 @param view 需要设置的视图
 */
+ (void)topAngleCorner:(UIView *)view firstCorner:(UIRectCorner)firstCorner secondCorner:(UIRectCorner)secondCorner thirdCorner:(UIRectCorner)thirdCorner radius:(float)radius
{
    UIBezierPath  *maskPath= [UIBezierPath  bezierPathWithRoundedRect:view.bounds
                              
                                                    byRoundingCorners:firstCorner|secondCorner|thirdCorner
                                                        cornerRadii:CGSizeMake(radius,radius)];
    
    CAShapeLayer*maskLayer = [CAShapeLayer new];
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

/**
 下面部分圆角,上面直角
//UIRectCornerBottomLeft
 @param view 需要设置的视图
 */
+ (void)topRightAngleBottomCorner:(UIView *)view firstCorner:(UIRectCorner)firstCorner secondCorner:(UIRectCorner)secondCorner radius:(float)radius
{
    UIBezierPath  *maskPath= [UIBezierPath  bezierPathWithRoundedRect:view.bounds
                              
                                                    byRoundingCorners:firstCorner | secondCorner
                              
                                                          cornerRadii:CGSizeMake(radius,radius)];
    
    CAShapeLayer*maskLayer = [CAShapeLayer new];
    
    
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

+ (void)angleCorner:(UIView *)view firstCorner:(UIRectCorner)firstCorner radius:(float)radius
{
    UIBezierPath  *maskPath= [UIBezierPath  bezierPathWithRoundedRect:view.bounds
                              
                                                    byRoundingCorners:firstCorner
                              
                                                          cornerRadii:CGSizeMake(radius,radius)];
    
    CAShapeLayer*maskLayer = [CAShapeLayer new];
    
    
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}


/**
 创建uilabel

 @param content text内容
 @param size 字体大小
 @param color 字体颜色
 @param textAlignment 字体位置
 @return 返回一个label
 */
+ (UILabel *)createLabeltext:(NSString *)content size:(UIFont *)size color:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *tittleLabel = [UILabel new];
    tittleLabel.textColor = color;
    tittleLabel.textAlignment = textAlignment;
    tittleLabel.font = size;
    tittleLabel.text = content;
    
    return tittleLabel;
}


/**
 创建imageView

 @param image 图片
 @return 返回一个imageView
 */
+ (UIImageView *)createImgView:(UIImage *)image
{
    UIImageView *imgView = [UIImageView new];
    imgView.image = image;
    [imgView setClipsToBounds:YES];
    
    return imgView;
}


/**
  创建imageView

 @param image 图片
 @param cornerRadius 圆角角度
 @param color 背景颜色
 @return 返回一个imageView
 */
+ (UIImageView *)createImgView:(UIImage *)image cornerRadius:(float)cornerRadius color:(UIColor *)color
{
    UIImageView *imgView = [UIImageView new];
    imgView.image = image;
    [imgView.layer setCornerRadius:cornerRadius];
//    imgView.backgroundColor = color;
    [imgView setClipsToBounds:YES];
    
    return imgView;
}




/**
 创建UIView

 @param color 颜色
 @param alpha 透明度
 @return 返回一个view
 */
+ (UIView *)createView:(UIColor *)color alpha:(float)alpha
{
    UIView *view = [UIView new];
    if (color != nil) {
        view.backgroundColor = color;
    }
    view.alpha = alpha;
    
    return view;
}


/**
 创建button

 @param textColor 文字颜色
 @param text 文字内容
 @param backColor 背景颜色
 @param cordius 圆角幅度
 @return 返回一个button
 */
+ (UIButton *)createButton:(UIColor *)textColor text:(NSString *)text backColor:(UIColor *)backColor cordius:(float)cordius font:(UIFont *)font
{
    UIButton *button = [UIButton new];
    
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setBackgroundColor:backColor];
    button.titleLabel.font = font;
    
    if (cordius > 0.0) {
        [button.layer setCornerRadius:cordius];
        [button setClipsToBounds:YES];
    }
    
    return button;
}


+ (UIView *)blackView
{
    UIView *blackCoverView = [UIView new];
    blackCoverView.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
    blackCoverView.alpha = .3;
    blackCoverView.userInteractionEnabled = YES;
    blackCoverView.backgroundColor = KBLACKCOLOR;
    
    return blackCoverView;
}

+ (UICollectionView *)createCollectView:(float)headerheight
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
    layout.headerReferenceSize = CGSizeMake(App_Frame_Width, headerheight);
    //该方法也可以设置itemSize
    UICollectionView *nGodnessCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 2, App_Frame_Width, APP_Frame_Height - 2) collectionViewLayout:layout];
    [nGodnessCollectView setScrollsToTop:YES];
    nGodnessCollectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    nGodnessCollectView.alwaysBounceVertical = YES;
    nGodnessCollectView.backgroundColor = KWHITECOLOR;
    
    return nGodnessCollectView;
}

/**
 创建button

 @param bgImg 背景图
 @param text 内容
 @param textColor 字体颜色
 @param btnImg 按钮图片
 @return 返回button
 */
+ (UIButton *)createButtonBackImg:(UIImage *)bgImg text:(NSString *)text textColor:(UIColor *)textColor btnImg:(UIImage *)btnImg
{
    
    UIButton *button = [UIButton new];
    
    if (bgImg != nil) {
        [button setBackgroundImage:bgImg forState:UIControlStateNormal];
    }
    
    if (text.length != 0) {
        [button setTitle:text forState:UIControlStateNormal];
    }
    
    if (textColor != nil) {
        [button setTitleColor:textColor forState:UIControlStateNormal];
    }

    if (btnImg != nil) {
        [button setImage:btnImg forState:UIControlStateNormal];
    }
    
    return button;
}

/**
 等比例压缩图片

 @param sourceImage 原图
 @param size 压缩大小
 @return 返回一个uiimage
 */
+ (UIImage *) imageCompressFitSizeScale:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

@end
