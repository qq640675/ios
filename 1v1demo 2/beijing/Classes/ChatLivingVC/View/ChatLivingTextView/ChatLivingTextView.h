//
//  ChatLivingTextView.h
//  beijing
//
//  Created by yiliaogao on 2019/2/25.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BaseView.h"
#import "SLPlaceHolderTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatLivingTextView : BaseView
<
UITextViewDelegate
>

@property (nonatomic, strong) SLPlaceHolderTextView    *textView;

@property (nonatomic, assign) CGFloat        fTextWidth;

@property (nonatomic, assign) BOOL           bChanged;

@property (nonatomic, copy) void(^ClickedSendBtnBlock)(NSString *sendContent);

@end

NS_ASSUME_NONNULL_END
