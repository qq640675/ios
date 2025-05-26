//
//  SLPhotoContainerView.h
//  GY_Teacher
//
//  Created by apple on 2017/4/8.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Frame.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "DynamicFileModel.h"

@protocol SLPhotoContainerViewDelegate <NSObject>

- (void)lookPrivateFile:(DynamicFileModel *)model;

- (void)updateVip;

- (void)playVideo;

@end

@interface SLPhotoContainerView : UIView

@property (nonatomic, strong) NSMutableArray    *picUrlArray;

@property (nonatomic, assign) BOOL      isMine;

@property (nonatomic, weak) id<SLPhotoContainerViewDelegate>    delegate;

- (void)setupFileModelArray:(NSMutableArray *)fileModelArray isMine:(BOOL)isMine;

@end
