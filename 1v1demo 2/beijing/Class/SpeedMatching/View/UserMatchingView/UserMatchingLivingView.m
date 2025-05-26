//
//  UserMatchingLivingView.m
//  beijing
//
//  Created by yiliaogao on 2019/2/20.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "UserMatchingLivingView.h"

@implementation UserMatchingLivingView
{
    UIView *smallCloseV;
    UILabel *smallTipL;
    UIView *bigCloseV;
    UILabel *bigTipL;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    
    [self addSubview:self.fullVideoImageView];
    
    [self addSubview:self.fullVideoBlackView];
    
    [self addSubview:self.userMatchingLivingPersonView];

    [self addSubview:self.anchorMatchingLivingPersonView];
    
    [self addSubview:self.smallRightTopVideoImageView];
    
    [self addSubview:self.smallRightTopVideoBlackView];
    
    [self addSubview:self.userMatchingLivingActionView];
    
    [self addSubview:self.msgListVC.view];
    
    [self addSubview:self.chatLivingTextView];
    
    bigCloseV = [self createClosrCameraisBig:YES superView:self.fullVideoBlackView labelTag:222];
    bigTipL = [bigCloseV viewWithTag:222];
    
    smallCloseV = [self createClosrCameraisBig:NO superView:self.smallRightTopVideoBlackView labelTag:333];
    smallTipL = [smallCloseV viewWithTag:333];
}

- (UIView *)createClosrCameraisBig:(BOOL)isBig superView:(UIView *)superV labelTag:(int)tag {
    UIView *view = [[UIView alloc] init];//90 90
    view.backgroundColor = UIColor.clearColor;
    view.hidden = YES;
    if (isBig) {
        view.frame = CGRectMake((App_Frame_Width-90)/2, APP_Frame_Height-225, 90, 90);
    } else {
        view.frame = CGRectMake(0, 80, 90, 90);
    }
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_cry"]];
    imageV.frame = CGRectMake(30, 30, 30, 30);
    [view addSubview:imageV];
    
    UILabel *tipL = [UIManager initWithLabel:CGRectMake(0, 60, 90, 30) text:@"对方关闭了摄像头" font:10 textColor:UIColor.whiteColor];
    tipL.tag = tag;
    [view addSubview:tipL];
    
    [superV addSubview:view];
    
    return view;
}


- (void)setIsShowCloseCamera:(BOOL)isShow isBigView:(BOOL)isBig isSelf:(BOOL)isSelf {
    bigCloseV.hidden = YES;
    smallCloseV.hidden = YES;
    self.fullVideoBlackView.backgroundColor = UIColor.clearColor;
    self.smallRightTopVideoBlackView.backgroundColor = UIColor.clearColor;
    if (isShow) {
        if (isBig) {
            bigCloseV.hidden = NO;
            self.fullVideoBlackView.backgroundColor = UIColor.blackColor;
        } else {
            smallCloseV.hidden = NO;
            self.smallRightTopVideoBlackView.backgroundColor = UIColor.blackColor;
        }
    }
    if (isSelf) {
        smallTipL.text = @"我关闭了摄像头";
        bigTipL.text = @"我关闭了摄像头";
    } else {
        smallTipL.text = @"对方关闭了摄像头";
        bigTipL.text = @"对方关闭了摄像头";
    }
}

- (void)setAnchorModel:(UserMatchingAnchorModel *)anchorModel {
    _anchorModel = anchorModel;
    [_userMatchingLivingPersonView initWithData:_anchorModel];
}

- (void)setPersonHandle:(PersonalDataHandle *)personHandle {
    _personHandle = personHandle;
    [_anchorMatchingLivingPersonView initWithData:_personHandle];
}

- (void)setIsUserMatching:(BOOL)isUserMatching {
    _isUserMatching = isUserMatching;
    _userMatchingLivingPersonView.hidden = !_isUserMatching;
    _anchorMatchingLivingPersonView.hidden = _isUserMatching;
    _userMatchingLivingActionView.isUserMatching = _isUserMatching;
}

- (void)chatLivingMsgListData:(NSString *)content isSelf:(BOOL)isSelf isSystemMsg:(BOOL)isSystemMsg {
    NSMutableArray *list = [NSMutableArray new];
    ChatLivingMsgListModel *model = [[ChatLivingMsgListModel alloc] init];
    model.content = content;
    model.isSelf  = isSelf;
    model.isSystemMsg = isSystemMsg;
    [list addObject:model];
    _msgListVC.listArray = list;
}

- (ChatLivingMsgListViewController *)msgListVC {
    if (!_msgListVC) {
        _msgListVC = [[ChatLivingMsgListViewController alloc] init];
        _msgListVC.view.frame = CGRectMake(15, APP_Frame_Height-380, App_Frame_Width-30, 180);
    }
    return _msgListVC;
}

- (UserMatchingLivingPersonView *)userMatchingLivingPersonView {
    if (!_userMatchingLivingPersonView) {
        _userMatchingLivingPersonView = [[UserMatchingLivingPersonView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight-44, App_Frame_Width, 60)];
    }
    return _userMatchingLivingPersonView;
}

- (AnchorMatchingLivingPersonView *)anchorMatchingLivingPersonView {
    if (!_anchorMatchingLivingPersonView) {
        _anchorMatchingLivingPersonView = [[AnchorMatchingLivingPersonView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight-44, App_Frame_Width, 60)];
    }
    return _anchorMatchingLivingPersonView;
}

- (UserMatchingLivingActionView *)userMatchingLivingActionView {
    if (!_userMatchingLivingActionView) {
        _userMatchingLivingActionView = [[UserMatchingLivingActionView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height-140, App_Frame_Width, 140)];
    }
    return _userMatchingLivingActionView;
}

- (UIImageView *)fullVideoImageView {
    if (!_fullVideoImageView) {
        _fullVideoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
        _fullVideoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _fullVideoImageView.clipsToBounds = YES;
    }
    return _fullVideoImageView;
}

- (UIView *)fullVideoBlackView {
    if (!_fullVideoBlackView) {
        _fullVideoBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
        _fullVideoBlackView.backgroundColor = [UIColor clearColor];
    }
    return _fullVideoBlackView;
}

- (UIImageView *)smallRightTopVideoImageView {
    if (!_smallRightTopVideoImageView) {
        _smallRightTopVideoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width-100, SafeAreaTopHeight-44, 90, 172)];
        _smallRightTopVideoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _smallRightTopVideoImageView.clipsToBounds = YES;
    }
    return _smallRightTopVideoImageView;
}

- (UIView *)smallRightTopVideoBlackView {
    if (!_smallRightTopVideoBlackView) {
        _smallRightTopVideoBlackView = [[UIView alloc] initWithFrame:CGRectMake(App_Frame_Width-100, SafeAreaTopHeight-44, 90, 172)];
        _smallRightTopVideoBlackView.backgroundColor = [UIColor clearColor];
    }
    return _smallRightTopVideoBlackView;
}

- (ChatLivingTextView *)chatLivingTextView {
    if (!_chatLivingTextView) {
        _chatLivingTextView = [[ChatLivingTextView alloc] initWithFrame:CGRectMake(0, self.height, App_Frame_Width, 50)];
    }
    return _chatLivingTextView;
}








@end
