//
//  ChatLivePersonInfoView.m
//  beijing
//
//  Created by yiliaogao on 2019/2/26.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "ChatLivePersonInfoView.h"

@implementation ChatLivePersonInfoView

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
    
//    [self addSubview:self.animationImageView];
    
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.hidden = YES;
    self.coverImageView.backgroundColor = UIColor.blackColor;
    [self addSubview:self.coverImageView];
    
    [self addSubview:self.iconImageView];
    
    [self addSubview:self.nickNameLb];
    
    self.tipLabel = [UIManager initWithLabel:CGRectMake(self.nickNameLb.x, CGRectGetMaxY(self.nickNameLb.frame), self.nickNameLb.width, 25) text:@"邀请你视频聊天" font:14 textColor:UIColor.whiteColor];
    self.tipLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.tipLabel];
    
//    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake((App_Frame_Width-320)/2, 220, 320, 90)];
//    [tempView.layer setCornerRadius:5];
//    tempView.clipsToBounds   = YES;
//    tempView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.4];
//    [self addSubview:tempView];
//
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 22, 12, 14)];
//    imageView.image = IChatUImage(@"Generalpage_prompt");
//    [tempView addSubview:imageView];
//
//    UILabel *lb = [UIManager initWithLabel:CGRectMake(32, 10, 270, 70) text:@"平台倡导绿色交友,严禁低俗,色情,暴力,赌博,反动等不良内容,一旦涉及将或被屏蔽或封停账号,网警24小时在线巡查,敬请配合." font:12.0f textColor:[UIColor whiteColor]];
//    lb.numberOfLines = 0;
//    lb.textAlignment = NSTextAlignmentLeft;
//    [tempView addSubview:lb];
}

- (void)initWithData:(PersonalDataHandle *)handle {
    _nickNameLb.text = handle.t_nickName;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:handle.t_handImg] placeholderImage:[UIImage imageNamed:@"default"]];
    
    if (_isUser == YES) {
        //lsl update start
        if (handle.t_cover_img.length > 0) {
            [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:handle.t_cover_img]];
        } else {
            self.coverImageView.hidden = YES;
        }
        //lsl update end 
    }
}

- (void)setIsUser:(BOOL)isUser {
    _isUser = isUser;
    if (isUser == YES) {
        self.coverImageView.hidden = NO;
    }
}

//- (UIImageView *)animationImageView {
//    if (!_animationImageView) {
//        _animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width/2-50, 75, 100, 100)];
//    }
//    return _animationImageView;
//}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width-56, SafeAreaTopHeight-44+16, 50, 50)];
        _iconImageView.layer.cornerRadius = 4;
        _iconImageView.clipsToBounds      = YES;
        _iconImageView.backgroundColor    = [UIColor lightGrayColor];
    }
    return _iconImageView;
}

- (UILabel *)nickNameLb {
    if (!_nickNameLb) {
        _nickNameLb = [UIManager initWithLabel:CGRectMake(App_Frame_Width-66-180, SafeAreaTopHeight-44+16, 180, 25) text:@"昵称" font:20 textColor:[UIColor whiteColor]];
        _nickNameLb.font = [UIFont boldSystemFontOfSize:20];
        _nickNameLb.textAlignment = NSTextAlignmentRight;
    }
    return _nickNameLb;
}

@end
