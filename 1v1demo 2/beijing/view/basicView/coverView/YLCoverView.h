//
//  YLCoverView.h
//  beijing
//
//  Created by zhou last on 2018/6/19.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLCoverView : UIView

typedef void(^YLChoosePictureBLOCK)(UIImage *image);


+ (id)shareInstance;

- (void)addCoverView:(UIView *)headView selfVC:(UIViewController *)selfVC block:(YLChoosePictureBLOCK)block pictureArray:(NSMutableArray *)pictureArray action:(SEL)action;

@end
