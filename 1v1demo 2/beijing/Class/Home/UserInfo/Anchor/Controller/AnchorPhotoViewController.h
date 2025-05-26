//
//  AnchorPhotoViewController.h
//  beijing
//
//  Created by 黎 涛 on 2020/4/15.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnchorPhotoViewController : BaseViewController

@property (nonatomic, assign) NSInteger anchorId;
@property (nonatomic, assign) int type;  //0图片   1视频
@property (nonatomic, assign) BOOL isMe;


@end

NS_ASSUME_NONNULL_END
