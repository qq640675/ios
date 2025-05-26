//
//  HomeSendMessageAlertView.h
//  beijing
//
//  Created by 黎 涛 on 2020/9/14.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeSendMessageAlertView : BaseView

@property (nonatomic, strong) NSArray *messageArray;
@property (nonatomic, copy) NSString *selectedMessageId;
@property (nonatomic, strong) UIScrollView *scrollView;

- (instancetype)initWithMessageArray:(NSArray *)array;
- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
