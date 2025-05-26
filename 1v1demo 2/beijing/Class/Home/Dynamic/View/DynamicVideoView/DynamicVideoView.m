//
//  DynamicVideoView.m
//  beijing
//
//  Created by yiliaogao on 2018/12/26.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "DynamicVideoView.h"

@implementation DynamicVideoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.imageView];
//    [self addSubview:self.freeBtn];
    [self addSubview:self.timeLb];
}

- (void)setupWithImage:(UIImage *)image title:(NSString *)title secTime:(NSUInteger)time {
    _imageView.image = image;
    _timeLb.text = [SLHelper getMMSSFromSS:[NSString stringWithFormat:@"%lu",(unsigned long)time]];
//    [_freeBtn setTitle:title forState:UIControlStateNormal];
//    if ([title isEqualToString:@"收费"] || [title isEqualToString:@"免费"]) {
//
//    } else {
//        [_freeBtn setTitle:[NSString stringWithFormat:@"%@金币", title] forState:UIControlStateNormal];
//    }
}

- (void)clickedBtn:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectDynamicVideoViewBtn:)]) {
        [_delegate didSelectDynamicVideoViewBtn:btn.tag];
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

//- (UIButton *)freeBtn {
//    if (!_freeBtn) {
//        _freeBtn = [UIManager initWithButton:CGRectMake(0, self.height-20, self.width, 20) text:@"免费" font:13 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
//        _freeBtn.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.42];
//        [_freeBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
//
//    }
//    return _freeBtn;
//}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UIManager initWithLabel:CGRectMake(0, 0, 100, 20) text:@"00:10" font:14.0f textColor:KWHITECOLOR];
        _timeLb.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLb;
}

@end
