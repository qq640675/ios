//
//  HVideoViewController.h
//  Join
//
//  Created by 黄克瑾 on 2017/1/11.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TakeOperationSureBlock)(id item, UIImage *coverImage, NSUInteger sec, NSUInteger size);

@interface HVideoViewController : UIViewController

@property (copy, nonatomic) TakeOperationSureBlock takeBlock;

//轻触拍照，按住摄像
@property (strong, nonatomic) IBOutlet UILabel *labelTipTitle;

@property (assign, nonatomic) NSInteger HSeconds;

@property (nonatomic, assign) BOOL isAuth; //是否认证  需要拍摄10s视频
@property (nonatomic, copy) NSString *tipString;
@property (nonatomic, strong) UILabel *topTipLabel;

@end
