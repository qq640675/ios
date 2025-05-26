//
//  LaunchAdvImageView.h
//  beijing
//
//  Created by 黎 涛 on 2019/8/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LaunchAdvImageView : UIImageView

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *advUrl;
@property (nonatomic, copy) void (^advImageClick)(NSString *urlString);  //广告点击
@property (nonatomic, copy) void (^jumpButtonClick)(void);  //跳过



@end

NS_ASSUME_NONNULL_END
