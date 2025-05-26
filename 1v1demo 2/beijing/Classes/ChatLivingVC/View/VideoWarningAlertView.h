//
//  VideoWarningAlertView.h
//  beijing
//
//  Created by 黎 涛 on 2020/3/5.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoWarningAlertView : BaseView

@property (nonatomic, strong) UILabel *contentLabel;

- (void)showWithContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
