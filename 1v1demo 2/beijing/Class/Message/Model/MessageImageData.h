//
//  MessageImageData.h
//  beijing
//
//  Created by 黎 涛 on 2020/1/14.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "TUIMessageCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageImageData : TUIMessageCellData

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) UIImage *headImage;
@property (nonatomic, copy) NSString *avaterImageUrl;
@property (nonatomic, assign) CGSize size;

@end

NS_ASSUME_NONNULL_END
