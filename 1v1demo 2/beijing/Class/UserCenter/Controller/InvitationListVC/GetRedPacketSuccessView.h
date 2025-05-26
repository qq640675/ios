//
//  GetRedPacketSuccessView.h
//  beijing
//
//  Created by 黎 涛 on 2020/12/24.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetRedPacketSuccessView : BaseView

- (instancetype)initWithRedPacketData:(NSDictionary *)dataDic;
- (void)show;

@end

NS_ASSUME_NONNULL_END
