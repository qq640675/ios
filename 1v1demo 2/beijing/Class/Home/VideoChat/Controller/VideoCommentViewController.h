//
//  VideoCommentViewController.h
//  Qiaqia
//
//  Created by 刘森林 on 2021/1/29.
//  Copyright © 2021 yiliaogaoke. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoCommentViewController : BaseViewController

@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, assign) int otherUserId;

@end

NS_ASSUME_NONNULL_END
