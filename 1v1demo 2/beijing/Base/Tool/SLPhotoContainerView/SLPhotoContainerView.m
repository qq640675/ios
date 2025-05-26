//
//  SLPhotoContainerView.m
//  GY_Teacher
//
//  Created by apple on 2017/4/8.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "SLPhotoContainerView.h"
#import "SLPhotoBrowser.h"
#import "SLPhotoLockView.h"
#import "YLTapGesture.h"
#import "BaseView.h"
#import "PrivacyCheckAlertView.h"

static NSUInteger const picCount = 9;

@interface SLPhotoContainerView ()
<
SLPhotoBrowserDelegate
>

@property (nonatomic, strong) NSMutableArray    *imageViewArray;

@property (nonatomic, strong) NSMutableArray    *lockViewArray;


@property (nonatomic, strong) DynamicFileModel  *actionFileModel;

@end

@implementation SLPhotoContainerView



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setExclusiveTouch:YES];
        [self setupImageView];
    }
    return self;
}

- (void)setupImageView {
    NSMutableArray *temp = [NSMutableArray new];
    NSMutableArray *lock = [NSMutableArray new];

    //最多9张图片，初始化imageView
    for (int i = 0; i < picCount; i ++) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 5;
        imageView.tag = i+100;
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedImageView:)];
        [imageView addGestureRecognizer:tap];
        //放入到数组中
        [temp addObject:imageView];
        
        SLPhotoLockView *lockView = [SLPhotoLockView new];
        lockView.layer.masksToBounds = YES;
        lockView.layer.cornerRadius = 6;
        UITapGestureRecognizer *tapLock = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedImageView:)];
        [lockView addGestureRecognizer:tapLock];
        [self addSubview:lockView];
        lockView.tag = 1000+i;
        [lock addObject:lockView];
    }


    self.imageViewArray = [temp copy];
    self.lockViewArray  = [lock copy];
}

