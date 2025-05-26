//
//  DynamicListTableViewCell.h
//  beijing
//
//  Created by yiliaogao on 2018/12/27.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "SLBaseTableViewCell.h"
#import "DynamicListModel.h"
#import "SLPhotoContainerView.h"
#import "DynamicFileModel.h"

@protocol DynamicListTableViewCellDelegate <NSObject>

- (void)didSelectDynamicListTableViewCellWithBtn:(NSInteger)btnTag curActionModel:(DynamicListModel *)curActionModel;

- (void)lookPrivateFile:(DynamicFileModel *)model;

- (void)updateVip;

- (void)playVideo:(DynamicListModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DynamicListTableViewCell : SLBaseTableViewCell
<
SLPhotoContainerViewDelegate
>

@property (nonatomic, strong) UIImageView   *iconImageView;
@property (nonatomic, strong) UIImageView   *sexImageView;
@property (nonatomic, strong) UIImageView   *ageBgImageView;

@property (nonatomic, strong) UILabel       *nickNameLb;
@property (nonatomic, strong) UILabel       *ageLb;
@property (nonatomic, strong) UILabel       *timeLb;
@property (nonatomic, strong) UILabel       *contentLb;
@property (nonatomic, strong) UILabel       *addressLb;

@property (nonatomic, strong) UIButton      *chatBtn;
@property (nonatomic, strong) UIButton      *loveBtn;
@property (nonatomic, strong) UIButton      *commentBtn;
@property (nonatomic, strong) UIButton      *moreBtn;
@property (nonatomic, strong) UIButton      *followBtn;
@property (nonatomic, strong) UIButton      *deleteBtn;
@property (nonatomic, strong) UIButton      *openBtn;

@property (nonatomic, strong) SLPhotoContainerView  *photoContainerView;

@property (nonatomic, strong) DynamicListModel      *dynamicListModel;

@property (nonatomic, weak) id<DynamicListTableViewCellDelegate>  delegate;

- (void)setData:(DynamicListModel *)dynamicHandle;

@end

NS_ASSUME_NONNULL_END
