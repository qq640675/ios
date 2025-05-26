//
//  MessageVideoUserCell.h
//  beijing
//
//  Created by 黎 涛 on 2020/1/8.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "TUIMessageCell.h"
#import "MessageVideoUserCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageVideoUserCell : TUIMessageCell

@property (nonatomic, strong) UIView *videoBGView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UILabel *contentTextLabel;

@end

NS_ASSUME_NONNULL_END