- (void)setupFileModelArray:(NSMutableArray *)fileModelArray isMine:(BOOL)isMine {
    _picUrlArray = fileModelArray;
    _isMine = isMine;
    
    CGFloat width  = 0.0;
    CGFloat height = 0.0;
    
    //隐藏多余的imageView
    for (long i = [fileModelArray count]; i < [_imageViewArray count]; i ++) {
        UIImageView *imageView = _imageViewArray[i];
        imageView.hidden = YES;
        
    }
    
    for (SLPhotoLockView *lockView in _lockViewArray) {
        lockView.hidden = YES;
        UILabel *timeLb = [lockView viewWithTag:100];
        timeLb.text = nil;
        UIVisualEffectView *effectView = [lockView viewWithTag:99];
        effectView.hidden = NO;
        UIImageView *lockImageView = [lockView viewWithTag:10];
        lockImageView.image = [UIImage imageNamed:@"Dynamic_list_lock"];
    }
    
    if ([fileModelArray count] == 1) {
        UIImageView *imageView = [_imageViewArray firstObject];
        imageView.hidden = NO;
        width = 180;
        height= 240;
        imageView.frame = CGRectMake(0, 0, width, height);
        
        DynamicFileModel *model = [fileModelArray firstObject];
        //图片或者视频
        if (model.t_file_type == 0) {
            //图片
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.t_file_url] placeholderImage:[UIImage imageNamed:@"loading"]];
            if (model.isPrivate && !model.isConsume && !isMine) {
                SLPhotoLockView *lockView = self.lockViewArray[0];
                lockView.frame = imageView.frame;
                lockView.hidden = NO;
                UIImageView *lockImageView = [lockView viewWithTag:10];
                lockImageView.image = [UIImage imageNamed:@"Dynamic_list_lock_big"];
                UILabel *timeLb = [lockView viewWithTag:100];
                timeLb.text = nil;
                UIVisualEffectView *effectView = [lockView viewWithTag:99];
                effectView.hidden = NO;
            }
            
        } else {
            //视频
            SLPhotoLockView *lockView  = self.lockViewArray[0];
            UIImageView *lockImageView = [lockView viewWithTag:10];
            UILabel *timeLb = [lockView viewWithTag:100];
            UIVisualEffectView *effectView = [lockView viewWithTag:99];
            lockView.frame  = imageView.frame;
            lockView.hidden = NO;
            timeLb.text = model.t_video_time;
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.t_cover_img_url] placeholderImage:[UIImage imageNamed:@"loading"]];
            
            if (model.isPrivate && !model.isConsume && !isMine) {
                lockImageView.image = [UIImage imageNamed:@"Dynamic_list_lock_big"];
                effectView.hidden = NO;
            } else {
                lockImageView.image = [UIImage imageNamed:@"AnthorDetail_dynamic_video"];
                effectView.hidden = YES;
            }
        }
    }
    CGFloat margin  = 3;
    if ([fileModelArray count] == 2) {
        UIImageView *leftImageView  = _imageViewArray[0];
        UIImageView *rightImageView = _imageViewArray[1];
        
        leftImageView.hidden = NO;
        rightImageView.hidden = NO;
        
        width = 135;
        height= 135;
        
        leftImageView.frame = CGRectMake(0, 0, width, height);
        rightImageView.frame= CGRectMake(width+margin, 0, width, height);
        
        DynamicFileModel *leftModel = fileModelArray[0];
        DynamicFileModel *rightModel= fileModelArray[1];
        
        
        //图片
        [leftImageView sd_setImageWithURL:[NSURL URLWithString:leftModel.t_file_url] placeholderImage:[UIImage imageNamed:@"loading"]];
        if (leftModel.isPrivate && !leftModel.isConsume && !isMine) {
            SLPhotoLockView *lockView = self.lockViewArray[0];
            lockView.frame = leftImageView.frame;
            lockView.hidden = NO;
        }
        
        //图片
        [rightImageView sd_setImageWithURL:[NSURL URLWithString:rightModel.t_file_url] placeholderImage:[UIImage imageNamed:@"loading"]];
        if (rightModel.isPrivate && !rightModel.isConsume && !isMine) {
            SLPhotoLockView *lockView = self.lockViewArray[1];
            lockView.frame = rightImageView.frame;
            lockView.hidden = NO;
        }
    }
    if ([fileModelArray count] > 2) {
        width = (App_Frame_Width-106)/3;
        height= width;
        
        //枚举
        [fileModelArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //列数 行数
            NSInteger columnIndex = idx % 3;
            NSInteger rowIndex = idx / 3;
            
            UIImageView *imageView = self.imageViewArray[idx];
            imageView.hidden = NO;
            imageView.frame  = CGRectMake(columnIndex * (width + margin), rowIndex * (height + margin), width, height);
            DynamicFileModel *model = fileModelArray[idx];
            NSString *imgUrl = model.t_file_url;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
            if (model.isPrivate && !model.isConsume && !isMine) {
                SLPhotoLockView *lockView = self.lockViewArray[idx];
                lockView.frame = imageView.frame;
                lockView.hidden = NO;
            }
        }];
    }
        
        
}

- (void)setPicUrlArray:(NSMutableArray *)picUrlArray {
    _picUrlArray = picUrlArray;
    
    //隐藏多余的imageView
    for (long i = [_picUrlArray count]; i < [_imageViewArray count]; i ++) {
        UIImageView *imageView = _imageViewArray[i];
        imageView.hidden = YES;
    }
    //如果没图片返回高度为0
    if ([_picUrlArray count] == 0) {
        self.height = 0;
        return;
    }
    
    //图片的宽度和高度一样 每行最多3张
    CGFloat width   = 80;
    CGFloat height  = width;
    CGFloat margin  = 10;
    
    //枚举
    [_picUrlArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //列数 行数
        NSInteger columnIndex = idx % 3;
        NSInteger rowIndex = idx / 3;
        
        UIImageView *imageView = self.imageViewArray[idx];
        imageView.hidden = NO;
        imageView.frame  = CGRectMake(columnIndex * (width + margin), rowIndex * (height + margin), width, height);
        NSString *imgUrl = self.picUrlArray[idx];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
        
    }];
    
}

