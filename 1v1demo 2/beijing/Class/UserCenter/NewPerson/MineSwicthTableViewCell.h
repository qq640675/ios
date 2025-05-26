//
//  MineSwicthTableViewCell.h
//  beijing
//
//  Created by 黎 涛 on 2021/3/10.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "personalCenterHandle.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SwitchCellTypeVideo = 1,
    SwitchCellTypeChat = 3,
    SwitchCellTypePP = 5,
    SwitchCellTypeRank = 4,
} SwitchCellType;

@interface MineSwicthTableViewCell : UIView

@property (nonatomic, assign) SwitchCellType cellType;
@property (nonatomic, strong) personalCenterHandle *personHandle;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UISwitch *cellSwitch;
@property (nonatomic, strong) UILabel *statusL;

- (void)setType:(SwitchCellType)cellType;
- (void)setHandle:(personalCenterHandle *)handle;


@end

NS_ASSUME_NONNULL_END
