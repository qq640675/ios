//
//  VideoPlayViewController.h
//  CQTNews
//
//  Created by Base on 2017/3/9.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyVideoPlayViewController : UIViewController

@property (copy, nonatomic) NSString *linkURL;

- (void)clickSelfViewBlock:(void(^)(id info))clickBlock;

@end
