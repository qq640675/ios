//
//  MansionMessageModel.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/11.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MansionMessageModel : NSObject

@property (nonatomic, assign) MansionMessageType messageType;
@property (nonatomic, copy) NSString *headImagePath;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, assign) int t_id;
@property (nonatomic, copy) NSString *gift_name;
@property (nonatomic, copy) NSString *gift_still_url;
@property (nonatomic, copy) NSString *otherName; //被送礼物的人  或者是被踢出的人
@property (nonatomic, assign) int otherId;
@property (nonatomic, copy) NSString *contentText;

@end

NS_ASSUME_NONNULL_END
