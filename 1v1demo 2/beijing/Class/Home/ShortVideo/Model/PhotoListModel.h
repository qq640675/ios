//
//  PhotoListModel.h
//  beijing
//
//  Created by 黎 涛 on 2021/3/23.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoListModel : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imgUrl;

@end

NS_ASSUME_NONNULL_END
