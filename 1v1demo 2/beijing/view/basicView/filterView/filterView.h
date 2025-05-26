//
//  filterView.h
//  beijing
//
//  Created by zhou last on 2018/8/29.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface filterView : UIView

typedef void (^YLFilterViewBlock)(int queryType);


@property (weak, nonatomic) IBOutlet UIView *whiteBgView;

//全部
@property (weak, nonatomic) IBOutlet UIButton *allButton;
//免费
@property (weak, nonatomic) IBOutlet UIButton *freeVideoButton;
//付费
@property (weak, nonatomic) IBOutlet UIButton *notFreeVideoButton;


- (void)cordius;
- (void)filterCordius:(YLFilterViewBlock)block;

@end
