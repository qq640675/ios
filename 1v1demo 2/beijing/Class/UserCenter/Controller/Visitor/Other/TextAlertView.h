//
//  TextAlertView.h
//  beijing
//
//  Created by 黎 涛 on 2020/12/21.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TextAlertView : BaseView


@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, assign) BOOL isShowCancle;
@property (nonatomic, copy) NSString *cancleTitle;
@property (nonatomic, copy) NSString *sureTitle;
@property (nonatomic) NSTextAlignment    textAlignment;
@property (nonatomic, copy) void (^ cancleHandle)(void);
@property (nonatomic, copy) void (^ sureHandle)(void);

/*
 * 只有确认按钮 无回调
 */
- (instancetype)initWithTitle:(nullable NSString *)title;
/*
 * 只有确认按钮 带确定回调
 */
- (instancetype)initOnlySureWithTitle:(nullable NSString *)title
                           sureHandle:(void(^)(void))sure;

/*
 * 确认取消按钮 带确定回调
 */
- (instancetype)initWithTitle:(nullable NSString *)title
                   sureHandle:(nullable void(^)(void))sure;

/*
 * 确认取消按钮 按钮可自定义名称 带确定回调
 */
- (instancetype)initWithTitle:(nullable NSString *)title
                  cancleTitle:(nullable NSString *)cancleTitle
                    sureTitle:(nullable NSString *)sureTitle
                   sureHandle:(nullable void(^)(void))sure;

/*
 * 确认取消按钮 按钮可自定义名称 带确定和取消回调
 */
- (instancetype)initWithTitle:(nullable NSString *)title
                  cancleTitle:(nullable NSString *)cancleTitle
                    sureTitle:(nullable NSString *)sureTitle
                   sureHandle:(nullable void(^)(void))sure
                 cancleHandle:(nullable void(^)(void))cancle;

// NSString 内容
- (void)setContentWithString:(NSString *)str;

// NSAttributedString 内容
- (void)setContentWithAttibutedString:(NSAttributedString *)attri;



@end

NS_ASSUME_NONNULL_END
