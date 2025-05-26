//
//  DynamicReleasePicTableViewCell.h
//  beijing
//
//  Created by yiliaogao on 2018/12/26.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "SLBaseTableViewCell.h"
#import "DynamicPicView.h"
#import "DynamicVideoView.h"

@protocol DynamicReleasePicTableViewCellDelegate <NSObject>

- (void)didSelectDynamicReleasePicTableViewCellBtn:(NSUInteger)btnTag;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DynamicReleasePicTableViewCell : SLBaseTableViewCell
<
DynamicPicViewDelegate,
DynamicVideoViewDelegate
>

@property (nonatomic, strong) UIButton *addPicBtn;

@property (nonatomic, weak) id<DynamicReleasePicTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
