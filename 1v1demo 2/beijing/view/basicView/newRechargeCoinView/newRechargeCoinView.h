//
//  newRechargeCoinView.h
//  beijing
//
//  Created by zhou last on 2018/10/27.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface newRechargeCoinView : UIView

//我的金币
@property (weak, nonatomic) IBOutlet UILabel *myCoinLabel;

//账单详情
@property (weak, nonatomic) IBOutlet UIButton *accountDetailBtn;


@end

NS_ASSUME_NONNULL_END
