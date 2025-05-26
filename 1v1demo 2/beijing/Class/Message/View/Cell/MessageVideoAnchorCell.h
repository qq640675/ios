//
//  MessageVideoAnchorCell.h
//  beijing
//
//  Created by 黎 涛 on 2020/1/8.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "TUIMessageCell.h"
#import "MessageVideoAnchorCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageVideoAnchorCell : TUIMessageCell

@property (nonatomic, strong) UIView *videoBGView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UILabel *contentTextLabel;
//@property (nonatomic, strong) UILabel *videoPriceLabel;
//@property (nonatomic, strong) UILabel *voicePriceLabel;
@property (nonatomic, strong) UIButton *callButton;
@property (nonatomic, assign) int anchorId;
@property (nonatomic, copy) NSString *callType;

@end

NS_ASSUME_NONNULL_END
