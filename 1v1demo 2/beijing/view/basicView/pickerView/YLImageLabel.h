//
//  YLImageLabel.h
//  pickerViewDemo
//
//  Created by zhou last on 2018/7/5.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLImageLabel : UIViewController

typedef void(^YLImageLabelFinish)(NSString *tittle,NSString *label_id);

+ (id)shareInstance;

- (void)imageLabelCustomUI:(NSMutableArray *)listArray;

- (void)reloadImageLabel:(YLImageLabelFinish)block;


@end
