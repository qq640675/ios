//
//  MessageVideoAnchorCellData.h
//  beijing
//
//  Created by 黎 涛 on 2020/1/8.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "TUIMessageCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageVideoAnchorCellData : TUIMessageCellData

@property (nonatomic, strong) UIImage *headImage;
@property (nonatomic, copy) NSString *avaterImageUrl;
@property (nonatomic, copy) NSData *videoData;

@end

NS_ASSUME_NONNULL_END
