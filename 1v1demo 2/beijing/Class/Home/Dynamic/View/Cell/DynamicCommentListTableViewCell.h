//
//  DynamicCommentListTableViewCell.h
//  beijing
//
//  Created by yiliaogao on 2019/1/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseTableViewCell.h"
#import "DynamicCommentListModel.h"

@protocol DynamicCommentListTableViewCellDelegate <NSObject>

- (void)didSelectDynamicCommentListTableViewCellWithDelete:(DynamicCommentListModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DynamicCommentListTableViewCell : SLBaseTableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *sexImageView;

@property (nonatomic, strong) UIButton    *deleteBtn;

@property (nonatomic, strong) UILabel     *nickNameLb;
@property (nonatomic, strong) UILabel     *contentLb;
@property (nonatomic, strong) UILabel     *timeLb;

@property (nonatomic, strong) DynamicCommentListModel   *commentListModel;

@property (nonatomic, weak) id<DynamicCommentListTableViewCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
