//
//  MansionInputView.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/8.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MansionInputView : BaseView<UITextFieldDelegate>

@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton *emojiBtn;
@property (nonatomic, strong) UIButton *giftBtn;

@property (nonatomic, copy) void (^sendTextBlock)(NSString *text);
@property (nonatomic, copy) void (^emojiButtonClickBlock)(void);
@property (nonatomic, copy) void (^sendGiftButtonClickBlock)(void);


@end

NS_ASSUME_NONNULL_END
