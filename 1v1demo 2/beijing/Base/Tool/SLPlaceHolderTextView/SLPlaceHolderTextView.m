//
//  SLPlaceHolderTextView.m
//  LuNuBao_English
//
//  Created by apple on 2017/4/12.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "SLPlaceHolderTextView.h"

@implementation SLPlaceHolderTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:16.0];
        
        self.placeholderColor = [UIColor blackColor];
        
        //使用通知监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)textDidChange:(NSNotification *)note {
    //会重新调用drawRect:方法
    [self setNeedsDisplay];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/**
 * 每次调用drawRect:方法，都会将以前画的东西清除掉
 */
- (void)drawRect:(CGRect)rect {
    // 如果有文字 就直接返回
    if (self.hasText) {
        return;
    }
    
    //属性
    NSMutableDictionary *attrs = [NSMutableDictionary new];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
    
    //画文字
    rect.origin.x = 5;
    rect.origin.y = 8;
    rect.size.width -= 2*rect.origin.x;
    [self.placeholder drawInRect:rect withAttributes:attrs];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = [placeholderColor copy];
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}

//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//
//    if ([UIMenuController sharedMenuController]) {
//
//        [UIMenuController sharedMenuController].menuVisible = NO;
//
//    }
//    return NO;
//}

@end
