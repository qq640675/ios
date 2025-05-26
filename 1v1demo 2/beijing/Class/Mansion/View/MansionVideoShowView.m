//
//  MansionVideoShowView.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/8.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MansionVideoShowView.h"
#import "ToolManager.h"

@implementation MansionVideoShowView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame isHouseOwner:(BOOL)isOwner isOwnerView:(BOOL)isOwnerView tag:(int)tag type:(MansionChatType)mansionType {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = XZRGB(0x5f30ca);
        self.tag = tag;
        self.layer.masksToBounds = YES;
        _isOwner = isOwner;
        _isOwnerView = isOwnerView;
        [self setSubViewsWithType:mansionType];
    }
    return self;
}

- (void)resetFrame:(CGRect)frame {
    self.frame = frame;
    _videoBG.frame = CGRectMake(0, 0, self.width, self.height);
    _videoImageV.frame = CGRectMake(0, 0, self.width, self.height);
    _voiceBtn.frame = CGRectMake(self.width-30, 0, 30, 30);
    
    if (_isOwner && !_isOwnerView) {
        _addButton.frame = CGRectMake(0, 0, self.width, self.height);
        _deleteBtn.frame = CGRectMake(self.width-30, 0, 30, 30);
        [_addButton setTitle:@"" forState:0];
        [_addButton setImagePosition:2 spacing:12];
        _voiceBtn.x = self.width-60;
    }
}

#pragma mark - SubViews
- (void)setSubViewsWithType:(MansionChatType)mansionType {
    _videoBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _videoBG.backgroundColor = UIColor.clearColor;
    _videoBG.hidden = YES;
    [self addSubview:_videoBG];
    
    _videoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _videoImageV.backgroundColor = UIColor.blackColor;
    _videoImageV.contentMode = UIViewContentModeScaleAspectFill;
    [_videoBG addSubview:_videoImageV];
    
    _voiceBtn = [UIManager initWithButton:CGRectMake(self.width-30, 0, 30, 30) text:@"" font:1 textColor:nil normalImg:@"mansion_room_voice" highImg:nil selectedImg:@"mansion_room_voice_close"];
    [_voiceBtn addTarget:self action:@selector(voiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_videoBG addSubview:_voiceBtn];
    
    if (_isOwnerView) {
        _videoBG.hidden = NO;
        self.layer.cornerRadius = 8;
    } else {
        if (_isOwner) {
            _addButton = [UIManager initWithButton:CGRectMake(0, 0, self.width, self.height) text:@"邀请你的女神来聊聊" font:15 textColor:UIColor.whiteColor normalImg:@"mansion_btn_invite" highImg:nil selectedImg:nil];
            _addButton.backgroundColor = UIColor.clearColor;
            [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [_addButton setImagePosition:2 spacing:12];
            [self addSubview:_addButton];
            [self sendSubviewToBack:_addButton];
            
            _voiceBtn.x = self.width-60;
            _deleteBtn = [UIManager initWithButton:CGRectMake(self.width-30, 0, 30, 30) text:@"" font:1 textColor:nil normalImg:@"mansion_room_delete" highImg:nil selectedImg:nil];
            [_deleteBtn addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [_videoBG addSubview:_deleteBtn];
        }
    }
    
    if (mansionType == MansionChatTypeVideo) {
        self.cameraBtn = [UIManager initWithButton:CGRectZero text:@"" font:1 textColor:nil normalImg:@"mansion_btn_camerachange" highImg:nil selectedImg:nil];
        self.cameraBtn.hidden = YES;
        [self.cameraBtn addTarget:self action:@selector(cameraButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_videoBG addSubview:self.cameraBtn];
        [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(self.voiceBtn.mas_left).offset(0);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        UIView *shadowV = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-40, self.width, 40)];
        shadowV.clipsToBounds = YES;
        [ToolManager mutableColor:[UIColor.blackColor colorWithAlphaComponent:0.01] end:[UIColor.blackColor colorWithAlphaComponent:0.4] isH:NO view:shadowV];
        [_videoBG addSubview:shadowV];
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 26, 26)];
        self.headImageView.image = [UIImage imageNamed:@"default"];
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.cornerRadius = 13;
        [shadowV addSubview:self.headImageView];
        
        self.nameLabel = [UIManager initWithLabel:CGRectMake(39, 7, shadowV.width-45, 26) text:@"" font:15 textColor:UIColor.whiteColor];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        [shadowV addSubview:self.nameLabel];
    }
}

#pragma mark - func
- (void)addButtonClick {
    if (self.addButtonClickBlock) {
        self.addButtonClickBlock();
    }
}

- (void)deleteButtonClick {
    if (self.deleteButtonClickBlock) {
        self.deleteButtonClickBlock();
    }
}

- (void)voiceButtonClick:(UIButton *)sender {
    if (self.voiceButtonClickBlock) {
        self.voiceButtonClickBlock(sender);
    }
}

- (void)cameraButtonClick:(UIButton *)sender {
    if (self.cameraButtonClickBlock) {
        self.cameraButtonClickBlock();
    }
}


@end
