//
//  DynamicCommentTextView.h
//  beijing
//
//  Created by yiliaogao on 2019/1/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "SLPlaceHolderTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicCommentTextView : BaseView
<
UITextViewDelegate
>

@property (nonatomic, strong) SLPlaceHolderTextView    *textView;

@property (nonatomic, assign) CGFloat        fTextWidth;

@property (nonatomic, assign) BOOL           bChanged;

@property (nonatomic, copy) void(^clickedSendBtnBlock)(NSString *sendContent);

@end

NS_ASSUME_NONNULL_END
