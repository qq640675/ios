//
//  MansionVideoShowView.h
//  beijing
//
//  Created by 黎 涛 on 2020/6/8.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MansionVideoShowView : BaseView

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UIView *videoBG;
@property (nonatomic, copy) UIImageView *videoImageV;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) BOOL isOwner;
@property (nonatomic, assign) BOOL isOwnerView;
@property (nonatomic, copy) void (^addButtonClickBlock)(void);
@property (nonatomic, copy) void (^deleteButtonClickBlock)(void);
@property (nonatomic, copy) void (^voiceButtonClickBlock)(UIButton *sender);
@property (nonatomic, copy) void (^cameraButtonClickBlock)(void);


/// 府邸视频视图初始化
/// @param frame frame
/// @param isOwner 是否房主自己的房间
/// @param isOwnerView 是否房主视图
/// @param tag tag
- (instancetype)initWithFrame:(CGRect)frame isHouseOwner:(BOOL)isOwner isOwnerView:(BOOL)isOwnerView tag:(int)tag type:(MansionChatType)mansionType;

- (void)resetFrame:(CGRect)frame;



@end

NS_ASSUME_NONNULL_END
