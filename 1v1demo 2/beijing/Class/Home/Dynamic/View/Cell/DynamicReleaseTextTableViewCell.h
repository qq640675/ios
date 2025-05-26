//
//  DynamicReleaseTextTableViewCell.h
//  beijing
//
//  Created by yiliaogao on 2018/12/26.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "SLBaseTableViewCell.h"
#import "SLPlaceHolderTextView.h"
#import "DynamicReleaseTextModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicReleaseTextTableViewCell : SLBaseTableViewCell
<
UITextViewDelegate
>

@property (nonatomic, strong) SLPlaceHolderTextView     *contentTextView;

@property (nonatomic, strong) DynamicReleaseTextModel   *textModel;

@end

NS_ASSUME_NONNULL_END
