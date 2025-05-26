//
//  DynamicPicView.m
//  beijing
//
//  Created by yiliaogao on 2018/12/26.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "DynamicPicView.h"

@implementation DynamicPicView

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
    [self addSubview:self.deleteBtn];
//    [self addSubview:self.freeBtn];
}

- (void)setupWithImage:(UIImage *)image title:(NSString *)title {
    _imageView.image = image;
//    [_freeBtn setTitle:title forState:UIControlStateNormal];
//    if ([title isEqualToString:@"收费"] || [title isEqualToString:@"免费"]) {
//    } else {
//        if ([title isEqualToString:@"0"]) {
//            [_freeBtn setTitle:@"免费" forState:UIControlStateNormal];
//        } else {
//            [_freeBtn setTitle:[NSString stringWithFormat:@"%@金币", title] forState:UIControlStateNormal];
//        }
//    }
}

- (void)clickedBtn:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectDynamicPicViewBtn:)]) {
        [_delegate didSelectDynamicPicViewBtn:btn.tag];
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

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIManager initWithButton:CGRectMake(self.width-21, 0, 21, 21) text:nil font:0.0 textColor:KWHITECOLOR normalImg:@"Dynamic_release_delete" highImg:nil selectedImg:nil];
        [_deleteBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

//- (UIButton *)freeBtn {
//    if (!_freeBtn) {
//        _freeBtn = [UIManager initWithButton:CGRectMake(0, self.height-17, self.width, 17) text:@"免费" font:13 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
//        _freeBtn.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.42];
//        [_freeBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _freeBtn;
//}

@end
