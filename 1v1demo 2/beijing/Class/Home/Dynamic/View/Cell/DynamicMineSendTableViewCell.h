//
//  DynamicMineSendTableViewCell.h
//  beijing
//
//  Created by yiliaogao on 2019/1/23.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseTableViewCell.h"

@protocol DynamicMineSendTableViewCellDelegate <NSObject>

- (void)didSelectDynamicMineSendTableViewCellWithSendBtn;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DynamicMineSendTableViewCell : SLBaseTableViewCell

@property (nonatomic, weak) id<DynamicMineSendTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
