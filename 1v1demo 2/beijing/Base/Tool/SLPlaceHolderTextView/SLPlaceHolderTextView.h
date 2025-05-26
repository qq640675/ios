//
//  SLPlaceHolderTextView.h
//  LuNuBao_English
//
//  Created by apple on 2017/4/12.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLPlaceHolderTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
