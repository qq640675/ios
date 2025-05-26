//
//  MessageGiftCell.h
//  beijing
//
//  Created by 黎 涛 on 2020/1/7.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "TUIMessageCell.h"
#import "MessageGiftCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageGiftCell : TUIMessageCell

@property (nonatomic, strong) UIView *giftBGView;
@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) UILabel *contentTextLabel;


@end

NS_ASSUME_NONNULL_END
