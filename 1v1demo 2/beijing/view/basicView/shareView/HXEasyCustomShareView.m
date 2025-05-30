//
//  HXEasyCustomShareView.m
//  HXEasyCustomShareView
//
//  Created by 黄轩 on 16/1/19.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "HXEasyCustomShareView.h"
#import "HXShareScrollView.h"

@implementation HXEasyCustomShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *zhezhaoView = [[UIView alloc] initWithFrame:frame];
        zhezhaoView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
        zhezhaoView.tag = 100;
        zhezhaoView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
        [zhezhaoView addGestureRecognizer:myTap];
        [self addSubview:zhezhaoView];
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 107)];
        _backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.9];
        _backView.userInteractionEnabled = YES;
        [self addSubview:_backView];
        
        _boderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, _backView.frame.size.height)];
        _boderView.backgroundColor = [UIColor clearColor];
        _boderView.userInteractionEnabled = YES;
        [self addSubview:_boderView];
        
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButton.frame = CGRectMake(0, 0, frame.size.width, 50);
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_cancleButton setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateNormal];
        [_cancleButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateHighlighted];
        [_cancleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancleButton];
    }
    return self;
}

-(void)setHeaderView:(UIView *)headerView {
    [_headerView removeFromSuperview];
    _headerView = headerView;
    [self addSubview:_headerView];
}

-(void)setFooterView:(UIView *)footerView {
    [_footerView removeFromSuperview];
    _footerView = footerView;
    [self addSubview:_footerView];
}

- (void)setShareAry:(NSArray *)shareAry delegate:(id)delegate {
    _delegate = delegate;
    
    if (_firstCount > shareAry.count || _firstCount == 0) {
        _firstCount = shareAry.count;
    }

    NSArray *ary1 = [shareAry subarrayWithRange:NSMakeRange(0,_firstCount)];
    NSArray *ary2 = [shareAry subarrayWithRange:NSMakeRange(_firstCount,shareAry.count-_firstCount)];

    HXShareScrollView *shareScrollView = [[HXShareScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [HXShareScrollView getShareScrollViewHeight])];
    [shareScrollView setShareAry:ary1 delegate:self];
    shareScrollView.showsHorizontalScrollIndicator = _showsHorizontalScrollIndicator;
    [_boderView addSubview:shareScrollView];
    
    if (_firstCount < shareAry.count) {
        //分割线
        self.middleLineLabel.frame = CGRectMake(0, shareScrollView.frame.origin.y+shareScrollView.frame.size.height, self.frame.size.width, 0.5);
        
        shareScrollView = [[HXShareScrollView alloc] initWithFrame:CGRectMake(0, _middleLineLabel.frame.origin.y+_middleLineLabel.frame.size.height, self.frame.size.width, [HXShareScrollView getShareScrollViewHeight])];
        [shareScrollView setShareAry:ary2 delegate:self];
        shareScrollView.showsHorizontalScrollIndicator = _showsHorizontalScrollIndicator;
        [_boderView addSubview:shareScrollView];
    }
}

- (UILabel *)middleLineLabel {
    if (!_middleLineLabel) {
        _middleLineLabel = [UILabel new];
        _middleLineLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
        [_boderView addSubview:_middleLineLabel];
    }
    return _middleLineLabel;
}

- (float)getBoderViewHeight:(NSArray *)shareAry firstCount:(NSInteger)count {
    _firstCount = count;
    float height = [HXShareScrollView getShareScrollViewHeight];
    
    if (_firstCount > shareAry.count || _firstCount == 0) {
        return height;
    }
    
    if (_firstCount < shareAry.count) {
        return height*2+1;
    }
    return 0;
}

#pragma mark HXShareScrollViewDelegate

- (void)shareScrollViewButtonAction:(HXShareScrollView *)shareScrollView title:(NSString *)title {
    if (_delegate && [_delegate respondsToSelector:@selector(easyCustomShareViewButtonAction:title:)]) {
        [_delegate easyCustomShareViewButtonAction:self title:title];
    }
}

- (void)cancleButtonAction:(UIButton *)sender {
    [self tappedCancel];
}

- (void)tapGestureRecognizerAction:(UITapGestureRecognizer *)sender {
    [self tappedCancel];
}

- (void)hideView
{
    [self tappedCancel];
}

