//
//  versionView.h
//  beijing
//
//  Created by zhou last on 2018/11/22.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface versionView : UIView

//版本
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
//平台已更新到某个版本
@property (weak, nonatomic) IBOutlet UITextView *textView;
//立即更新
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;


@end

NS_ASSUME_NONNULL_END
