//
//  VideoImageView.h
//  beijing
//
//  Created by 黎 涛 on 2019/10/10.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVKit/AVKit.h>
#import "UIManager.h"
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoImageView : UIImageView

@property (nonatomic, copy) NSString *defaultUrl;
@property (nonatomic, strong) AVPlayer *avplayer;

@property (nonatomic, copy) void (^deleteButtonClick)(void);

- (void)play;
- (void)pause;

@end

NS_ASSUME_NONNULL_END