- (void)clickedImageView:(UITapGestureRecognizer *)tap {
    
    if ([tap.view isKindOfClass:[SLPhotoLockView class]]) {
        self.actionFileModel = _picUrlArray[tap.view.tag-1000];
        if (_actionFileModel.isPrivate && !_actionFileModel.isConsume && !_isMine) {
            //私密
            if (![YLUserDefault userDefault].t_is_vip) {
                //如果是会员
                if (_actionFileModel.t_file_type == 1) {
                    //视频
                    if (_delegate && [_delegate respondsToSelector:@selector(playVideo)]) {
                        [_delegate playVideo];
                    }
                } else {
                    SLPhotoBrowser *browser = [[SLPhotoBrowser alloc] init];
                    browser.currentImageIndex = tap.view.tag-1000;
                    browser.sourceImagesContainerView = self;
                    browser.imageCount = self.picUrlArray.count;
                    browser.delegate   = self;
                    
                    //显示大图浏览
                    [browser show];
                }
            } else {
                //不是会员
                [self addWindowView];
            }
            
        } else {
            if (_actionFileModel.t_file_type == 1) {
                //视频
                if (_delegate && [_delegate respondsToSelector:@selector(playVideo)]) {
                    [_delegate playVideo];
                }
            }
        }
        
    } else {
        SLPhotoBrowser *browser = [[SLPhotoBrowser alloc] init];
        browser.currentImageIndex = tap.view.tag-100;
        browser.sourceImagesContainerView = self;
        browser.imageCount = self.picUrlArray.count;
        browser.delegate   = self;
        
        //显示大图浏览
        [browser show];
    }
    
}

- (void)addWindowView {
    //加锁
    WEAKSELF;
    NSString *type = @"";
    if (_actionFileModel.t_file_type == 0) {
        type = @"照片";
    } else {
        type = @"视频";
    }
    PrivacyCheckAlertView *alertView = [[PrivacyCheckAlertView alloc] initWithType:type coin:(int)_actionFileModel.t_gold];
    alertView.sureButtonClickBlock = ^{
        [weakSelf clickedOkBtn];
    };
}

- (void)clickedOkBtn {
    if (_delegate && [_delegate respondsToSelector:@selector(lookPrivateFile:)]) {
        [_delegate lookPrivateFile:_actionFileModel];
    }
}

- (void)photoBrowser:(SLPhotoBrowser *)browser lookImagePrivateForIndex:(NSInteger)index {

    self.actionFileModel = _picUrlArray[index];
    [self addWindowView];
}

#pragma mark - 
#pragma mark - SLPhotoBrowserDelegate
- (NSURL *)photoBrowser:(SLPhotoBrowser *)browser imageURLForIndex:(NSInteger)index {
    DynamicFileModel *model = _picUrlArray[index];
    return [NSURL URLWithString:model.t_file_url];
}

- (UIImage *)photoBrowser:(SLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    UIImageView *imageView = _imageViewArray[index];
    return imageView.image;
}

- (BOOL)photoBrowser:(SLPhotoBrowser *)browser isImagePrivateForIndex:(NSInteger)index {
    DynamicFileModel *model = _picUrlArray[index];
    if (![YLUserDefault userDefault].t_is_vip) {
        return NO;
    }
    return (model.isPrivate && !model.isConsume && !_isMine);
}

//有多少列
- (NSInteger)columnCountForArray:(NSArray *)array
{
    if (array.count < 2) {
        return 1;
    } else if (array.count < 3) {
        return 2;
    } else {
        return 3;
    }
}

//有多少行
- (NSInteger)rowCountForArray:(NSArray *)array
{
    if (array.count < 4) {
        return 1;
    } else if (array.count < 7) {
        return 2;
    } else {
        return 3;
    }
}


@end
