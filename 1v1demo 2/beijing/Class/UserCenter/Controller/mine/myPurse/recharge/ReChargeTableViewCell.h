//
//  ReChargeTableViewCell.h
//  beijing
//
//  Created by 黎 涛 on 2019/6/18.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReChargeTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isChoosedMore;
@property (nonatomic, copy) void (^moPayType)(void);
@property (nonatomic, copy) void (^payTypeChanged)(int selIndex); // type：0  支付宝   1 微信

@end

NS_ASSUME_NONNULL_END