- (void)tappedCancel {
    [UIView animateWithDuration:0.5 animations:^{
        UIView *zhezhaoView = (UIView *)[self viewWithTag:100];
        zhezhaoView.alpha = 0;
    
        if (self.backView) {
            self.backView.frame = CGRectMake(0, self.frame.size.height, self.backView.frame.size.width, self.backView.frame.size.height);
        }
        
        if (self.cancleButton) {
            self.cancleButton.frame = CGRectMake(0, self.cancleButton.frame.origin.y + self.backView.frame.size.height, self.cancleButton.frame.size.width, self.cancleButton.frame.size.height);
        }
        
        if (self.footerView) {
            self.footerView.frame = CGRectMake(0, self.footerView.frame.origin.y + self.backView.frame.size.height, self.footerView.frame.size.width, self.footerView.frame.size.height);
        }
        
        if (self.boderView) {
            self.boderView.frame = CGRectMake(0, self.boderView.frame.origin.y + self.backView.frame.size.height, self.boderView.frame.size.width, self.boderView.frame.size.height);
        }
        
        if (self.headerView) {
            self.headerView.frame = CGRectMake(0, self.headerView.frame.origin.y + self.backView.frame.size.height, self.headerView.frame.size.width, self.headerView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    float height = 0;
    
    if (_cancleButton) {
        height += _cancleButton.frame.size.height;
        _cancleButton.frame = CGRectMake(0, self.frame.size.height-height, _cancleButton.frame.size.width, _cancleButton.frame.size.height);
        _cancleButton.hidden = YES;
    }
    
    if (_footerView) {
        height += _footerView.frame.size.height;
        _footerView.frame = CGRectMake(0, self.frame.size.height-height, _footerView.frame.size.width, _footerView.frame.size.height);
        _footerView.hidden = YES;
    }
    
    if (_boderView) {
        height += _boderView.frame.size.height;
        _boderView.frame = CGRectMake(0, self.frame.size.height-height, _boderView.frame.size.width, _boderView.frame.size.height);
        _boderView.hidden = YES;
    }
    
    if (_headerView) {
        height += _headerView.frame.size.height;
        _headerView.frame = CGRectMake(0, self.frame.size.height-height, _headerView.frame.size.width, _headerView.frame.size.height);
        _headerView.hidden = YES;
    }
    
    if (_backView) {
        _backView.frame = CGRectMake(0, self.frame.size.height-height, _backView.frame.size.width, height);
        _backView.hidden = YES;
    }
    
    if (_cancleButton) {
        _cancleButton.frame = CGRectMake(0, _cancleButton.frame.origin.y + _backView.frame.size.height, _cancleButton.frame.size.width, _cancleButton.frame.size.height);
        _cancleButton.hidden = NO;
    }
    
    if (_footerView) {
        _footerView.frame = CGRectMake(0, _footerView.frame.origin.y + _backView.frame.size.height, _footerView.frame.size.width, _footerView.frame.size.height);
        _footerView.hidden = NO;
    }
    
    if (_boderView) {
        _boderView.frame = CGRectMake(0, _boderView.frame.origin.y + _backView.frame.size.height, _boderView.frame.size.width, _boderView.frame.size.height);
        _boderView.hidden = NO;
    }
    
    if (_headerView) {
        _headerView.frame = CGRectMake(0, _headerView.frame.origin.y + _backView.frame.size.height, _headerView.frame.size.width, _headerView.frame.size.height);
        _headerView.hidden = NO;
    }
    
    if (_backView) {
        _backView.frame = CGRectMake(0, self.frame.size.height, _backView.frame.size.width, _backView.frame.size.height);
        _backView.hidden = NO;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if (self.cancleButton) {
            self.cancleButton.frame = CGRectMake(0, self.cancleButton.frame.origin.y - self.backView.frame.size.height, self.cancleButton.frame.size.width, self.cancleButton.frame.size.height);
        }
        
        if (self.footerView) {
            self.footerView.frame = CGRectMake(0, self.footerView.frame.origin.y - self.backView.frame.size.height, self.footerView.frame.size.width, self.footerView.frame.size.height);
        }
        
        if (self.boderView) {
            self.boderView.frame = CGRectMake(0, self.boderView.frame.origin.y - self.backView.frame.size.height, self.boderView.frame.size.width, self.boderView.frame.size.height);
        }
        
        if (self.headerView) {
            self.headerView.frame = CGRectMake(0, self.headerView.frame.origin.y - self.backView.frame.size.height, self.headerView.frame.size.width, self.headerView.frame.size.height);
        }
        
        if (self.backView) {
            self.backView.frame = CGRectMake(0, self.frame.size.height - self.backView.frame.size.height, self.backView.frame.size.width, self.backView.frame.size.height);
        }
        
        UIView *zhezhaoView = (UIView *)[self viewWithTag:100];
        zhezhaoView.alpha = 0.9;
        
    } completion:^(BOOL finished) {
        
    }];
}
         
//颜色生成图片方法
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
     CGRect rect = CGRectMake(0, 0, size.width, size.height);
     
     UIGraphicsBeginImageContext(rect.size);
     
     CGContextRef context = UIGraphicsGetCurrentContext();
     
     CGContextSetFillColorWithColor(context,
                                    
                                    color.CGColor);
     CGContextFillRect(context, rect);
     UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     return img;
}

@end
